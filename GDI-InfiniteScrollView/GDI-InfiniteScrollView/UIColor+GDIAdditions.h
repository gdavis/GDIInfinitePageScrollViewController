//
//  UIColor+GDIAdditions.h
//  GDIMagnifiedPicker
//
//  Created by Grant Davis on 2/3/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor(GDIAdditions)

+ (UIColor *)colorWithRGBHex:(uint)hex;
+ (UIColor *)colorWithRGBHex:(uint)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithARGBHex:(uint)hex;
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha rgbDivisor:(CGFloat)divisor;
+ (UIColor *)randomColor;
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

@end
