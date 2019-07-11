//
//  PGColoursManager.m
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGColoursManager.h"

@implementation PGColoursManager

/******************************************************************************/
#pragma mark - Required Colour Keys
/******************************************************************************/

/** Default background colour for PGVC */
NSString *const kPG_Colour_PGVC_Background          = @"kPG_Colour_PGVC_Background";
NSString *const kPG_Colour_PGVC_Background_Fade     = @"kPG_Colour_PGVC_Background_Fade";
NSString *const kPG_Colour_Alert_Title              = @"kPG_Colour_Alert_Title";
NSString *const kPG_Colour_Alert_Message            = @"kPG_Colour_Alert_Message";
NSString *const kPG_Colour_Alert_Background         = @"kPG_Colour_Alert_Background";
NSString *const kPG_Colour_Nav_Title                = @"kPG_Colour_Nav_Title";
NSString *const kPG_Colour_Nav_Tint                 = @"kPG_Colour_Nav_Tint";

/** HUD colours */
NSString *const kPG_Colour_HUD_Background           = @"kPG_Colour_HUD_Background";
NSString *const kPG_Colour_HUD_Background_Warning   = @"kPG_Colour_HUD_Background_Warning";
NSString *const kPG_Colour_HUD                      = @"kPG_Colour_HUD";
NSString *const kPG_Colour_HUD_Title                = @"kPG_Colour_HUD_Title";
NSString *const kPG_Colour_HUD_Message              = @"kPG_Colour_HUD_Message";

/** Default Menu Colours */
NSString *const kPG_Colour_Menu_Title               = @"kPG_Colour_Menu_Title";
NSString *const kPG_Colour_Menu_Title_Selected      = @"kPG_Colour_Menu_Title_Selected";
NSString *const kPG_Colour_Menu_Background          = @"kPG_Colour_Menu_Background";
NSString *const kPG_Colour_Menu_Background_Selected = @"kPG_Colour_Menu_Background_Selected";

NSString *const kPG_Colour_Cell_Title               = @"kPG_Colour_Cell_Title";
NSString *const kPG_Colour_Cell_Subtitle            = @"kPG_Colour_Cell_Subtitle";
NSString *const kPG_Colour_Cell_Title_Not_Set       = @"kPG_Colour_Cell_Title_Not_Set";
NSString *const kPG_Colour_Cell_Subtitle_Not_Set    = @"kPG_Colour_Cell_Subtitle_Not_Set";
NSString *const kPG_Colour_Cell_Background          = @"kPG_Colour_Cell_Background";
NSString *const kPG_Colour_Cell_Selection           = @"kPG_Colour_Cell_Selection";
NSString *const kPG_Colour_Cell_Accessory           = @"kPG_Colour_Cell_Accessory";
NSString *const kPG_Colour_Cell_Divider             = @"kPG_Colour_Cell_Divider";
NSString *const kPG_Colour_Pull_To_Refresh          = @"kPG_Colour_Pull_To_Refresh";
NSString *const kPG_Colour_Location                 = @"kPG_Colour_Location";
NSString *const kPG_Colour_Location_Address         = @"kPG_Colour_LocationAddress";

NSString *const kPG_Colour_Email                    = @"kPG_Colour_Email";
NSString *const kPG_Colour_Tel                      = @"kPG_Colour_Tel";
NSString *const kPG_Colour_Web                      = @"kPG_Colour_Web";

// Twitter
NSString *const kPG_Colour_Twitter_Screenname       = @"kPG_Colour_Twitter_Screenname";
NSString *const kPG_Colour_Twitter_Link             = @"kPG_Colour_Twitter_Link";
NSString *const kPG_Colour_Twitter_Hashtag          = @"kPG_Colour_Twitter_Hashtag";

// Calendar
NSString *const kPG_Colour_Calendar_Header_Title            = @"kPG_Colour_Calendar_Header_Title";
NSString *const kPG_Colour_Calendar_Header_Title_Highlight  = @"kPG_Colour_Calendar_Header_Title_Highlight";
NSString *const kPG_Colour_Calendar_Header_Gradient_Light   = @"kPG_Colour_Calendar_Header_Gradient_Light";
NSString *const kPG_Colour_Calendar_Header_Gradient_Dark    = @"kPG_Colour_Calendar_Header_Gradient_Dark";

NSString *const kPG_Colour_Calendar_Cell_Today              = @"kPG_Colour_Calendar_Cell_Today";
NSString *const kPG_Colour_Calendar_Cell_Today_Unselected   = @"kPG_Colour_Calendar_Cell_Today_Unselected";
NSString *const kPG_Colour_Calendar_Cell_Text               = @"kPG_Colour_Calendar_Cell_Text";
NSString *const kPG_Colour_Calendar_Cell_Selected           = @"kPG_Colour_Calendar_Cell_Selected";
NSString *const kPG_Colour_Calendar_Cell_Border             = @"kPG_Colour_Calendar_Cell_Border";
NSString *const kPG_Colour_Calendar_Cell_Border_Selected    = @"kPG_Colour_Calendar_Cell_Border_Selected";
NSString *const kPG_Colour_Calendar_Cell_Gradient_Light     = @"kPG_Colour_Calendar_Cell_Gradient_Light";
NSString *const kPG_Colour_Calendar_Cell_Gradient_Dark      = @"kPG_Colour_Calendar_Cell_Gradient_Dark";
NSString *const kPG_Colour_Calendar_Cell_Background         = @"kPG_Colour_Calendar_Cell_Background";
NSString *const kPG_Colour_Calendar_Cell_Background_Inactive = @"kPG_Colour_Calendar_Cell_Background_Inactive";
NSString *const kPG_Colour_Calendar_Cell_Background_Inactive_Selected = @"kPG_Colour_Calendar_Cell_Background_Inactive_Selected";

NSString *const kPG_Colour_Image_Border = @"kPG_Colour_Image_Border";
NSString *const kPG_Colour_Image_Overlay = @"kPG_Colour_Image_Border";
NSString *const kPG_Colour_Image_Caption = @"kPG_Colour_Image_Border";

- (instancetype)init {
    
    if ((self = [super init])) {
        
        _colours = [self colours];
    }
    
    return self;
}

- (instancetype)initWithColours:(NSMutableDictionary *)appColours {
    
    
    
    if ((self = self.init)) {
        
        [_colours addEntriesFromDictionary:appColours];
        
    }
    
    
    return self;
}

- (UIColor *)colourForKey:(NSString *)key {
    
    if (_colours == nil
        || _colours[key] == nil) {
        DDLogError(@"colour not found for key: %@", key);
        return [PGColoursManager colourForHex:0x333333];
    }
    
    UIColor *colour = _colours[key];
    return colour;
    
}

- (void)addColour:(UIColor *)colour
           forKey:(NSString *)key {
    DDLogVerbose(@"adding colour for key: %@", key);
    _colours[key] = colour;
}

// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *)colourForHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

- (UIColor *)hex:(int)hex {
    return [PGColoursManager colourForHex:hex];
}

- (NSMutableDictionary *)colours {
    
    NSMutableDictionary *colours = [NSMutableDictionary dictionary];
    
    colours[kPG_Colour_PGVC_Background] = [self hex:0xFFFFFF];
    colours[kPG_Colour_PGVC_Background_Fade] = [self hex:0x999999];
    

    colours[kPG_Colour_HUD_Background] = [self hex:0x212121];
    colours[kPG_Colour_HUD_Background_Warning] = [self hex:0x992121];
    colours[kPG_Colour_HUD] = [self hex:0x313131];
    colours[kPG_Colour_HUD_Title] = [self hex:0xFFFFFF];
    colours[kPG_Colour_HUD_Message] = [self hex:0xCCCCCC];

    colours[kPG_Colour_Alert_Title] = [self hex:0x333333];
    colours[kPG_Colour_Alert_Message] = [self hex:0x66666];
    colours[kPG_Colour_Alert_Message] = [self hex:0xFFFFFF];

    
    colours[kPG_Colour_Nav_Title] = [self hex:0xFFFFFF];
    colours[kPG_Colour_Nav_Tint] = [self hex:0x212121];
    
    colours[kPG_Colour_Menu_Title ] = [self hex:0xFFFFFF];
    colours[kPG_Colour_Menu_Title_Selected] = [self hex:0x99CCCC];
    colours[kPG_Colour_Menu_Background ] = [self hex:0x212121];
    colours[kPG_Colour_Menu_Background_Selected ] = [self hex:0x666666];
    
    colours[kPG_Colour_Cell_Title] = [self hex:0x666666];
    colours[kPG_Colour_Cell_Title_Not_Set] = [self hex:0x666666];
    colours[kPG_Colour_Cell_Subtitle] = [self hex:0x666666];
    colours[kPG_Colour_Cell_Subtitle_Not_Set] = [self hex:0x666666];
    colours[kPG_Colour_Cell_Background] = [UIColor clearColor];
    colours[kPG_Colour_Cell_Selection ] = [self hex:0xCCCCCC];
    colours[kPG_Colour_Cell_Accessory] = [self hex:0x212121];
    colours[kPG_Colour_Cell_Divider] = [self hex:0x666666];
    colours[kPG_Colour_Pull_To_Refresh] = [self hex:0x212121];
    colours[kPG_Colour_Location] = [self hex:0x212121];
    colours[kPG_Colour_Location_Address] = [self hex:0x212121];
    
    colours[kPG_Colour_Email] = [self hex:0x212121];
    colours[kPG_Colour_Tel] = [self hex:0x212121];
    colours[kPG_Colour_Web] = [self hex:0x212121];
    
    colours[kPG_Colour_Twitter_Hashtag] = [self hex:0x990000];
    colours[kPG_Colour_Twitter_Link] = [self hex:0x990000];
    colours[kPG_Colour_Twitter_Screenname] = [self hex:0x990000];
    
    colours[kPG_Colour_Calendar_Header_Title] = [self hex:0x414141];
    colours[kPG_Colour_Calendar_Header_Title_Highlight] = [self hex:0x212121];
    colours[kPG_Colour_Calendar_Header_Gradient_Light] = [self hex:0xf4f4f5];
    colours[kPG_Colour_Calendar_Header_Gradient_Dark] = [self hex:0xccccd1];
    
    colours[kPG_Colour_Calendar_Cell_Today] = [self hex:0x333333];
    colours[kPG_Colour_Calendar_Cell_Today_Unselected] = [self hex:0x999999];
    colours[kPG_Colour_Calendar_Cell_Text] = [self hex:0x33333];
    colours[kPG_Colour_Calendar_Cell_Selected] = [self hex:0x666666];
    colours[kPG_Colour_Calendar_Cell_Border] = [self hex:0x9da0a9];
    colours[kPG_Colour_Calendar_Cell_Border_Selected] = [self hex:0x293649];
    colours[kPG_Colour_Calendar_Cell_Gradient_Light] = [self hex:0xe2e2e4];
    colours[kPG_Colour_Calendar_Cell_Gradient_Dark] = [self hex:0xccbd0];
    colours[kPG_Colour_Calendar_Cell_Background] = [self hex:0xCCCCCC];
    colours[kPG_Colour_Calendar_Cell_Background_Inactive] = [self hex:0xCCCCCC];
    colours[kPG_Colour_Calendar_Cell_Background_Inactive_Selected] = [self hex:0xAAAAAA];

    colours[kPG_Colour_Image_Border] = [self hex:0xCCCCCC];
    colours[kPG_Colour_Image_Caption] = [self hex:0x666666];
    colours[kPG_Colour_Image_Overlay] = [self hex:0xAAAAAA];
    
    return colours;
}

+ (UIColor *)colorForHexString:(NSString *)hexString {
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"
                                                                  withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
            
        default:
            
            [NSException raise:@"Invalid color value"
                        format: @"Color value %@ is invalid.  It should be a hex value of the form "
                                @"#RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *)string
                         start:(NSUInteger)start
                        length:(NSUInteger)length {
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
    
}

@end
