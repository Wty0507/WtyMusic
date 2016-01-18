//
//  WtyMusicAnimationView.h
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/14.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WtyMusicAnimationView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSObject *targat;
@property (nonatomic, assign) SEL action;

- (void)startGif;
- (void)stopGif;

@end
