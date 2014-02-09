//
//  NSDate+BSPFoundation.m
//
//  Created by Kyle Davis on 9/26/09.
//  Copyright 2009 BigSprocket, LLC. All rights reserved.
//

#import "NSDate+BSPFoundation.h"
#import "NSString+BSPFoundation.h"


// I always have to look for this...
// http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
// http://waracle.net/iphone-nsdateformatter-date-formatting-table/

@implementation NSDate (BSPFoundation)

+ (NSDateFormatter *)formatter {
    static NSDateFormatter* fmt = nil;

    if (!fmt) {
        fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [NSLocale autoupdatingCurrentLocale];
    }
    
    return fmt;
}

+ (NSDateFormatter *)utcFormatter {
    static NSDateFormatter* utcFmt = nil;
    
    if (!utcFmt) {
        utcFmt = [[NSDateFormatter alloc] init];
        utcFmt.locale = [NSLocale systemLocale];
        utcFmt.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    
    return utcFmt;
}

- (NSInteger)minutesAgo {
    
	NSTimeInterval secsSinceNow = [self timeIntervalSinceNow];
	NSInteger minsSinceNow = (NSInteger)secsSinceNow / 60;
	NSInteger minutesAgo = -minsSinceNow;
	
	return minutesAgo;
}

- (BOOL)isInPast {
    NSTimeInterval when = [self timeIntervalSinceNow];

	return when < 0.0;
}

- (NSString *)howSoon {

	NSTimeInterval secsFromNow = [self timeIntervalSinceNow];
	
	if (secsFromNow < 1) { return @"past"; }
	
	int minutes = (int)secsFromNow / 60;
	int hours = minutes / 60;
	int days = hours / 24;
	hours = hours % 24;
	minutes = minutes % 60;
	
	if (days > 0) {
		
        return [NSString stringWithFormat:@"%d d, %d h, %d m", days, hours, minutes];
	} else {

		if (hours > 0)
		{
			
            if (hours > 1) {
				
                return [NSString stringWithFormat:@"%d hours, %d min", hours, minutes];
			} else {
                
				return [NSString stringWithFormat:@"%d hour(s), %d min", hours, minutes];
			}
		}
	}
	
	if (minutes > 1) {
		return [NSString stringWithFormat:@"%d minutes", minutes];
	}
    
	return [NSString stringWithFormat:@"%d minute", minutes];
}

+ (NSDate *)dateFromISO8601:(NSString *)str
{
    if ([str hasSuffix:@"Z"]) {
        str = [str substringToIndex:(str.length-1)];
    }
    
    NSDate *dt;
    NSDateFormatter* sISO8601;
    
    if ([str containsString:@"T"]) {
        sISO8601 = [self utcFormatter];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        dt = [sISO8601 dateFromString:str]; if (dt) return dt;
    }
    
    sISO8601 = [self formatter];
    [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
    [sISO8601 setDateFormat:@"yyyy-MM-dd"];
    dt = [sISO8601 dateFromString:str]; if (dt) return dt;
    
    return nil;
}

- (NSString *)toISO8601
{
    NSDateFormatter* fmt = [[self class] formatter];
    
    [fmt setTimeStyle:NSDateFormatterFullStyle];
    [fmt setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	
	return [fmt stringFromDate:self];
}

- (BOOL)isTomorrow {
	return [[self midnight] timeIntervalSince1970] == [[[NSDate tomorrow] midnight] timeIntervalSince1970];
}

- (BOOL)isYesterday {
	return [[self midnight] timeIntervalSince1970] == [[[NSDate yesterday] midnight] timeIntervalSince1970];
}

- (BOOL)isToday {
	return [[self midnight] timeIntervalSince1970] == [[[NSDate date] midnight] timeIntervalSince1970];
}

- (BOOL)isBefore:(NSDate *)other; {
    if (other == nil) return YES;
    
    return [other compare:self] == NSOrderedDescending;
}

- (BOOL)isAfter:(NSDate *)other; {
    if (other == nil) return YES;

    return [other compare:self] == NSOrderedAscending;
}

- (NSDate *)dateAtTime:(NSTimeInterval)timeInterval; {
    return [[self midnight] dateByAddingTimeInterval:timeInterval];
}

- (NSTimeInterval)timePortion; {
    return [self timeIntervalSinceDate:[self midnight]];
}

- (NSDate *)midnight {
	NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components =
    [gregorian components:
	 (NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                 fromDate:self];
	
	return [gregorian dateFromComponents:components];
}

- (NSDate *)noon {
    NSDate *midnight = [self midnight];

    return [midnight dateByAddingTimeInterval:(kSecondsPerDay / 2)];
}


+ (NSDate *)tomorrow; {
    return [NSDate dateWithTimeIntervalSinceNow:kSecondsPerDay];
}

+ (NSDate *)yesterday; {
    return [NSDate dateWithTimeIntervalSinceNow:-kSecondsPerDay];
}

- (int)daysAgo {
    int secondsAgo = ([[[NSDate date] midnight] timeIntervalSince1970] - [[self midnight] timeIntervalSince1970]);
    
    return secondsAgo / kSecondsPerDay;
}


- (NSString *)stringWithFormat:(NSString *)formatString; {
    NSDateFormatter* fmt = [[self class] formatter];
    [fmt setTimeStyle:NSDateFormatterFullStyle];
    [fmt setDateFormat:formatString];
    
	return [fmt stringFromDate:self];
}

- (NSString *)stringWithTemplate:(NSString *)templateString {
    NSDateFormatter* fmt = [[self class] formatter];
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:templateString options:0 locale:fmt.locale];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateFormat:formatString];
    
	return [fmt stringFromDate:self];
}

- (NSString *)shortDate; {
    NSDateFormatter* fmt = [[self class] formatter];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateStyle:NSDateFormatterShortStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)mediumDate; {
    NSDateFormatter* fmt = [[self class] formatter];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateStyle:NSDateFormatterMediumStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)mediumLongDate; {
    return [self stringWithTemplate:@"EEEdMMMyyyy"];
}

- (NSString *)longDate; {
    NSDateFormatter* fmt = [[self class] formatter];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateStyle:NSDateFormatterLongStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)shortTime; {
    NSDateFormatter* fmt = [[self class] formatter];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [fmt setDateStyle:NSDateFormatterNoStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)mediumTime; {
    NSDateFormatter* fmt = [[self class] formatter];
    [fmt setTimeStyle:NSDateFormatterMediumStyle];
    [fmt setDateStyle:NSDateFormatterNoStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)longTime; {
    NSDateFormatter* fmt = [[self class] formatter];
    [fmt setTimeStyle:NSDateFormatterLongStyle];
    [fmt setDateStyle:NSDateFormatterNoStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)shortDateTime; {
    NSDateFormatter* fmt = [[self class] formatter];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [fmt setDateStyle:NSDateFormatterShortStyle];
    
	return [fmt stringFromDate:self];
}

- (NSComparisonResult)reverseCompare:(NSDate *)otherDate; {
    NSComparisonResult cpr = [self compare:otherDate];

    return (cpr == NSOrderedAscending ? NSOrderedDescending : cpr == NSOrderedDescending ? NSOrderedAscending : cpr);
}


+ (NSDate *)dateFromShortDate:(NSString *) str {
    NSDateFormatter* shortDt = [self formatter];
    [shortDt setTimeStyle:NSDateFormatterNoStyle];
    [shortDt setDateFormat:@"MM/dd/yyyy"];
    
    return [shortDt dateFromString:str];
}


+ (NSLocale *)bsp_locale {
    return [[self formatter] locale];
}

+ (void)bsp_setLocale:(NSLocale *)locale {
    [[self formatter] setLocale:locale];
}

@end
