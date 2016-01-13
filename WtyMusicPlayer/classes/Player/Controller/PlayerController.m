//
//  PlayerController.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/12.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "PlayerController.h"

#import "PlayerFooterView.h"

#import <AVFoundation/AVFoundation.h>

#import "WtyView.h"

#import "UIColor+AddColor.h"


@interface PlayerController ()
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, strong) PlayerFooterView *playerFooter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) WtyView *wtyView;
@property (nonatomic, strong) UIImageView *icon;
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
    [self setupTitleWithString:self.musicModel.name textColor:[UIColor whiteColor] font:17];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItemWithImageName:@"iconfont-newlisticon06" andFrame:CGRectMake(0, 0, 22, 22) action:@selector(backButtonClick) isLeft:YES];
    
    [self createPlayer];
    
    [self createUI];
    
    
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setMusicModel:(MusicModel *)musicModel
{
    _musicModel = musicModel;
    
    if (self.mp3Url != nil && ![_musicModel.mp3Url isEqualToString:self.mp3Url]) {
        
        [self.playerFooter removeFromSuperview];
        [self createPlayer];
        [self createSingImage];
        [self createFooterView];
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.mp3Url = self.musicModel.mp3Url;
    
//    // 播放完毕通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}


- (void)createUI
{
    
    self.view.backgroundColor = [UIColor orangeColor];
//     背景
//    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    self.backgroundImage.image = [UIImage imageNamed:@"background.jpg"];
//    [self.view addSubview:self.backgroundImage];
    
    [self createSingImage];
    
    [self createFooterView];
}

- (void)createSingImage
{
    if (self.icon == nil) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        self.icon.center = self.view.center;
        self.icon.layer.cornerRadius = 75;
        self.icon.layer.borderWidth = 3;
        self.icon.layer.borderColor = [[UIColor colorFromHexCode:@"#ffffff"] CGColor];
        self.icon.clipsToBounds = YES;
        [self.view addSubview:self.icon];
    }
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.musicModel.picUrl] placeholderImage:nil];
}

#pragma mark - 尾部控件
- (void)createFooterView
{
    CGFloat footerX = 0;
    CGFloat footerH = 120;
    CGFloat footerW = WIDTH;
    CGFloat footerY = HEIGHT - footerH;
    self.playerFooter = [[[NSBundle mainBundle] loadNibNamed:@"PlayerFooterView" owner:nil options:nil] lastObject];
    self.playerFooter.backgroundColor = [UIColor clearColor];
    self.playerFooter.frame = CGRectMake(footerX, footerY, footerW, footerH);
    
    BOOL isplaying = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"];
    if (isplaying == YES) {
        [self.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
    } else
    {
        [self.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.playerFooter];
    
    // 点击随机播放
    [self.playerFooter setRandomPlayButtonBlock:^(){
    
    }];
    
    // 点击上一首
    [self.playerFooter setLastButtonBlock:^(){
    
    }];
    
    __weak PlayerController *play = self;
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
    
    [self.wtyView removeFromSuperview];
    
    if (duration != 0) {
        self.wtyView = [[WtyView alloc] initWithFrame:CGRectMake(100, 200, 215, 215)];
        self.wtyView.center = self.view.center;
        self.wtyView.backgroundColor = [UIColor clearColor];
        self.wtyView.currentTime = current;
        self.wtyView.durationTime = duration;
        [self.view addSubview:self.wtyView];
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

@end
