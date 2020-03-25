//
//  LineChartDrawView.m
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import "LineChartDrawView.h"
#import <HBBasicLib/HBBasicLib.h>
#import <Masonry.h>

@interface LineChartDrawView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *lineBackView;
@property (nonatomic, strong) NSArray *targetValues;
@property (nonatomic, readonly) CGFloat maxYValue;
@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation LineChartDrawView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor = [UIColor whiteColor];
        self.selectLineColor = [UIColor whiteColor];
        self.fillColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] init];
        tgr.delegate = self;
        [self addGestureRecognizer:tgr];
        
        self.lineBackView = [[UIView alloc] init];
        self.lineBackView.userInteractionEnabled = NO;
        [self addSubview:self.lineBackView];
        [self.lineBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            MAS_FOURFIT(self);
        }];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    NSLog(@"%s %@", __func__, NSStringFromCGPoint(point));
    self.currentIndex = round(point.x/self.xSpace);
    return YES;
}

/// 目标点最大值
- (CGFloat)maxYValue {
    CGFloat maxValue = 0;
    for (NSNumber *number in self.targetValues) {
        maxValue = MAX(maxValue, number.floatValue);
    }
    return maxValue;
}

/// 选中目标点
/// @param currentIndex 索引
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
    CGFloat maxValue = self.maxYValue;
    CGFloat doubleValue = [self.targetValues[currentIndex] floatValue];
    CGFloat scale = (maxValue > 0)?doubleValue/maxValue:0;
    CGPoint centerPoint = CGPointMake(currentIndex*self.xSpace, self.height*(1.0-scale));
    
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
    }
    self.lineLayer = [self addLineLayer:centerPoint :self.selectLineColor];
    
    BOOL isBottom = (scale > 0.7);
    BOOL isRight = (currentIndex < self.targetValues.count-2);
    LineChartMarkAlign markAlign = LineChartMarkAlign_TopLeft;
    if (!isBottom && !isRight) {
        markAlign = LineChartMarkAlign_TopLeft;
    }
    else if (isBottom && !isRight) {
        markAlign = LineChartMarkAlign_BottomLeft;
    }
    else if (!isBottom && isRight) {
        markAlign = LineChartMarkAlign_TopRight;
    }
    else if (isBottom && isRight) {
        markAlign = LineChartMarkAlign_BottomRight;
    }
    if (self.OnLineChartSelect) {
        self.OnLineChartSelect(currentIndex, centerPoint, markAlign);
    }
}

- (void)addLineLayer:(NSInteger)index color:(UIColor *)color {
    CGFloat maxValue = self.maxYValue;
    CGFloat doubleValue = [self.targetValues[index] floatValue];
    CGFloat scale = (maxValue > 0)?doubleValue/maxValue:0;
    CGPoint centerPoint = CGPointMake(index*self.xSpace, self.height*(1.0-scale));
    [self addLineLayer:centerPoint :color];
}

- (void)addLineLayer:(NSInteger)index color:(UIColor *)color offset:(CGFloat)offset {
    if (self.xSpace == 0) {
        return;
    }
    CGFloat maxValue = self.maxYValue;
    CGFloat startValue = [self.targetValues[index-1] floatValue];
    CGFloat endValue = [self.targetValues[index] floatValue];
    if (offset > 0) {
        startValue = [self.targetValues[index] floatValue];
        endValue = [self.targetValues[index+1] floatValue];
    }
    CGFloat yoffset = (endValue-startValue)*offset/self.xSpace;
    CGFloat doubleValue = startValue+yoffset;
    CGFloat scale = (maxValue > 0)?doubleValue/maxValue:0;
    NSLog(@"%s %f %f %f %f %f", __func__, startValue, doubleValue, endValue, offset, self.xSpace);
    CGPoint centerPoint = CGPointMake(index*self.xSpace+offset, self.height*(1.0-scale));
    [self addLineLayer:centerPoint :color];
}

- (CAShapeLayer *)addLineLayer:(CGPoint)centerPoint :(UIColor *)color {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:centerPoint];
    [path addLineToPoint:CGPointMake(centerPoint.x, self.height)];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.borderWidth = 0.5;
    [self.lineBackView.layer addSublayer:lineLayer];
    return lineLayer;
}

- (void)cleanLineLayers {
    NSArray *array = [NSArray arrayWithArray:self.lineBackView.layer.sublayers];
    for (CAShapeLayer *layer in array) {
        [layer removeFromSuperlayer];
    }
}

/// 绘制折线
/// @param targetValues 目标点
/// @param lineType 折线类型
/// @param xspace 横轴间距
- (void)drawLines:(NSArray *)targetValues lineType:(LineType)lineType xspace:(CGFloat)xspace {
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        MAS_FOURFIT(self);
    }];
    self.targetValues = targetValues;
    self.xSpace = xspace;
    CGFloat totalHeight = self.height;
    
    CGFloat maxValue = self.maxYValue;
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i=0; i<targetValues.count; i++) {
        CGFloat scale = 0;
        if (maxValue > 0) {
            CGFloat doubleValue = [targetValues[i] floatValue];
            scale = doubleValue/maxValue;
        }
        CGPoint point = CGPointMake(xspace*i, totalHeight-totalHeight*scale);
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2, 2) cornerRadius:2];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = self.lineColor.CGColor;
        layer.fillColor = self.lineColor.CGColor;
        layer.path = path.CGPath;
        [self.contentView.layer addSublayer:layer];
    }
    //3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = [allPoints[0] CGPointValue];
    
    [path moveToPoint:CGPointMake(startPoint.x, totalHeight)];
    [path addLineToPoint:startPoint];
    CGPoint prePoint = CGPointZero;
    CGPoint endPoint = startPoint;
    switch (lineType) {
        case LineType_Straight: //直线
            for (int i = 1; i<allPoints.count; i++) {
                endPoint = [allPoints[i] CGPointValue];
                [path addLineToPoint:endPoint];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    prePoint = [allPoints[0] CGPointValue];
                }
                else {
                    CGPoint point = [allPoints[i] CGPointValue];
                    CGPoint nextPoint = CGPointMake(point.x+self.xSpace, point.y);
                    if (i == allPoints.count-1) {
                        endPoint = point;
                    }
                    else {
                        nextPoint = [allPoints[i+1] CGPointValue];
                    }
                    CGPoint point1 = CGPointMake((prePoint.x+point.x)/2, prePoint.y);
                    CGPoint point2 = CGPointMake((prePoint.x+point.x)/2, point.y);
                    [path addCurveToPoint:point controlPoint1:point1 controlPoint2:point2]; //三次曲线
                    prePoint = point;
                }
            }
            break;
    }
    [path addLineToPoint:CGPointMake(endPoint.x, totalHeight)];
    [path addLineToPoint:CGPointMake(startPoint.x, totalHeight)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = self.lineColor.CGColor;
    shapeLayer.fillColor = self.fillColor.CGColor;
    shapeLayer.borderWidth = 0.5;
    [self.contentView.layer addSublayer:shapeLayer];
}

@end
