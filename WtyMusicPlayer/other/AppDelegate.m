//
//  AppDelegate.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/8.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "AppDelegate.h"
#import "WtyMusicAnimationView.h"
#import "PlayerController.h"

@interface AppDelegate ()
@property (nonatomic, weak) WtyMusicAnimationView *musicAnimationView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // 第一次启动
    [self isFirstLauch];
    
    
    [self addMusicAnimation];
    
    return YES;
}

- (void)isFirstLauch
{
    // 获取当前应用版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    NSLog(@"currentVersion:%@",currentVersion);
    
    // 获取存储的应用版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveVersion"];
    // 版本号相同
    if ([currentVersion isEqualToString:saveVersion]) { // 无操作
        
    } else { // 进入新特性介绍
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sequentialPlay"];
        
        // 存储新的版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"saveVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)addMusicAnimation
{
    WtyMusicAnimationView *musicAnimation = [[NSBundle mainBundle] loadNibNamed:@"WtyMusicAnimationView" owner:nil options:nil].firstObject;
    musicAnimation.hidden = YES;
    musicAnimation.targat = self;
    musicAnimation.action = @selector(pushToPlayerViewController);
    self.musicAnimationView = musicAnimation;
    [self.window addSubview:musicAnimation];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(stopMusicAnimation) name:@"停止音符跳动" object:nil];
    [center addObserver:self selector:@selector(startMusicAnimation) name:@"开始音符跳动" object:nil];
    [center addObserver:self selector:@selector(showMusicAnimation) name:@"显示音符" object:nil];
    [center addObserver:self selector:@selector(hiddenMusicAnimation) name:@"隐藏音符" object:nil];
    
    
}

#pragma mark - 显示跳动音符
- (void)showMusicAnimation
{
     BOOL isplay = [[NSUserDefaults standardUserDefaults]boolForKey:@"isPlaying"];
    if (isplay) {
        [self.musicAnimationView startGif];
    } else {
        [self.musicAnimationView stopGif];
    }
    self.musicAnimationView.hidden = NO;
    
    [self.window bringSubviewToFront:self.musicAnimationView];
}

#pragma mark - 开始跳动音符
- (void)startMusicAnimation
{
    [self.musicAnimationView startGif];
}

#pragma mark - 停止跳动音符
- (void)stopMusicAnimation
{
    [self.musicAnimationView stopGif];
}

#pragma mark - 隐藏音符
- (void)hiddenMusicAnimation
{
    self.musicAnimationView.hidden = YES;
}



- (void)pushToPlayerViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"推出播放页面" object:nil];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
}

@end
