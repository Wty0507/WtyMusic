//
//  BaseViewController.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/12.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupTitleWithString:(NSString *)string textColor:(UIColor *)color font:(CGFloat)font
{
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 44)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = color;
    title.text = string;
    
    self.navigationItem.titleView = title;
}

- (void)setupNavigationItemWithImageName:(NSString *)imageName andFrame:(CGRect)frame action:(SEL)action isLeft:(BOOL)isLeft
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

@end
