//
//  MainNavigationController.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/8.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "MainNavigationController.h"

// controller
#import "PlayerController.h"

// view
#import "WtyNavigationBar.h"

// tool
#import "UIColor+AddColor.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self deleteNavigationBarLine];
}

+ (void)initialize
{
    UINavigationBar *apprence = [UINavigationBar appearance];
    apprence.barTintColor = [UIColor colorFromHexCode:@"#f6ef37"];
    
}

#pragma mark - push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [super pushViewController:viewController animated:animated];
    
    if ([viewController isKindOfClass:[PlayerController class]]) {
       
        // 替换NavigationBar
        WtyNavigationBar *wtynaviBar = [[WtyNavigationBar alloc] init];
        [self setValue:wtynaviBar forKeyPath:@"navigationBar"];
    }
}

#pragma mark - pop方法
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    
    [super popViewControllerAnimated:animated];
    
    if (self.childViewControllers.count <= 1) {
        
        [self setValue:nil forKeyPath:@"navigationBar"];
        [self deleteNavigationBarLine];
    }
    
    return self;
}

#pragma mark - 删除navigationbar底部的线
- (void)deleteNavigationBarLine
{
    if ([self.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list=self.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

@end
