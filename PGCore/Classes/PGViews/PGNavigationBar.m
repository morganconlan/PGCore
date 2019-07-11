//
//  PGNavigationBar.m
//  pgcore
//
//  Created by Morgan Conlan on 01/02/2016.
//  Copyright © 2016 Morgan Conlan. All rights reserved.
//

#import "PGNavigationBar.h"

@implementation PGNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {

    if ((self = [super initWithFrame:frame])) {

        [self customiseAppearance];

    }

    return self;

}

- (void)customiseAppearance {

    self.translucent = PGApp.app.configs.isNavTranslucent;

    if (self.isTranslucent) {

        [self setOpaque:NO];
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = [UIColor clearColor];

        // remove the default background image by replacing it with a clear image
        [self setBackgroundImage:[self.class maskedImage]
                   forBarMetrics:UIBarMetricsDefault];

        // remove defualt bottom shadow
        [self setShadowImage: [UIImage new]];


    } else {

        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
        self.barTintColor = (PGApp.app.configs.isDebugging)
        ? [UIColor redColor]
        : [PGApp.app colour:kPG_Colour_Nav_Tint];

    }

    [self setTitleTextAttributes:
     @{
       UITextAttributeTextColor:[PGApp.app colour:kPG_Colour_Nav_Title],
       UITextAttributeTextShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
       UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
       UITextAttributeFont:[PGApp.app font:kPG_Font_Nav]
       }];


        [self setShadowImage:[UIImage new]];


}

+ (UIImage *)maskedImage {

    const CGFloat colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [UIImage imageNamed:kPG_Image_Nav_Background44];
    return [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];

}

@end
