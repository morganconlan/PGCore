//
//  PGEmailCell.m
//  pgcore
//
//  Created by Morgan Conlan on 11/05/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGEmailCell.h"

#define imgIconEmail (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_email"]; \
        		NSAssert(image, @"Image icon_email not found"); \
        		return image; \
        }()

@implementation PGEmailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style
                     reuseIdentifier:kPG_PGEmailCell])) {
        
        self.titleColour = [PGApp.app colour:kPG_Colour_Email];
        
        [self prepare];
    }
    
    return self;
}

+ (BOOL)isShowingAccessory {
    return YES;
}

+ (UIView *)cellIcon {
    UIImageView *icon = [[UIImageView alloc] initWithImage:imgIconEmail];
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
