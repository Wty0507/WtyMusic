//
//  WtyView.m
//  Quarz2D
//
//  Created by cassiopeia on 16/1/11.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "WtyView.h"

#define STARTANGLE -95
#define ENDANGLE -445
#define MARGINANGLE (STARTANGLE - ENDANGLE)

// 角度转弧度
#define AngleToRadian(angle) (M_PI/180.0)*angle

@implementation WtyView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}


- (void)drawRect:(CGRect)rect {
   
    // 获得上下文
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    
    // 画线笔的颜色
    // 边框颜色
    CGContextSetRGBStrokeColor(ctr, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1);
    // 填充颜色
    CGContextSetRGBFillColor(ctr, 255/255.0, 255/255.0, 255/255.0, 1);
    // 线的宽度
    CGContextSetLineWidth(ctr, 3);
    
    // 画边框圆
    CGContextAddArc(ctr, self.frame.size.width / 2, self.frame.size.height / 2, 100, AngleToRadian(STARTANGLE), AngleToRadian(ENDANGLE), 1);
    CGContextDrawPath(ctr, kCGPathStroke);
    
    // 重新设置边框颜色
    CGContextSetRGBStrokeColor(ctr, 251/255.0, 225/255.0, 71/255.0, 1);
    // 线的宽度
    CGContextSetLineWidth(ctr, 5);
    
    
    CGFloat endAngle = -STARTANGLE + (self.currentTime * MARGINANGLE / self.durationTime);
    
    
    CGContextAddArc(ctr, self.frame.size.width / 2, self.frame.size.height / 2, 100, AngleToRadian(STARTANGLE), AngleToRadian(-endAngle), 1);
    CGContextDrawPath(ctr, kCGPathStroke);

    // 取得进度条结尾在圆上的位置，画实心圆
    float radian = AngleToRadian(-endAngle);
    float x = self.frame.size.width / 2 + cos(radian)*100;
    float y = self.frame.size.height / 2 + sin(radian)*100;
    
    NSLog(@"%f,%f",x,y);
    
    // 画填充圆
    CGContextAddArc(ctr, x, y, 7, 0, 2*M_PI, 0);
    CGContextDrawPath(ctr, kCGPathEOFill);
}


@end
