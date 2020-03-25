//
//  LineChartXAxisView.m
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import "LineChartXAxisView.h"
#import <HBBasicLib/HBBasicLib.h>

@implementation LineChartXAxisView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.axisColor = [UIColor whiteColor];
        self.axisFont = UISystemFont(10);
        self.userInteractionEnabled = NO;
    }
    return self;
}

/// 画横轴标尺
/// @param names 标尺名
/// @param margin 标尺与折线图间距
/// @param xspace 横轴目标点间距
- (void)drawChartAxis:(NSArray *)names margin:(CGFloat)margin xspace:(CGFloat)xspace {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat labelWidth = CGFloatAutoFit(60);
    self.contentSize = CGSizeMake(xspace*names.count, self.frame.size.height);
    for (int i=1; i<names.count-1; i++) {
        NSString *name = names[i];
        if ([name isKindOfClass:[NSString class]]) {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xspace*i-labelWidth/2, margin, labelWidth, 12)];
            textLabel.text = names[i];
            textLabel.font = self.axisFont;
            textLabel.textColor = self.axisColor;
            textLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:textLabel];
        }
        else if ([name isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)name;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.center = CGPointMake(xspace*i, 6+margin);
            [self addSubview:imageView];
        }
    }
}

@end
