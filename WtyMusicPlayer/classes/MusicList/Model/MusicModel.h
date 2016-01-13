//
//  MusicModel.h
//  WtyMusicPlayer
//
//  Created by cassiopeia on 16/1/8.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, assign) NSNumber *idd;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *blurPicUrl;
@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, assign) NSNumber *duration;
@property (nonatomic, copy) NSString *artists_name;
@property (nonatomic, copy) NSString *lyric;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
