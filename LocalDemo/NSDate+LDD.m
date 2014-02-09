//
//  NSDate+LDD.m
//
//  Created by Kyle Davis on 2/9/14.
//  Copyright 2014 BigSprocket, LLC. All rights reserved.
//

#import "NSDate+LDD.h"

@implementation NSDate(LDD)

- (NSString *)stringWithFormat:(NSString *)formatString; {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterFullStyle];
    [fmt setDateFormat:formatString];
    
	return [fmt stringFromDate:self];
}

- (NSString *)stringWithTemplate:(NSString *)templateString {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:templateString options:0 locale:fmt.locale];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateFormat:formatString];
    
	return [fmt stringFromDate:self];
}

- (NSString *)shortDate; {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateStyle:NSDateFormatterShortStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)mediumDate; {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateStyle:NSDateFormatterMediumStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)longDate; {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateStyle:NSDateFormatterLongStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)shortTime; {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [fmt setDateStyle:NSDateFormatterNoStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)mediumTime; {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterMediumStyle];
    [fmt setDateStyle:NSDateFormatterNoStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)longTime; {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterLongStyle];
    [fmt setDateStyle:NSDateFormatterNoStyle];
    
	return [fmt stringFromDate:self];
}

- (NSString *)shortDateTime; {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [fmt setDateStyle:NSDateFormatterShortStyle];
    
	return [fmt stringFromDate:self];
}

+ (NSDate *)dateFromShortDate:(NSString *)str {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeStyle:NSDateFormatterNoStyle];
    [fmt setDateFormat:@"MM/dd/yyyy"];
    
    return [fmt dateFromString:str];
}

@end
