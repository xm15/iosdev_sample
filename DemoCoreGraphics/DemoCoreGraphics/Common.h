//
//  Common.h
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  填充线性渐变颜色
 *
 *  @since 1.0
 */
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);


/**
 *  修正画一个像素的rect
 *
 *  @since 1.0
 */
CGRect rectFor1PxStroke(CGRect rect);

/**
 *  画一条线，从起点到终点
 *
 *  @since 1.0
 */
void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);


void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor,BOOL isFat);
static inline double radians (double degrees) { return degrees * M_PI/180; }
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);