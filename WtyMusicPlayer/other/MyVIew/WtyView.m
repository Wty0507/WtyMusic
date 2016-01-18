//
//  WtyView.m
//  Quarz2D
//
//  Created by cassiopeia on 16/1/11.
//  Copyright © 2016年 cassiopeia. All rights reserved.
//

#import "WtyView.h"

#define RADIUS 115
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    // 触摸点在view上的坐标
    CGFloat a1 = point.x;
    CGFloat b1 = point.y;
    
    // 把在view上的坐标，转换为以圆心为原点的坐标轴的坐标
    double a1X = a1 - self.frame.size.width / 2;
    double b1Y = self.frame.size.height / 2 - b1;
    
    
    // 直线方程式、
    // 圆方程式
    // 与圆的交点的方程式
    // ax^2 + bx + c = 0
    double a = (b1Y / a1X) * (b1Y / a1X) + 1;
    double b = 0;
    double c = -(RADIUS*RADIUS);
    
    // 求与圆的交点
    // b^2 - 4ac
    double delta = sqrt(b*b - 4*a*c);
    
    double x1 = (-b + delta) / (2*a);
    double y1 = ((self.frame.size.height / 2 - b1) * x1) / (a1 - self.frame.size.width / 2);
    
    double x2 = (-b - delta) / (2*a);
    double y2 = ((self.frame.size.height / 2 - b1) * x2) / (a1 - self.frame.size.width / 2);
    
    // 求点击点到圆心的距离
    double range = fabs(sqrt(a1X * a1X + b1Y * b1Y));
    
    // 求出两个点到点击位置的距离
    double range1 = fabs(sqrt((x1 - a1X)*(x1 - a1X) + (y1 - b1Y)*(y1 - b1Y)));
    double range2 = fabs(sqrt((x2 - a1X)*(x2 - a1X) + (y2 - b1Y)*(y2 - b1Y)));
    
    
   
    if (fabs(range - RADIUS) <= 5)
    {
        double A,B;
        if (range2 > range1) {
            A = x1;
            B = y1;
        } else
        {
            A = x2;
            B = y2;
        }
        
        A = A + self.frame.size.width / 2;
        B = self.frame.size.height / 2 - B;
        
        
        // 点A在圆上的余弦值
        double cosA = (A - self.frame.size.width / 2) / RADIUS;
        // 点A在圆上的弧度
        double radianA = acos(cosA);
        // 点A在圆上的角度
        double angleA = radianA * (180 / M_PI);
        
        NSLog(@"%f",angleA);
        
        
        // 此时的angle相当于currentTime durantion是445 - 95
        // 在第二象限
        if (a1 <= self.frame.size.width / 2 && b1 <= self.frame.size.height / 2) {
            if (angleA >= 95) {
                angleA = angleA - 95;
            }
        }
        // 在第一象限
        else if (b1 <= self.frame.size.height / 2 && a1 >= self.frame.size.width / 2) {
            if (angleA <= 85) {
                angleA = 180 + 85 + angleA;
            }
        } else {
            angleA = 85 + (180 - angleA);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"点击进度条" object:@{
                                                                                    @"currentAngle" : @(angleA)
                                                                                    }];
    }
    
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
    CGContextSetLineWidth(ctr, 4);
    
    // 画边框圆
    CGContextAddArc(ctr, self.frame.size.width / 2, self.frame.size.height / 2, self.radius, AngleToRadian(STARTANGLE), AngleToRadian(ENDANGLE), 1);
    CGContextDrawPath(ctr, kCGPathStroke);
    
    // 重新设置边框颜色
    CGContextSetRGBStrokeColor(ctr, 251/255.0, 225/255.0, 71/255.0, 1);
    // 线的宽度
    CGContextSetLineWidth(ctr, 6);
    
    
    CGFloat endAngle = -STARTANGLE + (self.currentTime * MARGINANGLE / self.durationTime);
    
    
    CGContextAddArc(ctr, self.frame.size.width / 2, self.frame.size.height / 2, self.radius, AngleToRadian(STARTANGLE), AngleToRadian(-endAngle), 1);
    CGContextDrawPath(ctr, kCGPathStroke);

    // 取得进度条结尾在圆上的位置，画实心圆
    float radian = AngleToRadian(-endAngle);
    float x = self.frame.size.width / 2 + cos(radian)*self.radius;
    float y = self.frame.size.height / 2 + sin(radian)*self.radius;
    
    NSLog(@"%f,%f",x,y);
    
    // 画填充圆
    CGContextAddArc(ctr, x, y, 7, 0, 2*M_PI, 0);
    CGContextDrawPath(ctr, kCGPathEOFill);
}


@end
