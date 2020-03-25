//
//  LineChartScrollView.m
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import "LineChartScrollView.h"
#import <HBBasicLib/HBBasicLib.h>

@implementation LineChartScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.drawView = [[LineChartDrawView alloc] initWithFrame:self.bounds];
        [self addSubview:self.drawView];
    }
    return self;
}

/// 绘制折线
/// @param targetValues 目标点
/// @param lineType 折线类型
/// @param xspace 横轴间距
- (void)drawLines:(NSArray *)targetValues lineType:(LineType)lineType xspace:(CGFloat)xspace {
    CGFloat contentWidth = MAX((targetValues.count-1)*xspace, self.frame.size.width);
    self.drawView.frame = CGRectMake(0, 0, contentWidth, self.frame.size.height);
    self.contentSize = self.drawView.frame.size;
    [self.drawView drawLines:targetValues lineType:lineType xspace:xspace];
}

/// 设置当前选中坐标点
/// @param currentIndex 坐标点索引
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.drawView.currentIndex = currentIndex;
    CGFloat offset = currentIndex*self.drawView.xSpace;
    CGFloat offsetX = 0;
    if (offset < self.width*2/3) {
        offsetX = 0;
    }
    else if (offset > self.drawView.width-self.width*2/3) {
        offsetX = self.drawView.width-self.width/2;
    }
    else {
        offsetX = offset-self.width/2;
    }
    self.contentOffset = CGPointMake(offsetX, 0);
}

@end
