//
//  PGPlainCell.m
//  pgcore
//
//  Created by Morgan Conlan on 10/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGPlainCell.h"

@interface PGPlainCell()

@property (nonatomic, assign) CGRect iconFrame;

@end

@implementation PGPlainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style
                     reuseIdentifier:reuseIdentifier])) {
        
        _isTextCentered = NO;
        self.titleColour = [PGApp.app colour:kPG_Colour_Cell_Title];
        self.accessoryColour = [PGApp.app colour:kPG_Colour_Cell_Accessory];
        self.dividerColour = [PGApp.app colour:kPG_Colour_Cell_Divider];

    }
    
    return self;
}

// To be called from subclass after the cell has been configured
- (void)prepare {
    
    if ([[self class] isShowingAccessory]
        && self.accessory == nil) {
        
        self.accessory = [PGColouredAccessory accessoryWithColour:self.accessoryColour];
        [self.contentView addSubview:self.accessory];
        
    }
    
    if ([[self class] cellIcon] != nil) {
        
        _icon = [[self class] cellIcon];
        CGRect iconFrame = _icon.frame;
        iconFrame.origin.x += [[self class] insetLeft];
        iconFrame.origin.y = (self.bounds.size.height - iconFrame.size.height) / 2;
        _iconFrame = iconFrame;
        
        [_icon setFrame:CGRectZero];
        //_icon.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
        [self.contentView addSubview:_icon];
    }
    
}

- (void)updateCellInfo:(NSMutableDictionary *)info {
    [super updateCellInfo:info];
    
    if (info[@"icon"] != nil) {
        
        [self.icon removeFromSuperview];
        self.icon = info[@"icon"];
        [self.contentView addSubview:self.icon];
        
    }
    
    if (info[@"title_colour"] != nil) {
        
        self.titleColour = info[@"title_colour"];
    
    }
    
    if (info[@"accessory_colour"] != nil) {
        
        self.accessory.accessoryColour = info[@"accessory_colour"];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_icon != nil) {
        
        CGRect frame = CGRectMake(_iconFrame.origin.x + _iconFrame.size.width / 2,
                                  (_iconFrame.origin.y + _iconFrame.size.height) / 2,
                                  1,
                                  1);
        [_icon setFrame:frame];
        
        CGRect targetFrame = _iconFrame;
        targetFrame.origin.y = (self.contentView.bounds.size.height - _iconFrame.size.height) / 2;
        
        [UIView animateWithDuration:[PGApp.app randomDuration] / 4
                              delay:[PGApp.app randomDuration] / 2
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [_icon setFrame:targetFrame];
                         }
                         completion:nil];
    }
    
}

+ (CGFloat)heightWithCellInfo:(NSDictionary *)info {
    
    CGFloat iconWidth = 0;
    
    if ([[self class] cellIcon] != nil) {
        iconWidth = [[[self class] cellIcon] frame].size.width;
    }
    
    CGFloat useableWidth = [info[kPGCell_DelegateWidth] floatValue] - (([[self class] insetRight] + [[self class] insetLeft]) + iconWidth);
    if ([[self class] isShowingAccessory]) useableWidth -= 30.0f + [[self class] insetRight];
    
    NSString *text = info[@"title"];
    UIFont *titleFont = (info[@"title_font"] != nil)
                            ? info[@"title_font"]
                            : [[self class] font];
    
    CGSize constraintSize = CGSizeMake(useableWidth, MAXFLOAT);
    CGSize textSize = [text sizeWithFont:titleFont
                       constrainedToSize:constraintSize
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat cellHeight = (2 * [[self class] insetTop]) + ceilf(textSize.height);
    
    return (40.0f > cellHeight) ? 40.0f : cellHeight;
}

- (void)drawContentView:(CGRect)rect {
    
    CGFloat iconWidth = 0;
    
    if ([[self class] cellIcon] != nil) {
        iconWidth = [[[self class] cellIcon] frame].size.width + [[self class] insetLeft];
    }
    
    CGFloat useableWidth = [self.info[kPGCell_DelegateWidth] floatValue] - (([[self class] insetRight] + [[self class] insetLeft]) + iconWidth);
    if ([[self class] isShowingAccessory]) useableWidth -= 30.0f + [[self class] insetRight];
    
    UIFont *titleFont = (self.info[@"title_font"] != nil)
                            ? self.info[@"title_font"]
                            : [[self class] font];
    
    NSString *text = self.info[@"title"];
    CGSize constraintSize = CGSizeMake(useableWidth, MAXFLOAT);
    CGSize textSize = [text sizeWithFont:titleFont
                         constrainedToSize:constraintSize
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.titleColour set];
    
    CGFloat centeringOffset = 0.0f;
 
    if ([[self class] isShowingAccessory]) centeringOffset += 30.0f;
    
    if (_isTextCentered
        || self.info[@"isCentred"] != nil) //Centre text relative to screen
        centeringOffset = ([self.info[kPGCell_DelegateWidth] floatValue] - textSize.width) / 2;
    else
        centeringOffset = iconWidth;
    
    [text drawInRect:CGRectMake([[self class] insetLeft] + centeringOffset,
                                [[self class] insetTop],
                                useableWidth,
                                textSize.height)
             withFont:titleFont
        lineBreakMode:NSLineBreakByWordWrapping];
}

+ (UIView *)cellIcon {
    return nil;
}

+ (BOOL)isShowingAccessory {
    return NO;
}

+ (CGFloat)insetLeft {
    return 10.0f;
}

+ (CGFloat)insetRight {
    return 30.0f;
}

+ (CGFloat)insetTop {
    return 10.0f;
}

+ (UIFont *)font {
    return [PGApp.app font:kPG_Font_Cell_Title];
}

@end
