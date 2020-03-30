//
//  LineChartView.h
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartHeader.h"
#import "LineChartScrollView.h"
#import "LineChartMarkBaseView.h"

@interface LineChartView : UIView

@property (nonatomic, assign) NSInteger currentIndex;       //当前选中目标点
@property (nonatomic, assign) NSInteger yLabelCount;        //纵轴标尺数量
@property (nonatomic, assign) CGFloat xSpace;               //横轴两点间距
@property (nonatomic, assign) CGFloat xMargin;              //横轴与标尺间隙
@property (nonatomic, assign) CGFloat yMargin;              //纵轴与标尺间隙
@property (nonatomic, assign) UIEdgeInsets contentInsets;   //折线图与四边距离
@property (nonatomic, strong) void(^OnLineChartSelect)(NSInteger index);
@property (nonatomic, strong) void(^OnLineChartScroll)(NSInteger index);
@property (nonatomic, strong) UIFont *axisFont;             //坐标轴字体
@property (nonatomic, strong) UIColor *axisColor;           //坐标轴颜色
@property (nonatomic, strong) UIColor *lineColor;           //折线颜色
@property (nonatomic, strong) UIColor *selectLineColor;     //选中竖线颜色
@property (nonatomic, strong) UIColor *fillColor;           //折线填充颜色
@property (nonatomic, strong) LineChartMarkBaseView *markView;

/**
 *  画折线图
 *  @param names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 *  @param lineType     直线类型
 */
-(void)drawLineChartView:(NSArray *)names xValues:(NSArray *)xValues targetValues:(NSArray *)targetValues lineType:(LineType)lineType;
- (void)addLineLayer:(NSInteger)index color:(UIColor *)color;
- (void)addLineLayer:(NSInteger)index color:(UIColor *)color offset:(CGFloat)offset;

- (void)cleanLineLayers;
- (void)registerMarkView:(NSString *)markname size:(CGSize)size;

- (void)fillLines:(NSInteger)startIndex startOffset:(CGFloat)startOffset endIndex:(NSInteger)endIndex startOffset:(CGFloat)endOffset fillColor:(UIColor *)fillColor;
@end
