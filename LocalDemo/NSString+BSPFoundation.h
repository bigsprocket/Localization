//
//  NSString+BSPFoundation.h
//  TourneyFinder
//
//  Created by Kyle Davis on 9/30/09.
//  Copyright 2009 BigSprocket, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BSPFoundation)

- (BOOL)isBlank;
- (NSString *)stringValueWithDefault:(NSString *)defaultValue;


- (NSString *)propertyStyleString;

- (BOOL)endsWithString:(NSString *)otherString;
- (BOOL)containsString:(NSString *)other;
- (BOOL)containsStringCaseInsensitive:(NSString *)other;
- (BOOL)containsString:(NSString *)other withOptions:(NSStringCompareOptions)opts;


- (NSString *)trim;
- (NSDictionary *)splitQueryString;


- (NSString *)urlEncodedString;

- (BOOL)isEmail;
- (NSString *)escapeHTML;
- (NSString *)unescapeHTML;

- (NSDate *)dateFromMSJsonString;

- (NSString *)nonBreakingString;

@end
