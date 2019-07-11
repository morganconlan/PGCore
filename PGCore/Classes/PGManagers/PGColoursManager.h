//
//  PGColoursManager.h
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"

@interface PGColoursManager : NSObject

/** Default background colour for PGVC */
extern NSString *const kPG_Colour_PGVC_Background;

/** Tint colour for fading PGVC in/out */
extern NSString *const kPG_Colour_PGVC_Background_Fade;

/** HUD colours */
extern NSString *const kPG_Colour_HUD_Background;
extern NSString *const kPG_Colour_HUD_Background_Warning;
extern NSString *const kPG_Colour_HUD;
extern NSString *const kPG_Colour_HUD_Title;
extern NSString *const kPG_Colour_HUD_Message;


/** Alert view title colour */
extern NSString *const kPG_Colour_Alert_Title;
extern NSString *const kPG_Colour_Alert_Message;
extern NSString *const kPG_Colour_Alert_Background;

/** Navigation bar colours */
extern NSString *const kPG_Colour_Nav_Title;
extern NSString *const kPG_Colour_Nav_Tint;

/** Menu cell colours */
extern NSString *const kPG_Colour_Menu_Title;
extern NSString *const kPG_Colour_Menu_Title_Selected;
extern NSString *const kPG_Colour_Menu_Background;
extern NSString *const kPG_Colour_Menu_Background_Selected;

/** Default cell colours */
extern NSString *const kPG_Colour_Cell_Title;
extern NSString *const kPG_Colour_Cell_Subtitle;
extern NSString *const kPG_Colour_Cell_Title_Not_Set;
extern NSString *const kPG_Colour_Cell_Subtitle_Not_Set;
extern NSString *const kPG_Colour_Cell_Background;
extern NSString *const kPG_Colour_Cell_Selection;
extern NSString *const kPG_Colour_Cell_Accessory;
extern NSString *const kPG_Colour_Cell_Divider;
extern NSString *const kPG_Colour_Email;
extern NSString *const kPG_Colour_Tel;
extern NSString *const kPG_Colour_Web;

/** Pull to refresh colours */
extern NSString *const kPG_Colour_Pull_To_Refresh;

/** Location colours */
extern NSString *const kPG_Colour_Location;
extern NSString *const kPG_Colour_Location_Address;

/** Twitter colours */
extern NSString *const kPG_Colour_Twitter_Screenname;
extern NSString *const kPG_Colour_Twitter_Link;
extern NSString *const kPG_Colour_Twitter_Hashtag;

/** Calendar colours */
extern NSString *const kPG_Colour_Calendar_Header_Title;
extern NSString *const kPG_Colour_Calendar_Header_Title_Highlight;
extern NSString *const kPG_Colour_Calendar_Header_Gradient_Light;
extern NSString *const kPG_Colour_Calendar_Header_Gradient_Dark;

extern NSString *const kPG_Colour_Calendar_Cell_Today;
extern NSString *const kPG_Colour_Calendar_Cell_Today_Unselected;
extern NSString *const kPG_Colour_Calendar_Cell_Text;
extern NSString *const kPG_Colour_Calendar_Cell_Selected;
extern NSString *const kPG_Colour_Calendar_Cell_Border;
extern NSString *const kPG_Colour_Calendar_Cell_Border_Selected;
extern NSString *const kPG_Colour_Calendar_Cell_Background;
extern NSString *const kPG_Colour_Calendar_Cell_Background_Inactive;
extern NSString *const kPG_Colour_Calendar_Cell_Background_Inactive_Selected;
extern NSString *const kPG_Colour_Calendar_Cell_Gradient_Light;
extern NSString *const kPG_Colour_Calendar_Cell_Gradient_Dark;

/** Image colours */
extern NSString *const kPG_Colour_Image_Border;
extern NSString *const kPG_Colour_Image_Overlay;
extern NSString *const kPG_Colour_Image_Caption;

@property (nonatomic, strong) NSMutableDictionary *colours;

- (instancetype)initWithColours:(NSMutableDictionary *)appColours;

- (UIColor *)colourForKey:(NSString *)key;
- (void)addColour:(UIColor *)colour forKey:(NSString *)key;
/** Returns an autoreleased UIColor instance with the hexadecimal color.
 
 @param hex A color in hexadecimal notation: `0xCCCCCC`, `0xF7F7F7`, etc.
 
 @return A new autoreleased UIColor instance. */
+ (UIColor *)colourForHex:(int)hex;
- (UIColor *)hex:(int)hex;
+ (UIColor *)colorForHexString:(NSString *)hexString;

@end
