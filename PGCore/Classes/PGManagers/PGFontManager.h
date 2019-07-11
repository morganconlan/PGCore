//
//  PGFontManager.h
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"

@interface PGFontManager : NSObject

/******************************************************************************/
#pragma mark - Required Font Keys
/******************************************************************************/

extern NSString *const kPG_Font_Cell_Title;
extern NSString *const kPG_Font_Cell_Subtitle;
extern NSString *const kPG_Font_Cell_Text;
extern NSString *const kPG_Font_Paragraph;
extern NSString *const kPG_Font_Paragraph_Bold;
extern NSString *const kPG_Font_Paragraph_Italic;

extern NSString *const kPG_Font_Alert_Title;
extern NSString *const kPG_Font_Alert_Message;

extern NSString *const kPG_Font_Menu;
extern NSString *const kPG_Font_Cell_Default;
extern NSString *const kPG_Font_Nav;
extern NSString *const kPG_Font_Placeholder;
// Twitter
extern NSString *const kPG_Font_Twitter_Screenname;
extern NSString *const kPG_Font_Twitter_Username;
extern NSString *const kPG_Font_Twitter_Time;
extern NSString *const kPG_Font_Twitter_Text;
extern NSString *const kPG_Font_Twitter_Link;


@property (nonatomic, strong) NSMutableDictionary *fonts;

- (instancetype)initWithFonts:(NSMutableDictionary *)appFonts;

- (UIFont *)fontForKey:(NSString *)key;

@end
