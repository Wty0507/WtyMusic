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



@interface PlayerController ()
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, weak) PlayerFooterView *playerFooter;
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
    
    if (![_musicModel.mp3Url isEqualToString:self.mp3Url]) {
        
        [self.playerFooter removeFromSuperview];
        [self createPlayer];
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
    [self.player play];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.mp3Url = self.musicModel.mp3Url;
}


- (void)createUI
{
//    // 背景
//    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    self.backgroundImage.image = [UIImage imageNamed:@"yunho.jpg"];
//    [self.view addSubview:self.backgroundImage];
    
    [self createFooterView];
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
        [self.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
    } else
    {
        [self.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
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
            [play.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
        } else {
            [play.player play];
            [play.playerFooter.pauseButton setBackgroundImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
