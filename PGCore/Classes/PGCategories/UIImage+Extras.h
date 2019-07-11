//
//  UIImage+Extras.h
//  pgcore
//
//  Created by Morgan Conlan on 27/09/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extras)

+ (UIImage *)image:(UIImage *)img withUIColour:(UIColor *)colour;
+ (UIImage *)image:(UIImage *)img withHex:(int)hex;
+ (UIImage *)image:(UIImage *)img withColour:(NSString *)colour;

@end
