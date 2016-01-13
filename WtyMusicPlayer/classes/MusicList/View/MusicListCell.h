//
//  MusicListCell.h
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/8.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import <UIKit/UIKit.h>
// model
#import "MusicModel.h"

@interface MusicListCell : UITableViewCell

@property (nonatomic, strong) MusicModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
