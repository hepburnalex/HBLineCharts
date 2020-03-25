//
//  LineChartYAxisView.m
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import "LineChartYAxisView.h"
#import <HBBasicLib/HBBasicLib.h>

@implementation LineChartYAxisView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.axisColor = [UIColor whiteColor];
        self.axisFont = UISystemFont(10);
        self.userInteractionEnabled = NO;
    }
    return self;
}

/// 画纵轴标尺
/// @param maxValue 纵轴最大值
/// @param margin 纵轴标尺与折线图的间距
/// @param labelCount 纵轴数量
- (void)drawChartAxis:(CGFloat)maxValue margin:(CGFloat)margin count:(NSInteger)labelCount {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    if (labelCount > 0) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat yOffset = self.frame.size.height/labelCount;
        CGFloat yValue = maxValue/labelCount;
        for (int i=0; i<=labelCount; i++) {
            CGFloat Y = self.frame.size.height-yOffset*i;
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-6, self.frame.size.width-margin, 12)];
            textLabel.text = [NSString stringWithFormat:@"%.1f", yValue*i];
            textLabel.font = self.axisFont;
            textLabel.textColor = self.axisColor;
            textLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:textLabel];
            
            CGPoint point = CGPointMake(self.frame.size.width, Y);
            [path moveToPoint:point];
            [path addLineToPoint:CGPointMake(point.x+3, point.y)];
        }
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = self.axisColor.CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.borderWidth = 1.0;
        [self.layer addSublayer:shapeLayer];
    }
}

@end
