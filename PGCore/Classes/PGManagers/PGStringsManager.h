//
//  PGStringsManager.h
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"

@interface PGStringsManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *langs;

#pragma mark - Default Strings

extern NSString *const kPG_PullToRefresh;
extern NSString *const kPG_String_Map;
extern NSString *const kPG_String_RetweetedBy;
extern NSString *const kPG_String_Reply;
extern NSString *const kPG_String_Search_Twitter;
extern NSString *const kPG_String_Reply_Sent;
extern NSString *const kPG_String_Modified;
extern NSString *const kPG_String_User_Calendar;

- (void)setupLangs;
- (void)updateStrings:(NSArray *)strings;

- (NSString *)stringForKey:(NSString *)key
                  inLocale:(NSString *)locale;

- (NSMutableDictionary *)en_strings; // Default strings
- (NSMutableDictionary *)ga_strings; // Default strings

# pragma mark - Time

- (NSString *)time:(NSDate *)date;
- (NSString *)rangeFromTime:(NSString *)start
                     toTime:(NSString *)end;

#pragma mark - Day
- (NSString *)shortDay:(NSUInteger)day;

- (NSArray *)shortDays;

- (NSString *)prettyShortTimeDate:(NSDate *)date;
- (NSString *)prettyTimeDayMonth:(NSDate *)date;

#pragma mark - Date
- (NSString *)timeDayMonth:(NSDate *)date;
- (NSString *)dayMonth:(NSDate *)date;
- (NSString *)numericalTimeDate:(NSDate *)date;
- (NSString *)numericalDate:(NSDate *)date;
- (NSString *)month:(NSUInteger)month;
- (NSString *)monthYear:(NSDate *)date;
- (NSString *)prettyDateRangeFrom:(NSDate *)dateStart
                               to:(NSDate *)dateEnd;

#pragma mark - Distance in time
- (NSString *)distanceOfTimeInWords:(NSDate *)date;
- (NSString *)twitterTimeSince:(NSDate *)date;


@end
