//
//  NSString+BSPFoundation.m
//  BSPFoundation
//
//  Created by Kyle Davis on 9/30/09.
//  Copyright 2009 BigSprocket, LLC. All rights reserved.
//

#import "NSString+BSPFoundation.h"

@implementation NSString (BSPFoundation)

// NSString already has "hasPrefix" for "beginsWithString"
- (BOOL)endsWithString:(NSString *)otherString {
	unsigned int myLen = (unsigned int)[self length];
	unsigned int yourLen = (unsigned int)[otherString length];
	if (myLen < yourLen) return NO;
    
	return [[self substringFromIndex:myLen-yourLen] isEqualToString:otherString];
}

- (BOOL)containsString:(NSString *)other {
	return [self containsString:other withOptions:0];
}

- (BOOL)containsStringCaseInsensitive:(NSString *)other {
	return [self containsString:other withOptions:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString *)other withOptions:(NSStringCompareOptions)opts {
	return [self rangeOfString:other options:opts].length != 0;
}

- (BOOL)isBlank {
	return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

- (NSString *)stringValueWithDefault:(NSString *)defaultValue {
	return [self isBlank] ? defaultValue : self;
}


- (NSString *)decodeBase64String {
    NSData *dta = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [dta base64EncodedStringWithOptions:0];
}

- (NSString *)trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSDictionary *)splitQueryString {
	NSArray *queryComponents = [self componentsSeparatedByString:@"&"];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[queryComponents count]];
	
	NSString *queryComponent;

	for (queryComponent in queryComponents) {
		NSArray	*query = [queryComponent componentsSeparatedByString:@"="];

		if ([query count] == 2) {
			NSString *queryKey = [query objectAtIndex:0];
			NSString *queryValue = [query objectAtIndex:1];
			NSString *decodedValue = [queryValue stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
			
			[dict setValue:decodedValue forKey:queryKey];
		}
	}
	
	return [NSDictionary dictionaryWithDictionary:dict];
}


- (NSString *)urlEncodedString {
	return [self stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

- (NSString *)escapeHTML {
	NSMutableString *s = [NSMutableString string];
	
	unsigned int start = 0;
	unsigned int len = (unsigned int)[self length];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
				//			case '…':
				//				[s appendString:@"&hellip;"];
				//				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = (unsigned int)r.location + 1;
	}
	
	return s;
}


- (NSString *)unescapeHTML {
	NSMutableString *s = [NSMutableString string];
	NSMutableString *target = [self mutableCopy];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&#39;"]) {
			[s appendString:@"'"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&hellip;"]) {
			[s appendString:@"…"];
			[target deleteCharactersInRange:NSMakeRange(0, 8)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}


- (BOOL)isEmail {
	
    NSString *emailRegEx =  
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"  
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" 
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"  
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"  
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"  
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"  
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";  
	
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];  
    
    return [regExPredicate evaluateWithObject:[self lowercaseString]];
}

- (NSString *)propertyStyleString {

    NSString * result = [[self substringToIndex:1] lowercaseString];
    if ([self length] == 1) return ( result );
	
    return ([result stringByAppendingString:[self substringFromIndex: 1]]);
}

- (NSDate *)dateFromMSJsonString
{
    // it should be a string in format "/Date(ticks[-offset])/"
    if ([self hasPrefix:@"/Date("]) {

        NSUInteger endOfString = [self rangeOfString:@")"].location;
        NSString *str = [[self substringToIndex:endOfString] substringFromIndex:6];
        // now str contains ticks, optionally with -offset
        
        if (str && [str length] > 0) {
            NSString *offset = nil;
            NSRange minus = [str rangeOfString:@"-"];
            NSRange plus = [str rangeOfString:@"+"];

            if (minus.length > 0) {
                offset = [str substringFromIndex:minus.location+1];
                str = [str substringToIndex:minus.location];
            }
            
            if (plus.length > 0) {
                offset = [str substringFromIndex:plus.location+1];
                str = [str substringToIndex:plus.location];
            }
            
            NSTimeInterval seconds = [str doubleValue]/1000.0;
            NSDate *dt = [NSDate dateWithTimeIntervalSince1970:seconds];
            
            if (dt) {
                
                if (offset) {
                    seconds = [offset doubleValue]; // not really seconds yet

                    if ((round(seconds / 100) * 100) == seconds) { // whole hours, not half hours
                        seconds = (seconds / 100) * 3600; //hours * 3600 seconds in an hour
                    } else {
                        // one of those funky canadian timezones. We only need to worry about half hours,
                        // so fake it rather than try to calculate.
                        seconds = 1800 + (seconds / 100) * 3600; //hours * 3600 seconds in an hour + half an hour
                    }
                    
                    if (minus.length > 0) seconds = -seconds;
                    
                    dt = [dt dateByAddingTimeInterval:seconds];
                }
                
                return dt;
            }
        }
    }
    
    return nil;
}

- (NSString *)nonBreakingString;
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
}

@end
