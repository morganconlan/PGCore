//
//  PGCell.h
//  pgcore
//
//  Created by Morgan Conlan on 05/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"
#import "PGTBDelegate.h"
#import "PGColouredAccessory.h"
#import "PGTBDelegate.h"
#include <tgmath.h>

#pragma mark - info keys
/// Base cell type. Refers to class name.
extern NSString *const kPGCell;
/// Current indexPath section
extern NSString *const kPGCell_Section;
/// Current indexPath row
extern NSString *const kPGCell_Row;
/// NSString - Title text
extern NSString *const kPGCell_Title;
/// UIFont - Title Font
extern NSString *const kPGCell_TitleFont;
/// UIFont - Title Bold Font
extern NSString *const kPGCell_TitleBoldFont;
/// UIColor - Title colour
extern NSString *const kPGCell_TitleColour;
/// UIColor - Title bold colour
extern NSString *const kPGCell_TitleBoldColour;
/// Boolean - Title is centred
extern NSString *const kPGCell_TitleIsCentred;
/// NSString - Detail text
extern NSString *const kPGCell_Detail;
/// UIFont - Detail Font
extern NSString *const kPGCell_DetailFont;
/// UIColor - Detail colour
extern NSString *const kPGCell_DetailColour;

/// NSNumber - Boolean value. Visually display that a value is not set
extern NSString *const kPGCell_IsNotSet;

extern NSString *const kPGCell_IsSelectable;
extern NSString *const kPGCell_IsShowingAccessory;
extern NSString *const kPGCell_IsAnimatingAccessory;
extern NSString *const kPGCell_AccessoryColour;

extern NSString *const kPGCell_WithCustomBackground;
extern NSString *const kPGCell_Background;
extern NSString *const kPGCell_BackgroundHighlighted;
extern NSString *const kPGCell_BackgroundEven;
extern NSString *const kPGCell_IsEven;

extern NSString *const kPGCell_IsLastInSection;
extern NSString *const kPGCell_IsDividerDisabled;
extern NSString *const kPGCell_Divider_Colour;

extern NSString *const kPGCell_IsExpanded;

extern NSString *const kPGCell_MinHeight;
extern NSString *const kPGCell_DelegateWidth;
extern NSString *const kPGCell_PaddingVertical;
extern NSString *const kPGCell_PaddingVerticalTop;
extern NSString *const kPGCell_PaddingVerticalBottom;
extern NSString *const kPGCell_PaddingVerticalBottomDetail;
extern NSString *const kPGCell_PaddingHorizontal;
extern NSString *const kPGCell_PaddingHorizontalLeftOnly;
extern NSString *const kPGCell_PaddingContentView;
extern NSString *const kPGCell_PaddingContentViewTop;
extern NSString *const kPGCell_PaddingContentViewRight;
extern NSString *const kPGCell_PaddingContentViewBottom;
extern NSString *const kPGCell_PaddingContentViewLeft;

extern NSString *const kPGCell_IsJustificationDisabled;

@interface PGCell : UITableViewCell

@property (nonatomic, strong) NSMutableDictionary *info;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *divider;
@property (nonatomic, strong) UIColor *titleColour;
@property (nonatomic, strong) UIColor *accessoryColour;
@property (nonatomic, strong) UIColor *dividerColour;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isHighlighted;
@property (nonatomic, assign) BOOL isEven;
@property (nonatomic, weak) id<PGTBDelegate> delegate;
@property (nonatomic, strong) PGColouredAccessory *accessory;


- (void)drawContentView:(CGRect)rect;
- (void)updateCellInfo:(NSMutableDictionary *)info;
- (void)selectCell:(BOOL)selected;
- (BOOL)isCellSelected;
- (UIColor *)currentBackgroundColour;
+ (CGFloat)heightWithCellInfo:(NSMutableDictionary *)info;
+ (UIFont *)titleFont;

- (CGRect)backgroundFrameForRect:(CGRect)rect;

+ (void)setupPaddingForInfo:(NSDictionary *)info
               useableWidth:(CGFloat *)useableWidth
            paddingVertical:(CGFloat *)paddingVertical
         paddingVerticalTop:(CGFloat *)paddingVerticalTop
      paddingVerticalBottom:(CGFloat *)paddingVerticalBottom
paddingVerticalBottomDetail:(CGFloat *)paddingVerticalBottomDetail
         paddingHorrizontal:(CGFloat *)paddingHorrizontal
                  minHeight:(CGFloat *)minHeight;

+ (NSMutableParagraphStyle *)paragraphStyle;

+ (CGFloat)heightForText:(NSString *)text
                withFontName:(NSString *)fontName
                 inWidth:(CGFloat)width;

+ (CGFloat)heightForText:(NSString *)text
                withFont:(UIFont *)font
                 inWidth:(CGFloat)width;

+ (CGSize)sizeForText:(NSString *)text
         withFontName:(NSString *)fontName
              inWidth:(CGFloat)width;

+ (CGSize)sizeForText:(NSString *)text
         withFont:(UIFont *)font
              inWidth:(CGFloat)width;

# pragma mark - Debugging

/**
 Draw a line at a given y value to aid with debugging
 Defaults to red colour
 Requires configs.isDebugging and configs.isDebuggingViews to be set
 @param y
 Determines the y component of the line
 */
- (void)debugY:(CGFloat)y;
/**
 Draw a line at a given y value to aid with debugging
 Requires configs.isDebugging and configs.isDebuggingViews to be set
 @param y
 Determines the y component of the line
 @param colour
 The colour of the line draw
 */
- (void)debugY:(CGFloat)y
    withColour:(UIColor *)colour;
/**
 Draw a line at a given x value to aid with debugging
 Defaults to red colour
 Requires configs.isDebugging and configs.isDebuggingViews to be set
 @param x
 Determines the x component of the line
 */
- (void)debugX:(CGFloat)x;
/**
 Draw a line at a given x value to aid with debugging
 Requires configs.isDebugging and configs.isDebuggingViews to be set
 @param x
 Determines the x component of the line
 @param colour
 The colour of the line draw
 */
- (void)debugX:(CGFloat)x
    withColour:(UIColor *)colour;
/**
 Draw a filled rectangle to help with debugging
 @param rect
 Area to fill
 */
- (void)debugRect:(CGRect)rect;
/**
 Draw a filled rectangle to help with debugging
 @param rect
 Area to fill
 @param colour
 Colour of the fill
 */
- (void)debugRect:(CGRect)rect
         withFill:(UIColor *)colour;

@end
