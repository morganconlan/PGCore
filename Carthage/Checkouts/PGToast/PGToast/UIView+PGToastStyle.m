//
//  UIView+PGToastStyle.m
//
//  Created by Andrew Podkovyrin on 18/04/14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import "UIView+PGToastStyle.h"

@implementation UIView (PGToastStyle)

+ (CGFloat)toastMaxHeightPercent {
    return 0.8f; // 80% of parent view height
}

+ (CGFloat)toastHorizontalPadding {
    return 6.f;
}

+ (CGFloat)toastVerticalPadding {
    return 6.f;
}

+ (CGFloat)toastMinHeight {
    return 40.f;
}

+ (CGFloat)toastCornerRadius {
    return 3.f;
}

+ (CGFloat)toastOpacity {
    return 0.8f;
}

+ (UIFont *)toastFont {
    return [UIFont systemFontOfSize:16.f];
}

+ (NSInteger)toastMaxNumberOfLines {
    return 2;
}

+ (NSTimeInterval)toastDuration {
    return 2.f;
}

+ (BOOL)toastTapToComplete {
    return YES;
}

@end
