//
//  PGPlainCell.h
//  pgcore
//
//  Created by Morgan Conlan on 10/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCell.h"

@interface PGPlainCell : PGCell

@property (nonatomic, strong) UIColor *titleColour;
@property (nonatomic, strong) UIView *icon;
@property (nonatomic, assign) BOOL isTextCentered;

- (void)prepare;

+ (UIView *)cellIcon;

+ (BOOL)isShowingAccessory;

+ (CGFloat)insetLeft;
+ (CGFloat)insetRight;
+ (CGFloat)insetTop;
+ (UIFont *)font;

@end
