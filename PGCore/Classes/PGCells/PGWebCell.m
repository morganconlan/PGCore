//
//  PGWebCell.m
//  pgcore
//
//  Created by Morgan Conlan on 11/05/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGApp.h"
#import "PGWebCell.h"

#define imgIconWeb (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_web"]; \
        		NSAssert(image, @"Image icon_web not found"); \
        		return image; \
        }()

@implementation PGWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style
                     reuseIdentifier:kPG_PGWebCell])) {

        self.titleColour = [PGApp.app colour:kPG_Colour_Web];
        
        [self prepare];
    }
    
    return self;
}

+ (BOOL)isShowingAccessory {
    return YES;
}

+ (UIView *)cellIcon {
    UIImageView *icon = [[UIImageView alloc] initWithImage:imgIconWeb];
    return icon;
}

+ (CGFloat)insetLeft {
    return 10.0f;
}

+ (CGFloat)insetTop {
    return 20.0f;
}

+ (UIFont *)font {
    return [PGApp.app font:kPG_Font_Cell_Title];
}

@end
