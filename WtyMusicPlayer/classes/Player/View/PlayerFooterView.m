//
//  PlayerFooterView.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/12.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "PlayerFooterView.h"

@interface PlayerFooterView()


@end

@implementation PlayerFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self = [[[NSBundle mainBundle] loadNibNamed:@"PlayerFooterView" owner:nil options:nil] lastObject];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (IBAction)randomPlayButtonClick:(UIButton *)sender {
    
    self.randomPlayButtonBlock();
}

- (IBAction)lastButtonClick:(UIButton *)sender {
    
    self.lastButtonBlock();
}

- (IBAction)pauseButtonClick:(UIButton *)sender {
    
    self.pauseButtonBlock();
}

- (IBAction)nextButtonClick:(UIButton *)sender {
    
    self.nextButtonBlock();
}

- (IBAction)orderPlayButtonClick:(UIButton *)sender {
    
    self.orderPlayButtonBlock();
}


@end
