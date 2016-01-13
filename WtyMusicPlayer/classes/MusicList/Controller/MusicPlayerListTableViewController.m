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

@interface MusicPlayerListTableViewController ()
// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MusicPlayerListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    title.text = @"播放列表";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
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
    [self.navigationController pushViewController:play animated:YES];

}

@end
