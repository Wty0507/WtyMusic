//
//  MusicListCell.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/8.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "MusicListCell.h"

@interface MusicListCell()
@property (weak, nonatomic) IBOutlet UIImageView *MusicIcon;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *Singer;

@end

@implementation MusicListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"MusicList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MusicList" owner:nil options:nil].lastObject;
    }
    return cell;
}


- (void)awakeFromNib {
    self.MusicIcon.layer.cornerRadius = self.MusicIcon.frame.size.width / 2;
}

- (void)setModel:(MusicModel *)model
{
    _model = model;
    
    [self.MusicIcon sd_setImageWithURL:[NSURL URLWithString:_model.picUrl]];
    
    
    self.musicName.text = _model.name;
    self.Singer.text = [NSString stringWithFormat:@"%@ - %@",_model.singer,_model.album];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected == YES) {
        self.contentView.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}


@end
