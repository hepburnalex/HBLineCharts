//
//  LineChartMarkBaseView.h
//  UVLOOK
//
//  Created by Hepburn on 2020/3/24.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LineChartMarkBaseView : UIImageView

- (void)refreshMark:(LineChartMarkAlign)markAlign xValue:(NSString *)xValue yValue:(CGFloat)yValue point:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
