//
//  NSDate+LDD.h
//
//  Created by Kyle Davis on 2/9/14.
//  Copyright 2014 BigSprocket, LLC. All rights reserved.
//

// I always have to look for these...
// http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
// http://waracle.net/iphone-nsdateformatter-date-formatting-table/

@interface NSDate(LDD)

- (NSString *)stringWithFormat:(NSString *)formatString;
- (NSString *)stringWithTemplate:(NSString *)templateString;

- (NSString *)shortDate;                //  7/25/69
- (NSString *)mediumDate;               //  Jul 25, 1969
- (NSString *)longDate;                 //  Monday, July 25, 1969

- (NSString *)shortTime;
- (NSString *)mediumTime;
- (NSString *)longTime;
    
- (NSString *)shortDateTime;

+ (NSDate *)dateFromShortDate:(NSString *)str;
    
@end

