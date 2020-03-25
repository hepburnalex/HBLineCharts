//
//  LineChartScrollView.h
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartDrawView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LineChartScrollView : UIScrollView

@property (nonatomic, assign) NSInteger currentIndex;           //选中坐标点索引
@property (nonatomic, strong) LineChartDrawView *drawView;

/// 绘制折线
/// @param targetValues 目标点
/// @param lineType 折线类型
/// @param xspace 横轴间距
- (void)drawLines:(NSArray *)targetValues lineType:(LineType)lineType xspace:(CGFloat)xspace;

@end

NS_ASSUME_NONNULL_END
