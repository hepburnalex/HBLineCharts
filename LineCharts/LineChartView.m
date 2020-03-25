//
//  LineChartView.m
//  TestChart
//
//  Created by Hepburn on 2020/3/9.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import "LineChartView.h"
#import "LineChartXAxisView.h"
#import "LineChartYAxisView.h"
#import <HBBasicLib/HBBasicLib.h>

@interface LineChartView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *targetValues;
@property (nonatomic, strong) NSArray *xValues;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) LineChartScrollView *drawView;
@property (nonatomic, strong) LineChartXAxisView *xAxisView;
@property (nonatomic, strong) LineChartYAxisView *yAxisView;
@property (nonatomic, strong) UIView *backView;

@end

@implementation LineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.xSpace = 40;
        self.xMargin = 25;
        self.yMargin = 5;
        self.yLabelCount = 6;
        
        self.axisColor = [UIColor whiteColor];
        self.axisFont = UISystemFont(10);
        
        self.drawView = [[LineChartScrollView alloc] initWithFrame:CGRectMake(30, 10, frame.size.width-40, frame.size.height-30)];
        self.drawView.delegate = self;
        WS(weakSelf);
        self.drawView.drawView.OnLineChartSelect = ^(NSInteger index, CGPoint point, LineChartMarkAlign markAlign) {
            [weakSelf OnLineChartClick:index point:point align:markAlign];
        };
        [self addSubview:self.drawView];
        
        self.contentInsets = UIEdgeInsetsMake(10, 30, 40, 10);
        
        self.backView = [[UIView alloc] initWithFrame:self.bounds];
        self.backView.userInteractionEnabled = NO;
        self.backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.backView];
        
        self.markView = [[LineChartMarkBaseView alloc] initWithFrame:CGRectMake(0, 0, CGFloatAutoFit(74), CGFloatAutoFit(40))];
        self.markView.hidden = YES;
        [self.drawView addSubview:self.markView];
        
        [self drawXYLine];
    }
    return self;
}

- (void)registerMarkView:(NSString *)markname size:(CGSize)size {
    if (self.markView) {
        [self.markView removeFromSuperview];
        self.markView = nil;
    }
    self.markView = [[NSClassFromString(markname) alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.markView.hidden = YES;
    [self.drawView addSubview:self.markView];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.drawView.drawView.fillColor = fillColor;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.drawView.drawView.lineColor = lineColor;
}

- (void)setSelectLineColor:(UIColor *)selectLineColor {
    _selectLineColor = selectLineColor;
    self.drawView.drawView.selectLineColor = selectLineColor;
}

/// 折线图点击事件
/// @param index 距离点击最近的一个点的索引
/// @param point 距离点击最近的点的坐标
/// @param markAlign 弹出标签的方向
- (void)OnLineChartClick:(NSInteger)index point:(CGPoint)point align:(LineChartMarkAlign)markAlign {
    NSLog(@"%s %d %d", __func__, (int)index, markAlign);
    if (self.targetValues.count == 0) {
        return;
    }
    CGFloat doubleValue = [self.targetValues[index] floatValue];
    [self.markView refreshMark:markAlign xValue:self.xValues[index] yValue:doubleValue point:point];
    self.markView.hidden = NO;
    [self.drawView bringSubviewToFront:self.markView];
    if (self.OnLineChartSelect) {
        self.OnLineChartSelect(index);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger lastIndex = -1;
    self.xAxisView.contentOffset = scrollView.contentOffset;
    NSInteger index = round(scrollView.contentOffset.x/self.xSpace);
    if (index < 0) {
        index = 0;
    }
    if (index >= self.targetValues.count) {
        index = self.targetValues.count-1;
    }
    if (lastIndex == index) {
        return;
    }
    lastIndex = index;
    if (self.OnLineChartScroll) {
        self.OnLineChartScroll(index);
    }
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    if (!_drawView) {
        return;
    }
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.drawView.frame = CGRectMake(contentInsets.left, contentInsets.top, width-contentInsets.left-contentInsets.right, height-contentInsets.top-contentInsets.bottom);
}

/**
 *  画坐标轴
 */
- (void)drawXYLine {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat totalHeight = self.height;
    CGFloat totalWidth = self.width;
    
    CGPoint zeroPoint = CGPointMake(self.contentInsets.left, totalHeight-self.contentInsets.bottom);
    //1.Y轴、X轴的直线
    [path moveToPoint:zeroPoint];
    [path addLineToPoint:CGPointMake(zeroPoint.x, self.contentInsets.top)];
    
    [path moveToPoint:zeroPoint];
    [path addLineToPoint:CGPointMake(totalWidth-self.contentInsets.right, zeroPoint.y)];

    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = self.axisColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    [self.backView.layer addSublayer:shapeLayer];
    
    //4.添加索引格文字
    //X轴
    self.xAxisView = [[LineChartXAxisView alloc] initWithFrame:CGRectMake(self.contentInsets.left, totalHeight-self.contentInsets.bottom, totalWidth-self.contentInsets.left-self.contentInsets.right, self.contentInsets.bottom)];
    self.xAxisView.axisColor = self.axisColor;
    self.xAxisView.axisFont = self.axisFont;
    [self.backView addSubview:self.xAxisView];
    
    self.yAxisView = [[LineChartYAxisView alloc] initWithFrame:CGRectMake(0, self.contentInsets.top, self.contentInsets.left, totalHeight-self.contentInsets.top-self.contentInsets.bottom)];
    self.yAxisView.axisColor = self.axisColor;
    self.yAxisView.axisFont = self.axisFont;
    [self.backView addSubview:self.yAxisView];
}

/**
 *  画折线图
 */
-(void)drawLineChartView:(NSArray *)names xValues:(NSArray *)xValues targetValues:(NSArray *)targetValues lineType:(LineType)lineType {
    self.names = names;
    self.xValues = xValues;
    self.targetValues = targetValues;
    //1.画坐标轴
    CGFloat maxValue = 0;
    for (NSNumber *number in targetValues) {
        maxValue = MAX(maxValue, number.floatValue);
    }
    [self.yAxisView drawChartAxis:maxValue margin:self.yMargin count:self.yLabelCount];
    [self.xAxisView drawChartAxis:names margin:self.xMargin xspace:self.xSpace];
    [self.drawView drawLines:targetValues lineType:lineType xspace:self.xSpace];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.drawView.currentIndex = currentIndex-1;
}

- (void)addLineLayer:(NSInteger)index color:(UIColor *)color {
    [self.drawView.drawView addLineLayer:index color:color];
}

- (void)addLineLayer:(NSInteger)index color:(UIColor *)color offset:(CGFloat)offset {
    [self.drawView.drawView addLineLayer:index color:color offset:offset];
}

- (void)cleanLineLayers {
    [self.drawView.drawView cleanLineLayers];
}

@end
