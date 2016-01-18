//
//  PlayerFooterView.h
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/12.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^randomPlayButtonBlock) (void);
typedef void (^lastButtonBlock) (void);
typedef void (^pauseButtonBlock) (void);
typedef void (^nextButtonBlock) (void);
typedef void (^orderPlayButtonBlock) (void);


@interface PlayerFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *randomPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *LastButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *orderPlayButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, strong) randomPlayButtonBlock randomPlayButtonBlock;

@property (nonatomic, strong) lastButtonBlock lastButtonBlock;

@property (nonatomic, strong) pauseButtonBlock pauseButtonBlock;

@property (nonatomic, strong) nextButtonBlock nextButtonBlock;

@property (nonatomic, strong) orderPlayButtonBlock orderPlayButtonBlock;


@end
