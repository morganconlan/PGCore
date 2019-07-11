//
//  PGCell.m
//  filinatv
//
//  Created by Morgan Conlan on 30/08/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import "PGCell.h"

NSString *const kPGCell = @"PGCell";
NSString *const kPGCell_Section = @"section";
NSString *const kPGCell_Row = @"row";
NSString *const kPGCell_Title = @"title";
NSString *const kPGCell_TitleFont = @"title_font";
NSString *const kPGCell_TitleBoldFont = @"title_bold_font";
NSString *const kPGCell_TitleColour = @"title_colour";
NSString *const kPGCell_TitleBoldColour = @"title_bold_colour";
NSString *const kPGCell_TitleIsCentred = @"title_is_centred";
NSString *const kPGCell_Detail = @"detail";
NSString *const kPGCell_DetailFont = @"detail_font";
NSString *const kPGCell_DetailColour = @"detail_colour";

NSString *const kPGCell_IsNotSet = @"is_not_set";

NSString *const kPGCell_IsSelectable = @"is_selectable";
NSString *const kPGCell_IsShowingAccessory = @"is_showing_accessory";

NSString *const kPGCell_IsAnimatingAccessory = @"is_animating_accessory";
NSString *const kPGCell_AccessoryColour = @"accessory_colour";

NSString *const kPGCell_WithCustomBackground = @"with_custom_background";
NSString *const kPGCell_Background = @"background";
NSString *const kPGCell_BackgroundHighlighted = @"background_highlighted";
NSString *const kPGCell_BackgroundEven = @"background_even";
NSString *const kPGCell_IsEven = @"is_even";

NSString *const kPGCell_IsLastInSection = @"is_last_in_section";
NSString *const kPGCell_IsDividerDisabled = @"disable_divider";
NSString *const kPGCell_Divider_Colour = @"divider_colour";

NSString *const kPGCell_IsExpanded = @"is_expanded";

NSString *const kPGCell_MinHeight = @"min_height";
NSString *const kPGCell_DelegateWidth = @"delegate_width";

NSString *const kPGCell_PaddingVertical = @"padding_vertical";
NSString *const kPGCell_PaddingVerticalTop = @"padding_vertical_top";
NSString *const kPGCell_PaddingVerticalBottom = @"padding_vertical_bottom";
NSString *const kPGCell_PaddingVerticalBottomDetail = @"padding_vertical_bottom_detail";
NSString *const kPGCell_PaddingHorizontal = @"padding_horizontal";
NSString *const kPGCell_PaddingHorizontalLeftOnly = @"padding_horizontal_left_only";
NSString *const kPGCell_PaddingContentView = @"padding_content_view";
NSString *const kPGCell_PaddingContentViewTop = @"padding_content_view_top";
NSString *const kPGCell_PaddingContentViewRight = @"padding_content_view_right";
NSString *const kPGCell_PaddingContentViewBottom = @"padding_content_view_bottom";
NSString *const kPGCell_PaddingContentViewLeft = @"padding_content_view_left";

NSString *const kPGCell_IsJustificationDisabled = @"disabled_justification";

static CGFloat const kPGCell_MinHeightDefault = 40.0f;
static CGFloat const kPGCell_PaddingVerticalDefault = 16.0f;
static CGFloat const kPGCell_PaddingHorizontalDefault = 10.0f;
static CGFloat const kPGCell_PaddingContentViewDefault = 0.0f;

@interface ContentView : UIView
@end

@implementation ContentView

- (void)drawRect:(CGRect)rect {

    UIView *contentView = self;
    
    while (contentView
           && ![contentView isKindOfClass:[PGCell class]])
        contentView = contentView.superview;
    
    [(PGCell *)contentView drawContentView:rect];
    
}

@end

@implementation PGCell

@synthesize backView;
@synthesize contentView;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style
                     reuseIdentifier:reuseIdentifier])) {
        

        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        contentView = [[ContentView alloc] initWithFrame:CGRectZero];
        contentView.opaque = NO;
        contentView.alpha  = PGApp.app.configs.cellContentViewAlpha;
        [self addSubview:contentView];

        self.accessory = [PGColouredAccessory accessoryWithColour:[PGApp.app colour:kPG_Colour_Cell_Accessory]];
        [self.accessory setFrame:CGRectZero];
        [contentView addSubview:self.accessory];
        
        self.divider = [[UIView alloc] initWithFrame:CGRectZero];
        self.divider.backgroundColor = [PGApp.app colour:kPG_Colour_Cell_Divider];
        [contentView addSubview:self.divider];
        
    }
    
    return self;
}

- (void)dealloc {
    
    [backView removeFromSuperview];
    [contentView removeFromSuperview];

}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    CGRect bounds = [self bounds];
    
    [backView setFrame:bounds];
    [contentView setFrame:bounds];

    [self setNeedsDisplay];
    
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    
    [backView setNeedsDisplay];

    contentView.backgroundColor = [self currentBackgroundColour];
    [contentView setNeedsDisplay];
    
}

- (void)updateCellInfo:(NSMutableDictionary*)info {
    
    self.info = info;

    if ([info[kPGCell_IsShowingAccessory] boolValue]) {

        if (self.accessory) [self.accessory removeFromSuperview];

        UIColor *accessoryColour = (info[kPGCell_AccessoryColour])
                                    ? info[kPGCell_AccessoryColour]
                                    : [PGApp.app colour:kPG_Colour_Cell_Accessory];

        self.accessory = [PGColouredAccessory accessoryWithColour:accessoryColour];
        [self.contentView addSubview:self.accessory];

    }

    if (info[kPGCell_Divider_Colour])
        self.divider.backgroundColor = info[kPGCell_Divider_Colour];

    [self setNeedsDisplay];
    
}

- (BOOL)isCellSelected {
    
    return self.isSelected;
    
}

// subclasses should implement this
- (void)selectCell:(BOOL)selected {
    
    self.isSelected = selected;
    
//    [self.contentView setBackgroundColor:(self.isSelected)
//                                            ? [PGApp.app colour:kPG_Colour_Cell_Selection]
//                                            : [PGApp.app colour:kPG_Colour_Cell_Background]];

    [self setNeedsDisplay];
    
}

- (void)setHighlighted:(BOOL)highlighted
              animated:(BOOL)animated {
    
    if (![self.info[kPGCell_IsSelectable] boolValue]) {

        self.isHighlighted = NO;
        return;

    }

    self.isHighlighted = highlighted;

    [self setNeedsDisplay];
    
    if (!PGApp.app.configs.animateCellDivider
        || [self.info[kPGCell_IsLastInSection] boolValue]
        || [self.info[kPGCell_IsDividerDisabled] boolValue]) {

        return;
    }
    
    CGRect frame = (highlighted)
                    ? CGRectMake(0,
                                 self.bounds.size.height - 1,
                                 self.bounds.size.width,
                                 1)
                    : CGRectMake(30,
                                 self.bounds.size.height - 1,
                                 self.bounds.size.width - 40,
                                 1);
    
    [UIView animateWithDuration:PGApp.app.randomDuration animations:^
     {
         self.divider.alpha = 1.0f;
         [self.divider setFrame:frame];
         
     }];
}

+ (void)setupPaddingForInfo:(NSDictionary *)info
               useableWidth:(CGFloat *)useableWidth
            paddingVertical:(CGFloat *)paddingVertical
         paddingVerticalTop:(CGFloat *)paddingVerticalTop
      paddingVerticalBottom:(CGFloat *)paddingVerticalBottom
paddingVerticalBottomDetail:(CGFloat *)paddingVerticalBottomDetail
         paddingHorrizontal:(CGFloat *)paddingHorrizontal
                  minHeight:(CGFloat *)minHeight {

    *paddingVertical = (info[kPGCell_PaddingVertical])
                        ? [info[kPGCell_PaddingVertical] floatValue]
                        : kPGCell_PaddingVerticalDefault;

    *paddingVerticalTop = (info[kPGCell_PaddingVerticalTop])
                            ? [info[kPGCell_PaddingVerticalTop] floatValue]
                            : *paddingVertical;

    *paddingVerticalBottom = (info[kPGCell_PaddingVerticalBottom])
                                ? [info[kPGCell_PaddingVerticalBottom] floatValue]
                                : *paddingVertical;

    *paddingVerticalBottomDetail = (info[kPGCell_PaddingVerticalBottomDetail])
                                    ? [info[kPGCell_PaddingVerticalBottomDetail] floatValue]
                                    : 0;

    *paddingHorrizontal = (info[kPGCell_PaddingHorizontal])
                            ? [info[kPGCell_PaddingHorizontal] floatValue]
                            : kPGCell_PaddingHorizontalDefault;

    *minHeight = (info[kPGCell_MinHeight])
                    ? [info[kPGCell_MinHeight] floatValue]
                    : kPGCell_MinHeightDefault;

    CGFloat width = [info[kPGCell_DelegateWidth] floatValue];
    if ([info[kPGCell_IsShowingAccessory] boolValue])
        width -= 40.0f;

    NSInteger paddedHorrizontalSides = ([info[kPGCell_PaddingHorizontalLeftOnly] boolValue]) ? 1 : 2;
    width -= paddedHorrizontalSides * (*paddingHorrizontal);
    *useableWidth = width;

}

+ (CGFloat)heightWithCellInfo:(NSMutableDictionary *)info {

    CGFloat useableWidth, paddingVertical, paddingVerticalTop, paddingVerticalBottom,
    paddingVerticalBottomDetail, paddingHorrizontal, minHeight;

    [PGCell setupPaddingForInfo:info
                   useableWidth:&useableWidth
                paddingVertical:&paddingVertical
             paddingVerticalTop:&paddingVerticalTop
          paddingVerticalBottom:&paddingVerticalBottom
    paddingVerticalBottomDetail:&paddingVerticalBottomDetail
             paddingHorrizontal:&paddingHorrizontal
                      minHeight:&minHeight];

    CGFloat cellHeight = paddingVerticalTop;

    UIFont *titleFont = (info[kPGCell_TitleFont])
                            ? info[kPGCell_TitleFont]
                            : [[self class] titleFont];
    
    //Title
    NSString *title = info[kPGCell_Title];
    CGSize titleSize = [PGCell sizeForText:title
                                  withFont:titleFont
                                   inWidth:useableWidth];
    
    cellHeight += titleSize.height + paddingVerticalBottom;

    if (info[kPGCell_Detail] != nil) {

        UIFont *detailFont = (info[kPGCell_DetailFont])
                            ? info[kPGCell_DetailFont]
                            : [PGApp.app font:kPG_Font_Cell_Subtitle];

        CGSize detailSize = [PGCell sizeForText:info[kPGCell_Detail]
                                       withFont:detailFont
                                        inWidth:useableWidth];

        cellHeight += detailSize.height + paddingVerticalBottomDetail;

    }
    
    return MAX(ceilf(cellHeight), minHeight);

}

- (void)drawContentView:(CGRect)rect {

    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cont, [self.currentBackgroundColour CGColor]);
    CGContextFillRect(cont, [self backgroundFrameForRect:rect]);

    CGFloat useableWidth, paddingVertical, paddingVerticalTop, paddingVerticalBottom,
    paddingVerticalBottomDetail, paddingHorrizontal, minHeight;

    [PGCell setupPaddingForInfo:self.info
                   useableWidth:&useableWidth
                paddingVertical:&paddingVertical
             paddingVerticalTop:&paddingVerticalTop
          paddingVerticalBottom:&paddingVerticalBottom
    paddingVerticalBottomDetail:&paddingVerticalBottomDetail
             paddingHorrizontal:&paddingHorrizontal
                      minHeight:&minHeight];

    CGFloat cellHeight = paddingVertical;

    NSMutableParagraphStyle *paragraphStyle =
        (self.info[kPGCell_IsJustificationDisabled] != nil
         && [self.info[kPGCell_IsJustificationDisabled] boolValue])
            ? [PGCell paragraphStyleNone]
            : [PGCell paragraphStyle];

    UIFont *titleFont = (self.info[kPGCell_TitleFont])
                            ? self.info[kPGCell_TitleFont]
                            : [[self class] titleFont];

    UIFont *detailFont = (self.info[kPGCell_DetailFont])
                            ? self.info[kPGCell_DetailFont]
                            : [PGApp.app font:kPG_Font_Cell_Subtitle];

    //Title
    NSString *title = self.info[kPGCell_Title];
    CGSize titleSize = [PGCell sizeForText:title
                                  withFont:titleFont
                                   inWidth:useableWidth];

    NSString *detail = self.info[kPGCell_Detail];
    CGSize detailSize = [PGCell sizeForText:detail
                                   withFont:detailFont
                                    inWidth:useableWidth];

    CGFloat detailOffset = (detail == [NSNull null] || detail.length == 0)
                            ? 0
                            : (detailSize.height + paddingVerticalBottomDetail);

    // always vertically center if title only unless vertical padding bottom is explicitly set
    CGFloat titleOffset = (self.info[kPGCell_Detail] == nil)
                            ? (paddingVerticalBottom == 0)
                                ? (self.bounds.size.height - titleSize.height)
                                : ((self.bounds.size.height - titleSize.height) / 2)
                            : paddingVerticalTop;

    CGRect titleFrame = ([self.info[kPGCell_TitleIsCentred] boolValue])
                            ? CGRectMake((self.bounds.size.width - detailOffset - titleSize.width) / 2,
                                         titleOffset,
                                         titleSize.width,
                                         titleSize.height)
                            : CGRectMake(paddingHorrizontal,
                                         titleOffset,
                                         useableWidth,
                                         titleSize.height);

    UIColor *titleColour = (self.info[kPGCell_TitleColour])
                            ? (UIColor *)self.info[kPGCell_TitleColour]
                            : [PGApp.app colour:kPG_Colour_Cell_Title];

    [title drawInRect:titleFrame
       withAttributes:@{NSFontAttributeName:titleFont,
                        NSForegroundColorAttributeName:titleColour,
                        NSParagraphStyleAttributeName:paragraphStyle}];

    if (self.info[kPGCell_Detail] == [NSNull null]
        || self.info[kPGCell_Detail] == nil) return;

    
    UIColor *detailColour = (self.info[kPGCell_DetailColour])
                            ? (UIColor *)self.info[kPGCell_DetailColour]
                            : [PGApp.app colour:kPG_Colour_Cell_Subtitle];

    CGRect detailFrame = ([self.info[kPGCell_TitleIsCentred] boolValue])
                            ? CGRectMake((self.bounds.size.width - detailSize.width) / 2,
                                         titleFrame.origin.y + titleSize.height + paddingVerticalBottom,
                                         detailSize.width,
                                         detailSize.height)
                            : CGRectMake(paddingHorrizontal,
                                         titleFrame.origin.y + titleSize.height + paddingVerticalBottom,
                                         useableWidth,
                                         detailSize.height);

    [detail drawInRect:detailFrame
       withAttributes:@{NSFontAttributeName:detailFont,
                        NSForegroundColorAttributeName:detailColour,
                        NSParagraphStyleAttributeName:paragraphStyle}];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self layoutAccessory];
    [self layoutDivider];
    
}

- (CGRect)backgroundFrameForRect:(CGRect)rect {

    if (!(self.info[kPGCell_PaddingContentView]
        || self.info[kPGCell_PaddingContentViewTop]
        || self.info[kPGCell_PaddingContentViewRight]
        || self.info[kPGCell_PaddingContentViewBottom]
        || self.info[kPGCell_PaddingContentViewLeft])) return rect;

    CGFloat padding = [self.info[kPGCell_PaddingContentView] floatValue];
    if (padding == 0) padding = kPGCell_PaddingContentViewDefault;

    CGFloat paddingTop, paddingRight, paddingBottom, paddingLeft;

    paddingTop = (self.info[kPGCell_PaddingContentViewTop])
                    ? [self.info[kPGCell_PaddingContentViewTop] floatValue]
                    : padding / 2.0f;

    paddingRight = (self.info[kPGCell_PaddingContentViewRight])
                    ? [self.info[kPGCell_PaddingContentViewRight] floatValue]
                    : padding / 2.0f;

    paddingBottom = (self.info[kPGCell_PaddingContentViewBottom])
                    ? [self.info[kPGCell_PaddingContentViewBottom] floatValue]
                    : padding / 2.0f;

    paddingLeft = (self.info[kPGCell_PaddingContentViewLeft])
                    ? [self.info[kPGCell_PaddingContentViewLeft] floatValue]
                    : padding / 2.0f;

    CGRect paddedContent = rect;
    paddedContent.origin.x += paddingLeft;
    paddedContent.origin.y += paddingTop;
    paddedContent.size.width -= paddingRight + paddingLeft;
    paddedContent.size.height -= paddingTop + paddingBottom;

    return paddedContent;

}

- (void)layoutAccessory {

    if (![self.info[kPGCell_IsShowingAccessory] boolValue]) {

        [self.accessory setFrame:CGRectZero];
        return;
    }

    if (![self.info[kPGCell_IsAnimatingAccessory] boolValue]) {

        [self.accessory setFrame:CGRectMake(self.bounds.size.width - 30,
                                            (self.bounds.size.height - 20) / 2,
                                            20,
                                            20)];
        return;
    }

    // Animate the from left to right, fading in, random delay & duration
    self.accessory.alpha = 0.0f;
    [self.accessory setFrame:CGRectMake(self.bounds.size.width - 60,
                                        (self.bounds.size.height - 20) / 2,
                                        20,
                                        20)];

    [UIView animateWithDuration:PGApp.app.randomDuration / 2
                          delay:PGApp.app.randomDuration / 4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
    {
        [self.accessory setFrame:CGRectMake(self.bounds.size.width - 30,
                                            (self.bounds.size.height - 20) / 2,
                                            20,
                                            20)];
        self.accessory.alpha = 1.0f;
    }
                     completion:nil];


}

- (void)layoutDivider {

    if (self.divider == nil
        || [self.info[kPGCell_IsLastInSection] boolValue]
        || [self.info[kPGCell_IsDividerDisabled] boolValue]) {

        [self.divider setFrame:CGRectZero];
        return;
    }

    if (!PGApp.app.configs.animateCellDivider) {

        [self.divider setFrame:CGRectMake(30,
                                          self.bounds.size.height - 1,
                                          self.bounds.size.width - 40,
                                          1)];
        return;
    }

    // Animate the divider
    self.divider.alpha = 0.0f;
    [self.divider setFrame:CGRectMake(30,
                                      self.bounds.size.height - 1,
                                      0,
                                      1)];

    [UIView animateWithDuration:PGApp.app.randomDuration animations:^
     {
         self.divider.alpha = 1.0f;
         [self.divider setFrame:CGRectMake(30,
                                           self.bounds.size.height - 1,
                                           self.bounds.size.width - 40,
                                           1)];

     }];

}

- (UIColor *)currentBackgroundColour {

    UIColor *backgroundHighlighted = (self.info[kPGCell_BackgroundHighlighted] != nil)
                                        ? self.info[kPGCell_BackgroundHighlighted]
                                        : [PGApp.app colour:kPG_Colour_Cell_Selection];

    UIColor *background = (self.info[kPGCell_Background] != nil)
                            ? self.info[kPGCell_Background]
                            : [PGApp.app colour:kPG_Colour_Cell_Background];
        
    UIColor *backgroundEven = (self.info[kPGCell_BackgroundEven] != nil)
                                ? self.info[kPGCell_BackgroundEven]
                                : background;
    
    return (self.isHighlighted)
            ?   backgroundHighlighted
            :   (self.isSelected)
                ? backgroundHighlighted
                : ([self.info[kPGCell_IsEven] boolValue])
                    ? backgroundEven
                    : background;


}

+ (UIFont *)titleFont {
    return [PGApp.app font:kPG_Font_Cell_Title];
}

+ (NSMutableParagraphStyle *)paragraphStyle {

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.firstLineHeadIndent = 0.05;    // IMP: must have a value to make it work
    paragraphStyle.alignment = NSTextAlignmentJustified;

    return paragraphStyle;

}

+ (NSMutableParagraphStyle *)paragraphStyleNone {

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.firstLineHeadIndent = 0.05;    // IMP: must have a value to make it work

    return paragraphStyle;

}

+ (CGFloat)heightForText:(NSString *)text
            withFontName:(NSString *)fontName
                 inWidth:(CGFloat)width {
    
    return [PGCell heightForText:text
                        withFont:[PGApp.app font:fontName]
                         inWidth:width];
}

+ (CGFloat)heightForText:(NSString *)text
                withFont:(UIFont *)font
                 inWidth:(CGFloat)width {
    
    CGSize textSize = CGSizeZero;
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);

    NSMutableParagraphStyle *paragraphStyle = [PGCell paragraphStyle];

    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle};

    textSize = [text boundingRectWithSize:constraintSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributes
                                  context:NULL].size;
    
    return ceilf(textSize.height);
    
}

+ (CGSize)sizeForText:(NSString *)text
         withFontName:(NSString *)fontName
              inWidth:(CGFloat)width {

    return [PGCell sizeForText:text
                      withFont:[PGApp.app font:fontName]
                       inWidth:width];

}

+ (CGSize)sizeForText:(NSString *)text
         withFont:(UIFont *)font
              inWidth:(CGFloat)width {

    CGSize textSize = CGSizeZero;

    if (text == [NSNull null] || text == nil || text.length == 0) return textSize;

    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);

    NSMutableParagraphStyle *paragraphStyle = [PGCell paragraphStyle];

    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle};

    textSize = [text boundingRectWithSize:constraintSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributes
                                  context:NULL].size;

    // boundingRect returns fractional size, so round up
    return CGSizeMake(ceilf(textSize.width),
                      ceilf(textSize.height));
    
}

- (void)debugY:(CGFloat)y {

    [self debugY:y
      withColour:[PGApp.app hexString:@"33FF0000"]];
}

- (void)debugY:(CGFloat)y
    withColour:(UIColor *)colour {

    if (!PGApp.app.configs.isDebugging
        || !PGApp.app.configs.isDebuggingViews) return;

    CGFloat width = self.bounds.size.width;
    CGPoint from = CGPointMake(0, y);
    CGPoint to = CGPointMake(width, y);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, colour.CGColor);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);

}

- (void)debugX:(CGFloat)x {

    [self debugX:x
      withColour:[PGApp.app hexString:@"33FF0000"]];

}

- (void)debugX:(CGFloat)x
    withColour:(UIColor *)colour {

    if (!PGApp.app.configs.isDebugging
        || !PGApp.app.configs.isDebuggingViews) return;

    CGFloat height = self.bounds.size.height;
    CGPoint from = CGPointMake(x, 0);
    CGPoint to = CGPointMake(x, height);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, colour.CGColor);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);

}

- (void)debugRect:(CGRect)rect {

    [self debugRect:rect
           withFill:[PGApp.app hexString:@"33FF0000"]];

}

- (void)debugRect:(CGRect)rect
         withFill:(UIColor *)colour {

    if (!PGApp.app.configs.isDebugging
        || !PGApp.app.configs.isDebuggingViews) return;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, colour.CGColor);
    CGContextFillRect(context, rect);

}

@end
