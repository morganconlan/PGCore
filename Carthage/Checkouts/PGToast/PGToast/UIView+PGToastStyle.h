//
//  UIView+PGToastStyle.h
//
//  Created by Andrew Podkovyrin on 18/04/14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Default text-toast styles
 */
@interface UIView (PGToastStyle)

+ (CGFloat)toastMaxHeightPercent;
+ (CGFloat)toastHorizontalPadding;
+ (CGFloat)toastVerticalPadding;
+ (CGFloat)toastMinHeight;
+ (CGFloat)toastCornerRadius;
+ (CGFloat)toastOpacity;
+ (UIFont *)toastFont;
+ (NSInteger)toastMaxNumberOfLines;
+ (NSTimeInterval)toastDuration;
+ (BOOL)toastTapToComplete;

@end
