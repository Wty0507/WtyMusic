//
//  BaseViewController.h
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/12.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseViewController : UIViewController

// 设置titleView
- (void)setupTitleWithString:(NSString *)string textColor:(UIColor *)color font:(CGFloat)font;

// 设置items
- (void)setupNavigationItemWithImageName:(NSString *)imageName andFrame:(CGRect)frame action:(SEL)action isLeft:(BOOL)isLeft;


@end
