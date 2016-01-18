//
//  PlayerController.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/12.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "PlayerController.h"
#import <AVFoundation/AVFoundation.h>

// view
#import "WtyView.h"
#import "WtyNavigationBar.h"
#import "PlayerFooterView.h"
#import "PlayerHeaderView.h"
// tool
#import "UIColor+AddColor.h"

#define RADIUS 115
#define ICONWIDTH 170
#define ALLANGLE 350

@interface PlayerController ()
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, strong) PlayerFooterView *playerFooter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) WtyView *wtyView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) PlayerHeaderView *headerView;
@property (nonatomic, assign) NSInteger angle;
@end

@implementation PlayerController

#pragma mark - 创建单例对象
+ (PlayerController *)sharedManager
{
    static PlayerController *player = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        player = [[self alloc] init];
    });
    return player;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏音符" object:nil];
    
    if (self.wtyView == nil) {
        [self createWtyViewWithCurrentTime:0 durationTime:1];
    }
    
    [self setupTitleWithString:self.musicModel.name textColor:[UIColor whiteColor] font:17];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.angle = 0;
    
    [self setupNavigationItemWithImageName:@"iconfont-newlisticon06" andFrame:CGRectMake(0, 0, 22, 22) action:@selector(backButtonClick) isLeft:YES];
    
    [self createPlayer];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sliderClick:) name:@"点击进度条" object:nil];

}

#pragma mark - 进度条点击通知
- (void)sliderClick:(NSNotification *)noti
{
    // 改变播放进度
    int32_t timer = self.player.currentItem.asset.duration.timescale;
    Float64 timeValue = [noti.object[@"currentAngle"] doubleValue] * CMTimeGetSeconds(self.player.currentItem.duration) / ALLANGLE;
    [self.player seekToTime:CMTimeMakeWithSeconds(timeValue, timer) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    // 进度条显示
    [self.wtyView removeFromSuperview];
    [self createWtyViewWithCurrentTime:[noti.object[@"currentAngle"] intValue] durationTime:ALLANGLE];
    
    BOOL isplay = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"];
    if (isplay == NO) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isPlaying"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
        [self.player play];
        [self resumeTimer];
    }
    
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"显示音符" object:nil];
}


- (void)setMusicModel:(MusicModel *)musicModel
{
    _musicModel = musicModel;
    
    if (self.mp3Url != nil && ![_musicModel.mp3Url isEqualToString:self.mp3Url]) {
        
//        self.angle = -90;
//        self.icon.transform = CGAffineTransformMakeRotation(-90);
//        [self.playerFooter removeFromSuperview];
        [self createSongInformation];
        [self createPlayer];
        [self createSingImage];
        [self createFooterView];
        
        [self setupTitleWithString:self.musicModel.name textColor:[UIColor whiteColor] font:17];
    }
}



#pragma mark - 创建音乐播放器
- (void)createPlayer
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.musicModel.mp3Url]];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
   // 播放
    [self.player play];
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.mp3Url = self.musicModel.mp3Url;
    
    
}


- (void)createUI
{
    
//     背景
    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImage.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:self.backgroundImage];
    

    [self createSongInformation];
    
    
    [self createSingImage];
    
    
    [self createFooterView];
    
}

- (void)createSongInformation
{
    if (self.headerView == nil) {
        self.headerView = [[NSBundle mainBundle] loadNibNamed:@"PlayerHeaderView" owner:nil options:nil].firstObject;
        self.headerView.backgroundColor = [UIColor clearColor];
        self.headerView.frame = CGRectMake(0, 64, WIDTH, 50);
        [self.view addSubview:self.headerView];
    }
    self.headerView.singerLabel.text = self.musicModel.singer;
    self.headerView.albumLabel.text = self.musicModel.album;
}

- (void)createSingImage
{
    if (self.icon == nil) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICONWIDTH, ICONWIDTH)];
        self.icon.center = self.view.center;
        self.icon.layer.cornerRadius = ICONWIDTH / 2;
        self.icon.layer.borderWidth = 3;
        self.icon.layer.borderColor = [[UIColor colorFromHexCode:@"#ffffff"] CGColor];
        self.icon.clipsToBounds = YES;
        [self.view addSubview:self.icon];
        
        [self startAnimation];
    }
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.musicModel.picUrl] placeholderImage:nil];
    
    
}



- (void)startAnimation
{
    
    __block PlayerController *play = self;
    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        play.icon.transform = CGAffineTransformMakeRotation(play.angle);
    } completion:^(BOOL finished) {
        play.angle += 90;
        [play startAnimation];
    }];
    
}



#pragma mark - 尾部控件
- (void)createFooterView
{
    CGFloat footerX = 0;
    CGFloat footerH = 100;
    CGFloat footerW = WIDTH;
    CGFloat footerY = HEIGHT - footerH;
    if (self.playerFooter == nil) {
        self.playerFooter = [[[NSBundle mainBundle] loadNibNamed:@"PlayerFooterView" owner:nil options:nil] lastObject];
        self.playerFooter.backgroundColor = [UIColor clearColor];
        self.playerFooter.frame = CGRectMake(footerX, footerY, footerW, footerH);
        [self.view addSubview:self.playerFooter];
    }
   
    
    BOOL isplaying = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"];
    if (isplaying == YES) {
        [self.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
    } else
    {
        [self.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
    }
    
    BOOL isSequential = [[NSUserDefaults standardUserDefaults] boolForKey:@"sequentialPlay"];
    // 是顺序播放
    if (isSequential == YES) {
        // 随机播放图标可以点击
        [self.playerFooter.randomPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suijibofang"] forState:UIControlStateNormal];
        [self.playerFooter.randomPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suijibofang"] forState:UIControlStateHighlighted];
        
        // 顺序播放图标不可以点击
        [self.playerFooter.orderPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shunxubofang_gray"] forState:UIControlStateNormal];
        [self.playerFooter.orderPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shunxubofang_gray"] forState:UIControlStateHighlighted];
    } else  // 随机播放
    {
        // 随机播放图标不可以点击
        [self.playerFooter.randomPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suijibofang_gray"] forState:UIControlStateNormal];
        [self.playerFooter.randomPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suijibofang_gray"] forState:UIControlStateHighlighted];
        
        // 顺序播放图标可以点击
        [self.playerFooter.orderPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shunxubofang"] forState:UIControlStateNormal];
        [self.playerFooter.orderPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shunxubofang"] forState:UIControlStateHighlighted];
    }
    
    __weak PlayerController *play = self;
    
    // 点击随机播放
    [self.playerFooter setRandomPlayButtonBlock:^(){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sequentialPlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        play.playerFooter.randomPlayButton.userInteractionEnabled = NO;
        play.playerFooter.orderPlayButton.userInteractionEnabled = YES;
        
        // 随机播放图标不可以点击
        [play.playerFooter.randomPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suijibofang_gray"] forState:UIControlStateNormal];
        [play.playerFooter.randomPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suijibofang_gray"] forState:UIControlStateHighlighted];
        
        // 顺序播放图标可以点击
        [play.playerFooter.orderPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shunxubofang"] forState:UIControlStateNormal];
        [play.playerFooter.orderPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shunxubofang"] forState:UIControlStateHighlighted];
        
    }];
    
    // 点击上一首
    [self.playerFooter setLastButtonBlock:^(){
    
    }];
    
    // 点击暂停/开始
    [self.playerFooter setPauseButtonBlock:^(void){
        BOOL isplaying = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"];
        [[NSUserDefaults standardUserDefaults] setBool:!isplaying forKey:@"isPlaying"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (isplaying == YES) {
            [play.player pause];
            [play.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
            [play pausuTimer];
            
        } else {
            [play.player play];
            [play.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
            [play resumeTimer];
        }
        
    }];
    
    // 点击下一首
    [self.playerFooter setNextButtonBlock:^(){
        
    }];
    
    // 点击循环播放
    [self.playerFooter setOrderPlayButtonBlock:^(){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sequentialPlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        play.playerFooter.randomPlayButton.userInteractionEnabled = YES;
        play.playerFooter.orderPlayButton.userInteractionEnabled = NO;
        
        // 随机播放图标可以点击
        [play.playerFooter.randomPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suijibofang"] forState:UIControlStateNormal];
        [play.playerFooter.randomPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-suijibofang"] forState:UIControlStateHighlighted];
        
        // 顺序播放图标不可以点击
        [play.playerFooter.orderPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shunxubofang_gray"] forState:UIControlStateNormal];
        [play.playerFooter.orderPlayButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shunxubofang_gray"] forState:UIControlStateHighlighted];

    }];
    
}



- (void)createBackgroundImage
{
    // 在子线程下载图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.musicModel.picUrl]];
        
        self.image = [UIImage imageWithData:data];
        
        // 主线程显示
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.backgroundImage == nil) {
                self.backgroundImage = [[UIImageView alloc] init];
                self.backgroundImage.frame = self.view.bounds;
                self.backgroundImage.image = self.image;
                
//                [self.view addSubview:self.backgroundImage];
                
                self.backgroundImage.alpha = 0;
                [UIView animateWithDuration:2 animations:^{
                    self.backgroundImage.alpha = 1;
                }];
                
                [self.view insertSubview:self.backgroundImage atIndex:0];
            }
            else
            {
                self.backgroundImage.image = self.image;
                self.backgroundImage.alpha = 0;
                [UIView animateWithDuration:2 animations:^{
                    self.backgroundImage.alpha = 1;
                }];
            
            }
            
        });
        
    });
    
    
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
//        
//        
//        GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//        blurFilter.blurRadiusInPixels = 10.0;
//        UIImage *image = [UIImage imageWithData:data];
//        self.image = image;
//        UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
//        self.coverImageObject = blurredImage;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.backgroundImageView == nil) {
//                
//                self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//                [self.view addSubview:self.backgroundImageView];
//                self.backgroundImageView.image = blurredImage;
//                self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
//                self.backgroundImageView.clipsToBounds = YES;
//                
//                self.backgroundImageView.alpha = 0;
//                [UIView animateWithDuration:2 animations:^{
//                    self.backgroundImageView.alpha = 1;
//                }];
//                
//                self.blockView = [[UIView alloc]initWithFrame:self.backgroundImageView.bounds];
//                [self.backgroundImageView addSubview:self.blockView];
//                self.blockView.backgroundColor = [UIColor whiteColor];
//                self.blockView.alpha = 0.4;
//                
//                [self.view sendSubviewToBack:self.backgroundImageView];
//            }else{
//                self.backgroundImageView.image = blurredImage;
//                self.backgroundImageView.alpha = 0;
//                [UIView animateWithDuration:2 animations:^{
//                    self.backgroundImageView.alpha = 1;
//                }];
//            }
//        });
//    });

}

#pragma mark - 定时器监听事件
- (void)timerStart
{
    CMTime durationTime = self.player.currentItem.duration;
    if (CMTIME_IS_INVALID(durationTime)) {
         self.playerFooter.timeLabel.text = @"";
    }
    
    int duration = [[NSString stringWithFormat:@"%lf",CMTimeGetSeconds(durationTime)] intValue];
    int current = [[NSString stringWithFormat:@"%lf",CMTimeGetSeconds(self.player.currentItem.currentTime)] intValue];
    
    self.playerFooter.timeLabel.text = [NSString stringWithFormat:@"%d:%.2d/%d:%.2d",current/60,current%60,duration/60,duration%60];
    
    
    if (duration != 0) {
        
        [self.wtyView removeFromSuperview];

        [self createWtyViewWithCurrentTime:current durationTime:duration];
    }
    
}

#pragma mark - 暂停定时器
- (void)pausuTimer
{
    self.timer.fireDate = [NSDate distantFuture];
}

#pragma mark 恢复定时器
- (void)resumeTimer
{
    self.timer.fireDate = [NSDate distantPast];
}

#pragma mark - 创建进度条视图（WTYView）
- (void)createWtyViewWithCurrentTime:(int)currentTime durationTime:(int)durantionTime
{
    self.wtyView = [[WtyView alloc] initWithFrame:CGRectMake(0, 0, RADIUS * 2 + 15, RADIUS * 2 + 15)];
    self.wtyView.center = self.view.center;
    self.wtyView.backgroundColor = [UIColor clearColor];
    self.wtyView.currentTime = currentTime;
    self.wtyView.durationTime = durantionTime;
    self.wtyView.radius = RADIUS;
    [self.view addSubview:self.wtyView];
}

@end
