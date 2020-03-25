//
//  LineChartHeader.h
//  UVLOOK
//
//  Created by Hepburn on 2020/3/10.
//  Copyright © 2020 Hepburn. All rights reserved.
//

#ifndef LineChartHeader_h
#define LineChartHeader_h

// 线条类型
typedef NS_ENUM(NSInteger, LineType) {
    LineType_Straight, // 折线
    LineType_Curve     // 曲线
};

typedef enum {
    LineChartMarkAlign_TopLeft,
    LineChartMarkAlign_TopRight,
    LineChartMarkAlign_BottomLeft,
    LineChartMarkAlign_BottomRight
} LineChartMarkAlign;


#endif /* LineChartHeader_h */
