//
//  PGTelCell.m
//  pgcore
//
//  Created by Morgan Conlan on 11/05/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGTelCell.h"

#define imgIconTel (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_tel"]; \
        		NSAssert(image, @"Image icon_tel not found"); \
        		return image; \
        }()

@implementation PGTelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style
                     reuseIdentifier:kPG_PGTelCell])) {

        self.titleColour = [PGApp.app colour:kPG_Colour_Tel];
        
        [self prepare];
    }
    
    return self;
}

+ (BOOL)isShowingAccessory {
    return YES;
}

+ (UIView *)cellIcon {
    UIImageView *icon = [[UIImageView alloc] initWithImage:imgIconTel];
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
