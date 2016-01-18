//
//  WtyNavigationBar.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/14.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "WtyNavigationBar.h"

@implementation WtyNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                [view removeFromSuperview];
            }
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
