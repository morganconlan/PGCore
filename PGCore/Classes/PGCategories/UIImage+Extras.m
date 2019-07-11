//
//  UIImage+Extras.m
//  pgcore
//
//  Created by Morgan Conlan on 27/09/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGApp.h"
#import "UIImage+Extras.h"

@implementation UIImage (Extras)

+ (UIImage *)image:(UIImage *)img withUIColour:(UIColor *)colour {
    // begin a new image context, to draw our coloured image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill colour
    [colour setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to colour burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (colour burn) a coloured rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *colouredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the colour-burned image
    return colouredImg;
}

+ (UIImage *)image:(UIImage *)img
        withColour:(NSString *)colour {
    
    return [UIImage image:img withUIColour:[PGApp.app colour:colour]];
}

+ (UIImage *)image:(UIImage *)img
           withHex:(int)hex {
    
    return [UIImage image:img withUIColour:[PGApp.app hex:hex]];
}

@end
