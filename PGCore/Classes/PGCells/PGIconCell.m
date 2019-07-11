//
//  PGIconCell.m
//  pgcore
//
//  Created by Morgan Conlan on 11/08/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGIconCell.h"
#import "RemoteImageView.h"

#define kYOffset 16.0f

NSString *const kPGCell_Icon = @"img";
NSString *const kPGCell_Icon_IsRemote = @"is_remote";
NSString *const kPGCell_Icon_URL = @"url";
NSString *const kPGCell_Icon_Width = @"width";
NSString *const kPGCell_Icon_Height = @"height";
NSString *const kPGCell_Icon_IsCenteredVertically = @"is_centered_vertically";
NSString *const kPGCell_Icon_Padding = @"img_padding";

@interface PGIconCell()

@property (nonatomic, strong) RemoteImageView *icon;

@end

@implementation PGIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style
                     reuseIdentifier:reuseIdentifier])) {

        self.icon = [[RemoteImageView alloc] init];
        [self.contentView addSubview:self.icon];
        
    }
    
    return self;
}

+ (CGFloat)heightWithCellInfo:(NSDictionary *)info {
    
    CGFloat padding = (info[@"img_padding"] == nil
                       || [info[@"img_padding"] floatValue] == 0.0f)
                        ? 10.0f
                        : [info[@"img_padding"] floatValue];

    CGFloat icon_width;
    CGFloat icon_height;

    if ([info[kPGCell_Icon_IsRemote] boolValue]) {

        icon_width = [info[kPGCell_Icon_Width] floatValue] / 2;
        icon_height = [info[kPGCell_Icon_Height] floatValue] / 2;

    } else {

        UIImage *image = info[kPGCell_Icon];
        icon_width = image.size.width;
        icon_height = image.size.height;

    }
    
    CGFloat paddedImageWidth = (padding * 2) + icon_width;
    CGFloat paddedImageHeight = (padding * 2) + icon_height;
    CGFloat useableWidth = [info[kPGCell_DelegateWidth] floatValue] - ( 10 + paddedImageWidth);
    if ([info[kPGCell_IsShowingAccessory] boolValue]) useableWidth -= 40.0f;
    
    CGFloat cellHeight = kYOffset;
    UIFont *titleFont = (info[kPGCell_TitleFont] != nil)
                            ? info[kPGCell_TitleFont]
                            : [PGApp.app font:kPG_Font_Cell_Title];
    
    UIFont *detailFont = (info[kPGCell_DetailFont] != nil)
                            ? info[kPGCell_DetailFont]
                            : [PGApp.app font:kPG_Font_Cell_Subtitle];
    
    //Title
    cellHeight += [PGCell heightForText:info[kPGCell_Title]
                               withFont:titleFont
                                inWidth:useableWidth];
    
    if (info[kPGCell_Detail] == nil) {
        if (cellHeight < paddedImageHeight) cellHeight = paddedImageHeight;
        return ceilf(cellHeight);
        
    }
    
    cellHeight += [PGCell heightForText:info[kPGCell_Detail]
                               withFont:detailFont
                                inWidth:useableWidth]
                  + (kYOffset / 2);
    
    if (cellHeight < paddedImageHeight) cellHeight = paddedImageHeight;
    
    return ceilf(cellHeight);
    
}

- (void)drawContentView:(CGRect)rect {

    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cont, self.currentBackgroundColour.CGColor);
    CGContextFillRect(cont, rect);

    CGFloat padding = (self.info[kPGCell_Icon_Padding] == nil
                       || [self.info[kPGCell_Icon_Padding] floatValue] == 0.0f)
                        ? 10.0f
                        : [self.info[kPGCell_Icon_Padding] floatValue];

    CGFloat icon_width;
    CGFloat icon_height;

    if ([self.info[kPGCell_Icon_IsRemote] boolValue]) {

        icon_width = [self.info[kPGCell_Icon_Width] floatValue] / 2;
        icon_height = [self.info[kPGCell_Icon_Height] floatValue] / 2;

    } else {

        UIImage *image = self.info[kPGCell_Icon];
        icon_width = image.size.width;
        icon_height = image.size.height;

    }

    CGFloat paddedImageWidth = (padding * 2) + icon_width;
    CGFloat useableWidth = [self.info[kPGCell_DelegateWidth] floatValue] - ( 10 + paddedImageWidth);
    if ([self.info[kPGCell_IsShowingAccessory] boolValue]) useableWidth -= 40.0f;
    
    CGFloat cellHeight = kYOffset;
    
    UIFont *titleFont = (self.info[kPGCell_TitleFont] != nil)
                            ? self.info[kPGCell_TitleFont]
                            : [PGApp.app font:kPG_Font_Cell_Title];
    
    UIFont *detailFont = (self.info[kPGCell_DetailFont] != nil)
                            ? self.info[kPGCell_DetailFont]
                            : [PGApp.app font:kPG_Font_Cell_Subtitle];
    
    //Title
    CGFloat titleHeight = [PGCell heightForText:self.info[kPGCell_Title]
                                       withFont:titleFont
                                        inWidth:useableWidth];
    // Detail
    CGFloat detailHeight = [PGCell heightForText:self.info[kPGCell_Detail]
                                        withFont:detailFont
                                         inWidth:useableWidth];
    
    if (self.info[kPGCell_Icon_IsCenteredVertically]) {
        cellHeight = (self.bounds.size.height - (8 + detailHeight + titleHeight)) / 2;
        cellHeight += titleHeight / 4;
    }
    
    if (self.info[kPGCell_TitleColour] != nil)
        [(UIColor *)self.info[kPGCell_TitleColour] set];
    else
        [[PGApp.app colour:kPG_Colour_Cell_Title] set];
    
    [self.info[kPGCell_Title] drawInRect:CGRectMake(paddedImageWidth,
                                               cellHeight,
                                               useableWidth,
                                               titleHeight)
                           withFont:titleFont
                      lineBreakMode:NSLineBreakByWordWrapping];
    
    cellHeight += titleHeight + 4;

    if (self.info[kPGCell_DetailColour] != nil)
        [(UIColor *)self.info[kPGCell_DetailColour] set];
    else
        [(self.info[kPGCell_IsNotSet])
         ? [PGApp.app colour:kPG_Colour_Cell_Title_Not_Set]
         : [PGApp.app colour:kPG_Colour_Cell_Subtitle] set];
    
    [self.info[kPGCell_Detail] drawInRect:CGRectMake(paddedImageWidth,
                                                cellHeight,
                                                useableWidth,
                                                detailHeight)
                            withFont:detailFont
                       lineBreakMode:NSLineBreakByWordWrapping];
    
}

- (void)updateCellInfo:(NSMutableDictionary *)info {
    
    if (info[@"img_padding"] == nil) {
        NSMutableDictionary *newInfo = [info mutableCopy];
        newInfo[@"img_padding"] = @(10.0f);
        info = [NSDictionary dictionaryWithDictionary:newInfo];
    }

    [super updateCellInfo:info];

    if ([self.info[kPGCell_Icon_IsRemote] boolValue]) {

        NSString *urlString;

        // Check if src is already formed
        if ([self.info[kPGCell_Icon_URL] rangeOfString:PGApp.app.configs.s3assetsRoot].location != NSNotFound
            || [self.info[kPGCell_Icon_URL] rangeOfString:@"http://"].location != NSNotFound
            || [self.info[kPGCell_Icon_URL] rangeOfString:@"https://"].location != NSNotFound) {

            urlString = self.info[kPGCell_Icon_URL];

        } else {

            urlString = [NSString stringWithFormat:@"%@%@",
                         PGApp.app.configs.s3assetsRoot,
                         self.info[kPGCell_Icon_URL]];

        }

        DDLogVerbose(@"%@", urlString);
        CGFloat icon_height = [self.info[kPGCell_Icon_Height] floatValue] / 2;
        CGFloat padding = [self.info[@"img_padding"] floatValue];
        CGFloat yOffset = (self.info[kPGCell_Icon_IsCenteredVertically])
                            ? ((self.bounds.size.height - icon_height) / 2)
                            : padding;

        [self.icon setFrame:CGRectMake(padding,
                                       yOffset,
                                       [self.info[kPGCell_Icon_Width] floatValue],
                                       [self.info[kPGCell_Icon_Height] floatValue])];

        [self.icon setImageURL:[NSURL URLWithString:urlString]];

    } else {

        [self.icon setImage:info[kPGCell_Icon]];

    }

}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat icon_width;
    CGFloat icon_height;

    if ([self.info[kPGCell_Icon_IsRemote] boolValue]) {

        icon_width = [self.info[kPGCell_Icon_Width] floatValue] / 2;
        icon_height = [self.info[kPGCell_Icon_Height] floatValue] / 2;

    } else {

        UIImage *image = self.info[kPGCell_Icon];
        icon_width = image.size.width;
        icon_height = image.size.height;
        
    }

    CGFloat padding = [self.info[@"img_padding"] floatValue];
    CGFloat yOffset = (self.info[kPGCell_Icon_IsCenteredVertically])
                        ? ((self.bounds.size.height - icon_height) / 2)
                        : padding;
    
    [self.icon setFrame:CGRectMake(padding,
                                   yOffset,
                                   icon_width,
                                   icon_height)];
}

@end
