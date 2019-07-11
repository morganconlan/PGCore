//
//  PGStringsManager.m
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGStringsManager.h"
#import "NSDate+Extras.h"

#define SECONDS_PER_MINUTE 60.0
#define SECONDS_PER_HOUR   3600.0
#define SECONDS_PER_DAY    86400.0
#define SECONDS_PER_MONTH  2592000.0
#define SECONDS_PER_YEAR   31536000.0

@implementation PGStringsManager

- (instancetype)init {
    
    if ((self = [super init])) {
        
        if (PGApp.app.configs == nil)
            [NSException raise:@"Invalid state"
                        format:@"Configs must be loaded before strings."];
        
    }
    
    return self;
}

NSString *const kPG_PullToRefresh = @"String_PullToRefresh";
NSString *const kPG_String_Map = @"String_Map";
NSString *const kPG_String_RetweetedBy = @"String_RetweetedBy";
NSString *const kPG_String_Reply = @"String_Reply";
NSString *const kPG_String_Search_Twitter = @"String_Search_Twitter";
NSString *const kPG_String_Reply_Sent = @"String_Reply_Sent";
NSString *const kPG_String_Modified = @"String_Modified";
NSString *const kPG_String_User_Calendar = @"String_User_Calendar";


- (NSString *)stringForKey:(NSString *)key
                  inLocale:(NSString *)locale {

    if (_langs[locale] == nil) { // locale not found

        if (PGApp.app.configs.isDebuggingStrings)
            DDLogWarn(@"locale: %@ not found.", locale);

        return key;

    }

    if (_langs[locale][key] != nil) return _langs[locale][key];

    // Key not found
    if (PGApp.app.configs.isDebuggingStrings)
        DDLogWarn(@"key: %@ not found in local: %@", key, locale);

    return key;

}

// Must be called from sub class
- (void)setupLangs {
    
    DDLogInfo(@"super");
    
    _langs = [NSMutableDictionary dictionary];
    
    for (NSString *lang in PGApp.app.configs.supportedLangs) {
        
        SEL load_lang_selector = NSSelectorFromString([NSString stringWithFormat:@"loadLang_%@", lang]);
        
        if ([self respondsToSelector:load_lang_selector]) {
        
            [self performSelector:load_lang_selector];
        
        } else {
            
            [NSException raise:@"Invalid language"
                        format:@"Language '%@' is not supported. Please implement loadLang_%@",
                                lang, lang];
        }
        
    }
    
}

- (NSMutableDictionary *)en_strings {
    
    DDLogWarn(@"en_strings");
    
    NSMutableDictionary *en_strings = [NSMutableDictionary dictionary];
    // Time
    en_strings[kPG_Time_Ago] = @"ago";
    en_strings[kPG_Time_FromNow] = @"from now";
    en_strings[kPG_Time_LessThan] = @"less than";
    en_strings[kPG_Time_About] = @"about";
    en_strings[kPG_Time_Over] = @"over";
    en_strings[kPG_Time_Almost] = @"almost";
    en_strings[kPG_Time_Seconds] = @"seconds";
    en_strings[kPG_Time_Minute] = @"minute";
    en_strings[kPG_Time_Minutes] = @"minutes";
    en_strings[kPG_Time_Hour] = @"hour";
    en_strings[kPG_Time_Hours] = @"hours";
    en_strings[kPG_Time_Day] = @"day";
    en_strings[kPG_Time_Days] = @"days";
    en_strings[kPG_Time_Month] = @"month";
    en_strings[kPG_Time_Months] = @"months";
    en_strings[kPG_Time_Year] = @"year";
    en_strings[kPG_Time_Years] = @"years";
    en_strings[kPG_IsAllDay] = @"All day";
    // HUD
    en_strings[kPG_HUD_ConnectingTwitter] = @"Connecting";
    en_strings[kPG_HUD_ConnectingTwitterFailed] = @"Failed to connect";
    en_strings[kPG_HUD_ConnectingFacebook] = @"Connecting";
    en_strings[kPG_HUD_ConnectingFacebookFailed] = @"Failed to connect";
    en_strings[kPG_HUD_ConnectingServer] = @"Connecting";
    en_strings[kPG_HUD_ConnectingServerFailed] = @"Failed to connect";
    en_strings[kPG_HUD_ConfirmCancel] = @"Cancel?";
    en_strings[kPG_HUD_Searching] = @"Searching...";
    en_strings[kPG_HUD_SearchingLocation] = @"";
    en_strings[kPG_HUD_LocationError] = @"";
    en_strings[kPG_HUD_LocationFound] = @"";
    en_strings[kPG_HUD_LocationNoneNearby] = @"No locations found nearby";
    en_strings[kPG_HUD_NotAuthorised] = @"Not authorised";
    // Alert
    en_strings[kPG_ALERT_CallNumber] = @"Call number";
    en_strings[kPG_ALERT_Call] = @"Call";
    en_strings[kPG_ALERT_DeviceNotSupported] = @"Device does not support this feature";
    en_strings[kPG_ALERT_Cancel] = @"Cancel";
    en_strings[kPG_ALERT_Cancelled] = @"Cancelled";
    en_strings[kPG_ALERT_Thank_You] = @"Thank you";
    en_strings[kPG_ALERT_Saved] = @"Saved";
    en_strings[kPG_ALERT_Email_Cancelled] = @"Email cancelled";
    en_strings[kPG_ALERT_Email_Saved] = @"Email saved";
    en_strings[kPG_ALERT_Email_Sent] = @"Email sent";
    en_strings[kPG_ALERT_Email_Send_Fail] = @"Email send failed";
    en_strings[kPG_ALERT_Error] = @"Error";
    en_strings[kPG_ALERT_Error_Server] = @"Server error";
    en_strings[kPG_ALERT_LeaveApp] = @"Leave app?";
    en_strings[kPG_ALERT_ConfirmDirections] = @"Get directions to:";
    en_strings[kPG_ALERT_LocationPermission] = @"Location permissions are required";
    en_strings[kPG_ALERT_NoWifi] = @"No WiFi available";
    en_strings[kPG_ALERT_NoWifi_Info] = @"";
    en_strings[kPG_ALERT_NoTwitter] = @"No Twitter account found";
    en_strings[kPG_ALERT_NoTwitterInstructions] = @"Please sign in using the settings app";
    // Searchbar
    en_strings[kPG_SEARCHBAR_Search] = @"Search";
    en_strings[kPG_SEARCHBAR_Done] = @"Done";
    // Pull
    en_strings[kPG_PullToRefresh] = @"Pull to refresh";
    // Map
    en_strings[kPG_String_Map] = @"Map";
    // Twitter
    en_strings[kPG_String_RetweetedBy] = @"Retweeted by";
    en_strings[kPG_String_Reply] = @"Reply";
    en_strings[kPG_String_Search_Twitter] = @"Search Twitter";
    en_strings[kPG_String_Reply_Sent] = @"Reply sent!";
    //
    en_strings[kPG_String_Modified] = @"Updated: ";
    //
    en_strings[kPG_String_User_Calendar] = @"Calendar";
    
    NSUserDefaults *en_defaults = [NSUserDefaults standardUserDefaults];
    [en_defaults setObject:en_strings forKey:@"en"];
    [en_defaults synchronize];
    
    return en_strings;
}

- (NSMutableDictionary *)ga_strings {
    
    DDLogWarn(@"ga_strings");
    
    NSMutableDictionary *ga_strings = [NSMutableDictionary dictionary];
    // Time
    ga_strings[kPG_Time_Ago] = @"ó shin";
    ga_strings[kPG_Time_FromNow] = @"i gceann";
    ga_strings[kPG_Time_LessThan] = @"níos lú ná";
    ga_strings[kPG_Time_About] = @"";
    ga_strings[kPG_Time_Over] = @"";
    ga_strings[kPG_Time_Almost] = @"";
    ga_strings[kPG_Time_Seconds] = @"s";
    ga_strings[kPG_Time_Minute] = @"nm";
    ga_strings[kPG_Time_Minutes] = @"nm";
    ga_strings[kPG_Time_Hour] = @"u";
    ga_strings[kPG_Time_Hours] = @"u";
    ga_strings[kPG_Time_Day] = @"lá";
    ga_strings[kPG_Time_Days] = @"lá";
    ga_strings[kPG_Time_Month] = @"mí";
    ga_strings[kPG_Time_Months] = @"mhí";
    ga_strings[kPG_Time_Year] = @"bliain";
    ga_strings[kPG_Time_Years] = @"bliain";
    ga_strings[kPG_IsAllDay] = @"An lá ar fad";
    // HUD
    ga_strings[kPG_HUD_ConnectingTwitter] = @"Ag ceangailt le Twitter";
    ga_strings[kPG_HUD_ConnectingTwitterFailed] = @"Fadhb ceangailt le Twitter";
    ga_strings[kPG_HUD_ConnectingFacebook] = @"Ag ceangailt le Facebook";
    ga_strings[kPG_HUD_ConnectingFacebookFailed] = @"Fadhb ceangailt le Facebook";
    ga_strings[kPG_HUD_ConnectingServer] = @"Ag lorg an\nt-eolas is deireanaí";
    ga_strings[kPG_HUD_ConnectingServerFailed] = @"Fadhb ceangailt leis an freastalaí";
    ga_strings[kPG_HUD_ConfirmCancel] = @"Cealaigh?";
    ga_strings[kPG_HUD_Searching] = @"Ag Cuardach";
    ga_strings[kPG_HUD_SearchingLocation] = @"Ag lorg an bunsuíomh";
    ga_strings[kPG_HUD_LocationError] = @"Fadhb ag aimsiú an bunsuíomh";
    ga_strings[kPG_HUD_LocationFound] = @"Bunsuíomh aimsithe";
    ga_strings[kPG_HUD_LocationNoneNearby] = @"Níl aon imeachtaí gar dhuit";
    // Alert
    ga_strings[kPG_ALERT_CallNumber] = @"";
    ga_strings[kPG_ALERT_Call] = @"Glaoigh";
    ga_strings[kPG_ALERT_DeviceNotSupported] = @"Níl tacaíocht ag do ghléas leis an gné seo";
    ga_strings[kPG_ALERT_Cancel] = @"Cealaigh";
    ga_strings[kPG_ALERT_Cancelled] = @"Cealaíthe";
    ga_strings[kPG_ALERT_Thank_You] = @"Go raibh maith agat";
    ga_strings[kPG_ALERT_Saved] = @"Sábháilte";
    ga_strings[kPG_ALERT_Email_Cancelled] = @"RPhost ceallaíthe";
    ga_strings[kPG_ALERT_Email_Saved] = @"RPhose sábháilte";
    ga_strings[kPG_ALERT_Email_Sent] = @"RPhost seólta";
    ga_strings[kPG_ALERT_Email_Send_Fail] = @"Faidhb ag seóladh";
    ga_strings[kPG_ALERT_Error] = @"Fadhb";
    ga_strings[kPG_ALERT_Error_Server] = @"Fadhb ceangal";
    ga_strings[kPG_ALERT_LeaveApp] = @"Scoir ón aip?";
    ga_strings[kPG_ALERT_ConfirmDirections] = @"Treoracha go dtí ";
    ga_strings[kPG_ALERT_LocationPermission] = @"Tá do chead ag taisteáil chun do shuímh a aimsiú.\nCumasaigh é san clár ardsocruithe";
    ga_strings[kPG_ALERT_NoWifi] = @"Níl Wifi ar fáil";
    ga_strings[kPG_ALERT_NoWifi_Info] = @"Lean ar aghaidh?";
    // Map
    ga_strings[kPG_String_Map] = @"Léarscáil";
    // Searchbar
    ga_strings[kPG_SEARCHBAR_Search] = @"Cuardach";
    ga_strings[kPG_SEARCHBAR_Done] = @"Déanta";
    // Twitter
    ga_strings[kPG_String_Reply] = @"Freagair";
    ga_strings[kPG_String_Search_Twitter] = @"Cuardaigh Twitter";
    ga_strings[kPG_String_Reply_Sent] = @"Freagra seólta!";
    //
    ga_strings[kPG_String_Modified] = @"Nuashonraithe";
    //
    ga_strings[kPG_String_User_Calendar] = @"Calendar";
    
    NSUserDefaults *ga_defaults = [NSUserDefaults standardUserDefaults];
    [ga_defaults setObject:ga_strings forKey:@"ga"];
    [ga_defaults synchronize];
    
    return ga_strings;
}

- (void)updateStrings:(NSArray *)strings {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *langs = [defaults objectForKey:@"langs"];
    NSMutableDictionary *mutableLangs = [NSMutableDictionary dictionary];
    
    for (NSString* key in langs.allKeys) { //make mutable copy of each lang dictionary
        mutableLangs[key] = [langs[key] mutableCopy];
    }
    
    for (NSDictionary *string in strings) {
        
        // if string's language isn't set or doesn't exist in supported langs ignore it
        if (string[@"lang"] == nil
            || string[@"key"] == nil
            || string[@"value"] == nil
            || langs[string[@"lang"]] == nil) continue;
        
        mutableLangs[string[@"lang"]][string[@"key"]] = string[@"value"];
        
    }
    
    
    [defaults setObject:mutableLangs forKey:@"langs"];
    [defaults synchronize];
    
    self.langs = mutableLangs;
}



#pragma mark - Time

- (NSString *)time:(NSDate *)date {
    
    NSString *hourStart = [NSString stringWithFormat:@"%@%ld",
                           ([date hour] < 10) ? @"0" : @"",
                           (long)[date hour]];
    
    NSString *minuteStart = [NSString stringWithFormat:@"%@%ld",
                             ([date minute] < 10) ? @"0" : @"",
                             (long)[date minute]];
    
    return [NSString stringWithFormat:@"%@h%@",
            hourStart,
            minuteStart];
    
}

- (NSString *)rangeFromTime:(NSString *)start
                     toTime:(NSString *)end {
    
    if (start.length == 0
        && end.length == 0) return nil;
    
    if (end == nil
        || [end isEqualToString:start]) end = @"";
    
    NSString *divider = (end.length > 0
                         && ![start isEqualToString:end]) ? @" - " : @"";
    
    if (start.length > 5) start = [start substringToIndex:5];
    if (end.length > 5) end = [end substringToIndex:5];
    
    if ([start isEqualToString:@"00:00"]) return [PGApp.app string:kPG_IsAllDay];
    
    return [NSString stringWithFormat:@"%@%@%@",
            start, divider, end];
    
}

#pragma mark - Days

- (NSString *)day:(NSUInteger)day {
    
    return [self days][day];
    
}

- (NSArray *)days {
    
    NSDictionary *days = @{@"ga": @[@"",
                                    @"Dé Domhnaigh",
                                    @"Dé Luain",
                                    @"Dé Máirt",
                                    @"Dé Céadaoin",
                                    @"Déardaoin",
                                    @"Dé hAoine",
                                    @"Dé Sathairn"],
                           
                           @"en": @[@"",
                                    @"Sunday",
                                    @"Monday",
                                    @"Tuesday",
                                    @"Wednesday",
                                    @"Thursday",
                                    @"Friday",
                                    @"Saturday"]};
    
    return days[PGApp.app.locale];
    
}

- (NSString *)shortDay:(NSUInteger)day {
    
    return [self shortDays][day];
    
}

- (NSArray *)shortDays {
    
    NSDictionary *days = @{
                           
                           @"ga":@[@"",
                                   @"Domh",
                                   @"Luan",
                                   @"Máir",
                                   @"Céad",
                                   @"Déar",
                                   @"Aoin",
                                   @"Sath"],
                           
                           @"en":@[@"",
                                   @"Sun",
                                   @"Mon",
                                   @"Tue",
                                   @"Wed",
                                   @"Thu",
                                   @"Fri",
                                   @"Sat"]};
    
    return days[PGApp.app.locale];
    
}

#pragma mark - Date

- (NSString *)prettyShortTimeDate:(NSDate *)date {
    
    return nil;
    
}

- (NSString *)prettyTimeDayMonth:(NSDate *)date {
    
    return nil;
    
}

- (NSString *)prettyDateRangeFrom:(NSDate *)dateStart
                               to:(NSDate *)dateEnd {
    
    if ([dateStart isSameDate:dateEnd]
        || dateEnd == nil)
        return [self dayMonth:dateStart];
    
    if (dateStart.year != dateEnd.year) {
            
            return [NSString stringWithFormat:@"%@ %ld %@ %ld\n%@ %ld %@, %ld",
                    //start
                    [self shortDay:(NSUInteger)[dateStart weekday]],
                    (long)[dateStart day],
                    [self month:(NSUInteger)[dateStart month]],
                    (long)[dateStart year],
                    //end
                    [self shortDay:(NSUInteger)[dateEnd weekday]],
                    (long)[dateEnd day],
                    [self month:(NSUInteger)[dateEnd month]],
                    (long)[dateEnd year]];
        
    } else {
        
        if (dateStart.month != dateEnd.month) {
            
            return [NSString stringWithFormat:@"%@ %ld %@ - %@ %ld %@, %ld",
                    //start
                    [self shortDay:(NSUInteger)[dateStart weekday]],
                    (long)[dateStart day],
                    [self month:(NSUInteger)[dateStart month]],
                    //end
                    [self shortDay:(NSUInteger)[dateEnd weekday]],
                    (long)[dateEnd day],
                    [self month:(NSUInteger)[dateEnd month]],
                    (long)[dateStart year]];
            
        }
        
    }
    
    return [NSString stringWithFormat:@"%@ %ld - %@ %ld %@, %ld",
            //start
            [self shortDay:(NSUInteger)[dateStart weekday]],
            (long)[dateStart day],
            //end
            [self shortDay:(NSUInteger)[dateEnd weekday]],
            (long)[dateEnd day],
            [self month:(NSUInteger)[dateEnd month]],
            (long)[dateStart year]];
    
}

- (NSString *)timeDayMonth:(NSDate *)date {
    
    NSString *month = [self month:(NSUInteger)[date month]];
    return [NSString stringWithFormat:@"%@, %@ %ld %@, %ld",
            [self time:date],
            [self shortDay:(NSUInteger)[date weekday]],
            (long)[date day],
            month,
            (long)[date year]];
    
}

- (NSString *)dayMonth:(NSDate *)date {
    
    NSString *day = [self day:(NSUInteger)[date weekday]];
    NSString *month = [self month:(NSUInteger)[date month]];
    return [NSString stringWithFormat:@"%@ %ld %@, %ld",
            day,
            (long)[date day],
            month,
            (long)[date year]];
    
}

- (NSString *)numericalTimeDate:(NSDate *)date {
    
//    NSString *month = [self month:(NSUInteger)[date month]];
    
    return [NSString stringWithFormat:@"%0*ldh%0*ld - %@",
            2, // padding
            (long)[date hour],
            2, // padding
            (long)[date minute],
            [self numericalDate:date]];
    
}

- (NSString *)numericalDate:(NSDate *)date {
    
    NSString *month = [self month:(NSUInteger)[date month]];
    
    return [NSString stringWithFormat:@"%ld %@, %ld",
            (long)[date day],
            month,
            (long)[date year]];
    
}

- (NSString *)monthYear:(NSDate *)date {
    
    return [NSString stringWithFormat:@"%@, %ld",
            [self month:(NSUInteger)[date month]],
            (long)[date year]];
    
}

#pragma mark - Month

- (NSString *)month:(NSUInteger)month {
    
    NSDictionary *months = @{@"ga": @[  @"",
                                        @"Eanáir",
                                        @"Feabhra",
                                        @"Márta",
                                        @"Aibreán",
                                        @"Bealtaine",
                                        @"Meitheamh",
                                        @"Iúil",
                                        @"Lúnasa",
                                        @"Meán Fómhair",
                                        @"Deireadh Fómhair",
                                        @"Samhain",
                                        @"Nollaig"],
                             
                             @"en":@[  @"",
                                       @"January",
                                       @"February",
                                       @"March",
                                       @"April",
                                       @"May",
                                       @"June",
                                       @"July",
                                       @"August",
                                       @"September",
                                       @"October",
                                       @"November",
                                       @"December"]};
    
    return months[PGApp.app.locale][month];
}

- (NSString *)distanceOfTimeInWords:(NSDate *)date {
    
    NSString *Ago      = [PGApp.app string:kPG_Time_Ago];
    NSString *FromNow  = [PGApp.app string:kPG_Time_FromNow];
    NSString *LessThan = [PGApp.app string:kPG_Time_LessThan];
    NSString *About    = [PGApp.app string:kPG_Time_About];
    NSString *Over     = [PGApp.app string:kPG_Time_Over];
    NSString *Almost   = [PGApp.app string:kPG_Time_Almost];
    NSString *Seconds  = [PGApp.app string:kPG_Time_Seconds];
    NSString *Minute   = [PGApp.app string:kPG_Time_Minute];
    NSString *Minutes  = [PGApp.app string:kPG_Time_Minutes];
    NSString *Hour     = [PGApp.app string:kPG_Time_Hour];
    NSString *Hours    = [PGApp.app string:kPG_Time_Hours];
    NSString *Day      = [PGApp.app string:kPG_Time_Day];
    NSString *Days     = [PGApp.app string:kPG_Time_Days];
    NSString *Month    = [PGApp.app string:kPG_Time_Month];
    NSString *Months   = [PGApp.app string:kPG_Time_Months];
    NSString *Year     = [PGApp.app string:kPG_Time_Year];
    NSString *Years    = [PGApp.app string:kPG_Time_Years];
    
    NSTimeInterval since = [date timeIntervalSinceDate:[NSDate date]];
    NSString *direction = since <= 0.0 ? Ago : FromNow;
    since = fabs(since);
    
    int seconds   = (int)since;
    int minutes   = (int)round(since / SECONDS_PER_MINUTE);
    int hours     = (int)round(since / SECONDS_PER_HOUR);
    int days      = (int)round(since / SECONDS_PER_DAY);
    int months    = (int)round(since / SECONDS_PER_MONTH);
    int years     = (int)floor(since / SECONDS_PER_YEAR);
    int offset    = (int)round(floor((float)years / 4.0) * 1440.0);
    int remainder = (minutes - offset) % 525600;
    
    int number;
    NSString *measure;
    NSString *modifier = @"";
    
    switch (minutes) {
        case 0 ... 1:
            measure = Seconds;
            switch (seconds) {
                case 0 ... 4:
                    number = 5;
                    modifier = LessThan;
                    break;
                case 5 ... 9:
                    number = 10;
                    modifier = LessThan;
                    break;
                case 10 ... 19:
                    number = 20;
                    modifier = LessThan;
                    break;
                case 20 ... 39:
                    number = 30;
                    modifier = About;
                    break;
                case 40 ... 59:
                    number = 1;
                    measure = Minute;
                    modifier = LessThan;
                    break;
                default:
                    number = 1;
                    measure = Minute;
                    modifier = About;
                    break;
            }
            break;
        case 2 ... 44:
            number = minutes;
            measure = Minutes;
            break;
        case 45 ... 89:
            number = 1;
            measure = Hour;
            modifier = About;
            break;
        case 90 ... 1439:
            number = hours;
            measure = Hours;
            modifier = About;
            break;
        case 1440 ... 2529:
            number = 1;
            measure = Day;
            break;
        case 2530 ... 43199:
            number = days;
            measure = Days;
            break;
        case 43200 ... 86399:
            number = 1;
            measure = Month;
            modifier = About;
            break;
        case 86400 ... 525599:
            number = months;
            measure = Months;
            break;
        default:
            number = years;
            measure = number == 1 ? Year : Years;
            if (remainder < 131400) {
                modifier = About;
            } else if (remainder < 394200) {
                modifier = Over;
            } else {
                ++number;
                measure = Years;
                modifier = Almost;
            }
            break;
    }
    if ([modifier length] > 0) {
        modifier = [modifier stringByAppendingString:@" "];
    }
    return [NSString stringWithFormat:@"%@%d %@ %@", modifier, number, measure, direction];
}

- (NSString *)twitterTimeSince:(NSDate *)date {
    
    return [self distanceOfTimeInWords:date];
    
}

@end
