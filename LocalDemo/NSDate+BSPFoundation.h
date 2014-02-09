//
//  NSDate+BSPFoundation.h
//
//  Created by Kyle Davis on 9/26/09.
//  Copyright 2009 BigSprocket, LLC. All rights reserved.
//

// Format characters
// http://waracle.net/iphone-nsdateformatter-date-formatting-table/

#import <Foundation/Foundation.h>

#define kSecondsPerDay 86400.0

#define BSPSECONDS(_bspMac_sec_) (_bspMac_sec_)
#define BSPMINUTES(_bspMac_min_) (BSPSECONDS(_bspMac_min_) * 60.0)
#define BSPHOURS(_bspMac_hours_) (BSPMINUTES(_bspMac_hours_) * 60.0)
#define BSPDAYS(_bspMac_days_) ((_bspMac_days_) * kSecondsPerDay)

@interface NSDate (BSPFoundation)

- (NSInteger)minutesAgo;
- (BOOL)isInPast;
- (NSString *)howSoon;

+ (NSDate *)dateFromISO8601:(NSString *)str;
- (NSString *)toISO8601;

- (BOOL)isYesterday;
- (BOOL)isToday;
- (BOOL)isTomorrow;

- (NSDate *)midnight;
- (NSDate *)noon;
+ (NSDate *)tomorrow;
+ (NSDate *)yesterday;

- (NSDate *)dateAtTime:(NSTimeInterval)timeInterval;
- (NSTimeInterval)timePortion;

- (BOOL)isBefore:(NSDate *)other;
- (BOOL)isAfter:(NSDate *)after;

- (int)daysAgo;

- (NSString *)stringWithFormat:(NSString *)formatString;
- (NSString *)stringWithTemplate:(NSString *)templateString;

- (NSString *)shortDate;                //  7/25/69
- (NSString *)mediumDate;               //  Jul 25, 1969
- (NSString *)mediumLongDate;           //  Monday, Jul 25, 1969
- (NSString *)longDate;                 //  Monday, July 25, 1969


- (NSString *)shortTime;
- (NSString *)mediumTime;
- (NSString *)longTime;

- (NSString *)shortDateTime;

- (NSComparisonResult)reverseCompare:(NSDate *)otherDate;

+ (NSDate *)dateFromShortDate:(NSString *)str;

+ (NSLocale *)bsp_locale;
+ (void)bsp_setLocale:(NSLocale *)locale;

@end

