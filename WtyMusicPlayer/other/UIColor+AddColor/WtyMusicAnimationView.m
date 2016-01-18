//
//  WtyMusicAnimationView.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/14.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "WtyMusicAnimationView.h"

@implementation WtyMusicAnimationView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.targat performSelector:self.action withObject:nil];
}

- (void)startGif
{
    [self.imageView startAnimating];
}


- (void)stopGif
{
    [self.imageView stopAnimating];
    self.imageView.image = [UIImage imageNamed:@"gif48_1000"];
}


- (void)awakeFromNib
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 1; i <= 15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gif48_%ld", i]];
        [array addObject:image];
    }
    self.imageView.animationImages = array;
    self.imageView.animationDuration = 1;
    self.imageView.animationRepeatCount = 0;
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(WIDTH - 24 - 12, 30, 24, 24);
}

@end
