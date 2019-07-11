//
//  NSDate+Extras.m
//  pgcore
//
//  Created by Morgan Conlan on 12/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "NSDate+Extras.h"

@implementation NSDate (Extras)

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);

#pragma mark
#pragma mark - Date Utilities
#pragma mark

// Courtesy of Lukasz Margielewski
// Updated via Holger Haenisch
+ (NSCalendar *)currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

#pragma mark - Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
	return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
	return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kSecondsHour * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - kSecondsHour * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kSecondsMinute * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - kSecondsMinute * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

#pragma mark - String Properties
- (NSString *) stringWithFormat: (NSString *) format
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [formatter stringFromDate:self];
}

- (NSString *) shortString
{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) shortTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) shortDateString
{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) mediumString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) mediumTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) mediumDateString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) longString
{
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) longTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) longDateString
{
    return [self stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSDate *)addTimeString:(NSString *)time {
    
    NSInteger *hours = [[time substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger *mins = [[time substringWithRange:NSMakeRange(3, 2)] integerValue];
    
    return [[self dateByAddingHours:hours] dateByAddingMinutes:mins];
}

#pragma mark - Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) &&
			(components1.day == components2.day));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (components1.week != components2.week) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (abs([self timeIntervalSinceDate:aDate]) < kSecondsWeek);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kSecondsWeek;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - kSecondsWeek;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

// Thanks Marcin Krzyzanowski, also for adding/subtracting years and months
- (BOOL) isLastMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

- (BOOL) isNextMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
	return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
	
	return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
	
	return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark - Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [[NSDate currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate *) dateByAddingYears: (NSInteger) dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingYears: (NSInteger) dYears
{
    return [self dateByAddingYears:-dYears];
}

- (NSDate *) dateByAddingMonths: (NSInteger) dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths
{
    return [self dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + kSecondsHour * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + kSecondsMinute * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *)dateByAddingTimeString:(NSString *)time {
    
    NSString *timeString = [time substringToIndex:5]; // trim seconds
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSInteger hours = [[formatter numberFromString:[timeString substringToIndex:2]] integerValue];
    NSInteger minutes = [[formatter numberFromString:[timeString substringFromIndex:3]] integerValue];
    
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	components.hour = hours;
	components.minute = minutes;
	components.second = 0;
    
	return [[NSDate currentCalendar] dateFromComponents:components];
    
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark - Extremes

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	components.hour = 0;
	components.minute = 0;
	components.second = 0;
	return [[NSDate currentCalendar] dateFromComponents:components];
}

// Thanks gsempe & mteece
- (NSDate *) dateAtEndOfDay
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	components.hour = 23; // Thanks Aleksey Kononov
	components.minute = 59;
	components.second = 59;
	return [[NSDate currentCalendar] dateFromComponents:components];
}

#pragma mark - Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / kSecondsMinute);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / kSecondsMinute);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / kSecondsHour);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / kSecondsHour);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / kSecondsDay);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / kSecondsDay);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark - Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kSecondsMinute * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [[NSDate currentCalendar] components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSInteger) hour
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.hour;
}

- (NSInteger) minute
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.minute;
}

- (NSInteger) seconds
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.second;
}

- (NSInteger) day
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.day;
}

- (NSInteger) month
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.month;
}

- (NSInteger) week
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.week;
}

- (NSInteger) weekday
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.weekdayOrdinal;
}

- (NSInteger) year
{
	NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
	return components.year;
}

#pragma mark -
#pragma mark Comparing dates

- (BOOL)isEarlierDate: (NSDate *) aDate
{
	return ([[self earlierDate:aDate] isEqualToDate:self]);
}

- (BOOL)isLaterDate: (NSDate *) aDate
{
	return ([[self laterDate:aDate] isEqualToDate:self]);
}

- (BOOL)dateBetweenStartDate:(NSDate*)start andEndDate:(NSDate*)end {
    
    BOOL isEarlier = [self isLaterDate:start];
    BOOL isLater = [self isEarlierDate:end];
    
    if (isLater && isEarlier) {
        return YES;
    } else
        return NO;
}

- (BOOL)isSameDate:(NSDate *)aDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:aDate];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

#pragma mark -
#pragma mark Date formatting

- (NSString*)localeFormattedDateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *ret = [formatter stringFromDate:self];
    
    return ret;
}

- (NSString*)localeFormattedDateStringWithTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    [formatter setLocale:[NSLocale currentLocale]];
    //   [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

+ (NSDate *)localeFormatted {
    
    return [[NSDate date] dateFormattedLocale];
}

- (NSDate *)dateFormattedLocale {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString *ret = [formatter stringFromDate:self];
    
    return [formatter dateFromString:ret];
}


- (NSString *)formattedStringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *ret = [formatter stringFromDate:self];
    
    return ret;
}

- (NSDate *)dateWithoutTime
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *ret = [formatter stringFromDate:self];
    
    return [formatter dateFromString:ret];
}

+ (NSDate *)dateWithoutTime
{
    return [[NSDate date] dateWithoutTime];
}


#pragma mark -
#pragma mark SQLite formatting

- (NSDate *) dateForSqlite {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *ret = [formatter stringFromDate:self];
    
    NSDate *date = [formatter dateFromString:ret];
    
    return date;
}

+ (NSDate*) dateFromSQLString:(NSString*)dateStr {
    
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *date = [dateForm dateFromString:dateStr];
    return date;
}


#pragma mark -
#pragma mark Beginning and end of date components

- (NSDate *)beginningOfWeek {
    
    NSDate *beginningOfWeek = nil;
	BOOL ok = [[NSDate currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
                                interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	}
    
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [[NSDate currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.) */
    
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] + 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [[NSDate currentCalendar] dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                    fromDate:beginningOfWeek];
	return [[NSDate currentCalendar] dateFromComponents:components];
    
}

- (NSDate *)beginningOfMonth {
    
    NSDateComponents *comps = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [comps setDay:1];
    
    return [[NSDate currentCalendar] dateFromComponents:comps];
    
}

- (NSDate *)beginningOfYear {
    
    NSDateComponents *comps = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [comps setDay:1];
    [comps setMonth:1];
    
    return [[NSDate currentCalendar] dateFromComponents:comps];
    
}

- (NSDate *)endOfWeek {
	NSDateComponents *weekdayComponents = [[NSDate currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setDay:(8 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [[NSDate currentCalendar] dateByAddingComponents:componentsToAdd toDate:self options:0];
    
	return endOfWeek;
}

- (NSDate *)endOfMonth {
    
    NSRange daysRange = [[NSDate currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    
    NSDateComponents *components = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [components setDay:daysRange.length];
    
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSDate *)endOfYear {
    
    NSUInteger days = 0;
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSUInteger months = [[NSDate currentCalendar] rangeOfUnit:NSCalendarUnitMonth
                                            inUnit:NSCalendarUnitYear
                                           forDate:self].length;
    for (int i = 1; i <= months; i++) {
        components.month = i;
        NSDate *month = [[NSDate currentCalendar] dateFromComponents:components];
        days += [[NSDate currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                    inUnit:NSCalendarUnitMonth
                                   forDate:month].length;
    }
    
    NSDateComponents *comps = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];;
    
    [comps setMonth:12];
    
    return [[[NSDate currentCalendar] dateFromComponents:comps] endOfMonth];
}

#pragma mark -
#pragma mark Date math


- (NSDate*) dateByAddingMonth:(int)monthes
{
    NSDateComponents *components = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.month += monthes;
    
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSDate*) dateBySubstractingMonth:(int)monthes
{
    NSDateComponents *components = [[NSDate currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.month -= monthes;
    
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSString*) monthName {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *stringFromDate = [formatter stringFromDate:self];
    
    return stringFromDate;
}

- (NSString*) yearFromDateStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *stringFromDate = [formatter stringFromDate:self];
    
    return stringFromDate;
}



@end
