//
//  NSDate+Extras.h
//  pgcore
//
//  Created by Morgan Conlan on 12/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSecondsMinute      60
#define kSecondsHour		3600
#define kSecondsDay         86400
#define kSecondsWeek		604800
#define kSecondsYear		31556926

@interface NSDate (Extras)

#pragma mark Comparing dates

- (BOOL)isEarlierDate:(NSDate *)aDate;
- (BOOL)isLaterDate:(NSDate *)aDate;
- (BOOL)dateBetweenStartDate:(NSDate*)start andEndDate:(NSDate*)end;
- (BOOL)isSameDate:(NSDate *)aDate;

#pragma mark Date formatting

- (NSString*)localeFormattedDateString;
- (NSString*)localeFormattedDateStringWithTime;
+ (NSDate *)localeFormatted;
- (NSDate *)dateFormattedLocale;

- (NSString *)formattedStringWithFormat:(NSString *)format;
- (NSDate *)dateWithoutTime;
+ (NSDate *)dateWithoutTime;

#pragma mark SQLite formatting

- (NSDate *)dateForSqlite;
+ (NSDate*)dateFromSQLString:(NSString*)dateStr;

#pragma mark Beginning and end of date components

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfMonth;
- (NSDate *)beginningOfYear;
- (NSDate *)endOfWeek;
- (NSDate *)endOfMonth;
- (NSDate *)endOfYear;

#pragma mark Date math

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;

- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes;

- (NSDate *)dateByAddingHours:(NSInteger)hours;

- (NSDate *)dateBySubtractingHours:(NSInteger)hours;

- (NSDate *)dateByAddingDays:(NSInteger)days;

- (NSDate *)dateBySubtractingDays:(NSInteger)days;

- (NSDate *)dateByAddingMonth:(int)monthes;

- (NSDate *)dateBySubstractingMonth:(int)monthes;

- (NSDate *)dateByAddingTimeString:(NSString *)time;

#pragma mark Date components

- (NSInteger)seconds;
- (NSInteger)minute;
- (NSInteger)hour;
- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)week;
- (NSInteger)weekday;
- (NSInteger)year;
- (NSString*)monthName;
- (NSString*)yearFromDateStr;

#pragma mark - Date Utilities

+ (NSCalendar *) currentCalendar; // avoid bottlenecks

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

- (NSDate *)addTimeString:(NSString *)time;

// Short string utilities
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) stringWithFormat: (NSString *) format;
@property (nonatomic, readonly) NSString *shortString;
@property (nonatomic, readonly) NSString *shortDateString;
@property (nonatomic, readonly) NSString *shortTimeString;
@property (nonatomic, readonly) NSString *mediumString;
@property (nonatomic, readonly) NSString *mediumDateString;
@property (nonatomic, readonly) NSString *mediumTimeString;
@property (nonatomic, readonly) NSString *longString;
@property (nonatomic, readonly) NSString *longDateString;
@property (nonatomic, readonly) NSString *longTimeString;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;

- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;

- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isNextMonth;
- (BOOL) isLastMonth;

- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;

- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingYears: (NSInteger) dYears;
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;

// Date extremes
- (NSDate *) dateAtStartOfDay;
- (NSDate *) dateAtEndOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

@end
