//
//  PGParagraphCell.m
//  pgcore
//
//  Created by Morgan Conlan on 24/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGParagraphCell.h"
#import "MTStringAttributes.h"
#import "MTStringParser.h"
#define kYOffset 16.0f

NSString *const kPG_Paragraph_Bold_Tag = @"Tag";
NSString *const kPG_Paragraph_Padding_Horizontal = @"Padding_Horizontal";
NSString *const kPG_Paragraph_Padding_Vertical = @"Padding_Vertical";
NSString *const kPG_Paragraph_IsCentered = @"Is_Centered";

@interface PGParagraphCell()

@property (nonatomic, strong) UIColor *titleBoldColour;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *boldFont;

@end

@implementation PGParagraphCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {

    if ((self = [super initWithStyle:style
                     reuseIdentifier:reuseIdentifier])) {

        self.accessory = [PGColouredAccessory accessoryWithColour:[PGApp.app colour:kPG_Colour_Cell_Accessory]];
        [self.contentView addSubview:self.accessory];

        _lbl = [[UILabel alloc] init];
        _lbl.textColor = [PGApp.app colour:kPG_Colour_Cell_Title];
        _lbl.numberOfLines = 0;
        _lbl.lineBreakMode = NSLineBreakByWordWrapping;
        _lbl.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:_lbl];

    }

    return self;
}

+ (CGFloat)heightWithCellInfo:(NSDictionary *)info {

    CGFloat paddingHorrizontal = (info[kPGCell_PaddingHorizontal] != nil)
        ? [info[kPGCell_PaddingHorizontal] floatValue]
        : 20.0f;

    CGFloat paddingVertical = (info[kPGCell_PaddingVertical] != nil)
        ? [info[kPGCell_PaddingVertical] floatValue]
        : kYOffset;

    //width minus favoutite button and accessory
    CGFloat useableWidth = [info[kPGCell_DelegateWidth] floatValue] - (2 * paddingHorrizontal);

    CGFloat cellHeight = paddingVertical;

    //Title
    NSString *title = info[kPGCell_Title];
    UIFont *font = (info[kPGCell_TitleFont] != nil)
                    ? info[kPGCell_TitleFont]
                    : [PGApp.app font:kPG_Font_Paragraph];

    CGSize titleSize = [PGCell sizeForText:title
                                  withFont:font
                                   inWidth:useableWidth];

    cellHeight += titleSize.height + paddingVertical;

    return ceilf(cellHeight);

}

- (void)drawContentView:(CGRect)rect {

    self.titleColour =
        (self.info[kPGCell_TitleColour] != nil)
            ? self.info[kPGCell_TitleColour]
            : [PGApp.app colour:kPG_Colour_Cell_Title];

    self.titleBoldColour =
        (self.info[kPGCell_TitleBoldColour] != nil)
            ? self.info[kPGCell_TitleBoldColour]
            : [PGApp.app colour:kPG_Colour_Cell_Title];

    self.font =
        (self.info[kPGCell_TitleFont] != nil)
            ? self.info[kPGCell_TitleFont]
            : [PGApp.app font:kPG_Font_Paragraph];

    self.boldFont =
        (self.info[kPGCell_TitleBoldFont] != nil)
            ? self.info[kPGCell_TitleBoldFont]
            : [PGApp.app font:kPG_Font_Paragraph_Bold];

    NSString *tag =
        (self.info[kPG_Paragraph_Bold_Tag] != nil)
            ? self.info[kPG_Paragraph_Bold_Tag]
            : @"b";

    [[MTStringParser sharedParser] addStyleWithTagName:tag
                                                  font:self.boldFont
                                                 color:self.titleBoldColour];

    MTStringAttributes *attributes = [[MTStringAttributes alloc] init];
    attributes.font             = self.font;
    attributes.textColor        = self.titleColour;

    if (self.info[kPGCell_IsJustificationDisabled] == nil
         || ![self.info[kPGCell_IsJustificationDisabled] boolValue])
        attributes.alignment = NSTextAlignmentJustified;

    if (self.info[kPG_Paragraph_IsCentered] != nil
        && [self.info[kPG_Paragraph_IsCentered] boolValue])
        attributes.alignment = NSTextAlignmentCenter;

    [[MTStringParser sharedParser] setDefaultAttributes:attributes];

    NSString *value = self.info[kPGCell_Title];
    NSAttributedString *string = [[MTStringParser sharedParser]
                                  attributedStringFromMarkup:value];

    _lbl.attributedText = string;

}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat paddingHorrizontal = (self.info[kPGCell_PaddingHorizontal] != nil)
        ? [self.info[kPGCell_PaddingHorizontal] floatValue]
        : 20.0f;

    CGFloat paddingVertical = (self.info[kPGCell_PaddingVertical] != nil)
        ? [self.info[kPGCell_PaddingVertical] floatValue]
        : kYOffset;

    //width minus favoutite button and accessory
    CGFloat useableWidth = [self.info[kPGCell_DelegateWidth] floatValue] - (2 * paddingHorrizontal);

    if (!self.info[kPGCell_TitleFont]) {
        DDLogVerbose(@"no font: %@", self.info[kPGCell_Title]);
        self.info[kPGCell_TitleFont] = [PGApp.app font:kPG_Font_Paragraph];
    }

    CGSize titleSize = [PGCell sizeForText:self.info[kPGCell_Title]
                                  withFont:self.info[kPGCell_TitleFont]
                                   inWidth:useableWidth];

    [_lbl setFrame:CGRectMake(paddingHorrizontal,
                              paddingVertical,
                              useableWidth,
                              titleSize.height)];


}

@end
