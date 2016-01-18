//
//  MusicPlayerListTableViewController.m
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/8.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "MusicPlayerListTableViewController.h"
// view
#import "MusicListCell.h"
// model
#import "MusicModel.h"
// controller
#import "PlayerController.h"

#import <AVFoundation/AVFoundation.h>

@interface MusicPlayerListTableViewController ()
// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger row;
@end

@implementation MusicPlayerListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    title.text = @"播放列表";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    // 监听播放完毕通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPlayerViewController) name:@"推出播放页面" object:nil];
    
}

#pragma mark - 通知事件
#pragma mark 推出播放页面
- (void)pushPlayerViewController
{
    PlayerController *player = [PlayerController sharedManager];
    [self.navigationController pushViewController:player animated:YES];
}


#pragma mark 一首歌播放结束后
- (void)playEnd
{
    BOOL sequential = [[NSUserDefaults standardUserDefaults] boolForKey:@"sequentialPlay"];
    
    NSInteger count = self.dataArray.count;
#pragma mark 随机播放
    if (sequential == NO) {
        if (count > 1) {
            NSInteger number = arc4random() % count;
            while (number != self.row) {
                self.row = number;
                PlayerController *play = [PlayerController sharedManager];
                play.musicModel = self.dataArray[self.row];
              
            }
        }
    }
    
#pragma mark 顺序播放
    else
    {
        // 是最后一首 播放第一首
        if (self.row == count - 1) {
            self.row = 0;
        } else {
            self.row += 1;
        }
        
        PlayerController *play = [PlayerController sharedManager];
        play.musicModel = self.dataArray[self.row];
    }
    
}

#pragma mark - 数据原数组懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        
        NSArray *array = [NSArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MusicInfoList.plist" ofType:nil];
        array = [NSMutableArray arrayWithContentsOfFile:path];
        
        _dataArray = [NSMutableArray array];
        
        for (NSDictionary *musicDict in array) {
            MusicModel *model = [MusicModel modelWithDict:musicDict];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicListCell *cell = [MusicListCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerController *play = [PlayerController sharedManager];
    play.musicModel = self.dataArray[indexPath.row];
    self.row = indexPath.row;
    [self.navigationController pushViewController:play animated:YES];
}

@end
