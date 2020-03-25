//
//  LineChartXAxisView.h
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineChartXAxisView : UIScrollView

@property (nonatomic, strong) UIFont *axisFont;             //坐标轴字体
@property (nonatomic, strong) UIColor *axisColor;           //坐标轴颜色

/// 画横轴标尺
/// @param names 标尺名
/// @param margin 标尺与折线图间距
/// @param xSpace 横轴目标点间距
- (void)drawChartAxis:(NSArray *)names margin:(CGFloat)margin xspace:(CGFloat)xSpace;

@end

NS_ASSUME_NONNULL_END
