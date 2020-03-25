//
//  LineChartYAxisView.h
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineChartYAxisView : UIView

@property (nonatomic, strong) UIFont *axisFont;             //坐标轴字体
@property (nonatomic, strong) UIColor *axisColor;           //坐标轴颜色

/// 画纵轴标尺
/// @param maxValue 纵轴最大值
/// @param margin 纵轴标尺与折线图的间距
/// @param labelCount 纵轴数量
- (void)drawChartAxis:(CGFloat)maxValue margin:(CGFloat)margin count:(NSInteger)labelCount;

@end

NS_ASSUME_NONNULL_END
