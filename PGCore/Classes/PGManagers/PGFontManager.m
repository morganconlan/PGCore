//
//  PGFontManager.m
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGFontManager.h"

@implementation PGFontManager

/******************************************************************************/
#pragma mark - Required Font Keys
/******************************************************************************/

NSString *const kPG_Font_Cell_Title = @"kPG_Font_Cell_Title";
NSString *const kPG_Font_Cell_Subtitle = @"kPG_Font_Cell_Subtitle";
NSString *const kPG_Font_Cell_Text = @"kPG_Font_Cell_Text";
NSString *const kPG_Font_Paragraph = @"kPG_Font_Paragraph";
NSString *const kPG_Font_Paragraph_Bold = @"kPG_Font_Paragraph_Bold";
NSString *const kPG_Font_Paragraph_Italic = @"kPG_Font_Paragraph_Italic";
NSString *const kPG_Font_Alert_Title = @"kPG_Font_Alert_Title";
NSString *const kPG_Font_Alert_Message = @"kPG_Font_Alert_Message";
NSString *const kPG_Font_Menu = @"kPG_Font_Menu";
NSString *const kPG_Font_Cell_Default = @"kPG_Font_Cell_Default";
NSString *const kPG_Font_Nav = @"kPG_Font_Nav";
NSString *const kPG_Font_Placeholder = @"Font_Placeholder";
// Twitter
NSString *const kPG_Font_Twitter_Screenname = @"Twitter_Screenname";
NSString *const kPG_Font_Twitter_Username = @"Twitter_Username";
NSString *const kPG_Font_Twitter_Time = @"Twitter_Time";
NSString *const kPG_Font_Twitter_Text = @"Twitter_Text";
NSString *const kPG_Font_Twitter_Link = @"Twitter_Link";

- (instancetype)init {
    
    if ((self = [super init])) {
    
        _fonts = [self fonts];
    }
    
    return self;
}

- (instancetype)initWithFonts:(NSMutableDictionary *)appFonts {
    
    if ((self = self.init)) {
        
        [_fonts addEntriesFromDictionary:appFonts];
        
    }
    
    return self;
}

- (UIFont *)fontForKey:(NSString *)key {
    
    if (_fonts == nil
        || _fonts[key] == nil) {

        DDLogError(@"font not found for key: %@", key);
        return [UIFont systemFontOfSize:13.0f];
    
    }
    
    return _fonts[key];
    
}

- (NSMutableDictionary *)fonts {
    
    NSMutableDictionary *fonts = [NSMutableDictionary dictionary];
    
    fonts[kPG_Font_Alert_Title] = [UIFont fontWithName:@"Avenir-Black" size:18.0f];
    fonts[kPG_Font_Alert_Message] = [UIFont fontWithName:@"Avenir-Light" size:16.0f];
    
    fonts[kPG_Font_Menu] = [UIFont fontWithName:@"Avenir-Black" size:12.0f];
    fonts[kPG_Font_Cell_Default] = [UIFont fontWithName:@"Avenir-Light" size:12.0f];
    fonts[kPG_Font_Nav] = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    fonts[kPG_Font_Placeholder] = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    fonts[kPG_Font_Paragraph] = [UIFont fontWithName:@"Avenir-Light" size:12.0f];
    fonts[kPG_Font_Paragraph_Bold] = [UIFont fontWithName:@"Avenir-Black" size:12.0f];
    fonts[kPG_Font_Paragraph_Italic] = [UIFont fontWithName:@"Avenir-Light" size:12.0f];
    // Twitter
    fonts[kPG_Font_Twitter_Username] = [UIFont fontWithName:@"Avenir-Black" size:14.0f];
    fonts[kPG_Font_Twitter_Screenname] = [UIFont fontWithName:@"Avenir-Light" size:12.0f];
    fonts[kPG_Font_Twitter_Time] = [UIFont fontWithName:@"Avenir-Light" size:12.0f];
    fonts[kPG_Font_Twitter_Text] = [UIFont fontWithName:@"Avenir-Light" size:13.0f];
    fonts[kPG_Font_Twitter_Link] = [UIFont fontWithName:@"Avenir-Black" size:13.0f];

    return fonts;

}

@end
