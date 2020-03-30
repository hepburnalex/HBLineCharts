//
//  LineChartDrawView.h
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LineChartDrawView : UIView

@property (nonatomic, strong) UIColor *lineColor;           //折线颜色
@property (nonatomic, strong) UIColor *selectLineColor;     //选中竖线颜色
@property (nonatomic, strong) UIColor *fillColor;           //折线填充颜色
@property (nonatomic, assign) CGFloat xSpace;               //横轴坐标间距
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) void(^OnLineChartSelect)(NSInteger index, CGPoint point, LineChartMarkAlign markAlign);


/// 绘制折线图
/// @param targetValues 纵轴目标点
/// @param lineType 折线类型
/// @param xspace 横轴间距
- (void)drawLines:(NSArray *)targetValues lineType:(LineType)lineType xspace:(CGFloat)xspace;

/// 绘制竖线
- (void)addLineLayer:(NSInteger)index color:(UIColor *)color;

/// 绘制竖线
- (void)addLineLayer:(NSInteger)index color:(UIColor *)color offset:(CGFloat)offset;

- (void)fillLines:(NSInteger)startIndex startOffset:(CGFloat)startOffset endIndex:(NSInteger)endIndex startOffset:(CGFloat)endOffset fillColor:(UIColor *)fillColor;

- (void)cleanLineLayers;

@end

NS_ASSUME_NONNULL_END
