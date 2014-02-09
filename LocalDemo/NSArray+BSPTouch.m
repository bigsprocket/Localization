//
//  NSArray+BSPTouch.m
//  BSPTouch
//
//  Created by Kyle on 5/31/11.
//  Copyright 2011 BigSprocket, LLC. All rights reserved.
//

#import "NSArray+BSPTouch.h"

@implementation NSArray(BSPTouch)

- (id)nestedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	NSArray *subArray = [self objectAtIndex:section];
	
	if (![subArray isKindOfClass:[NSArray class]])
		return nil;
	
	if (row >= [subArray count])
		return nil;
	
	return [subArray objectAtIndex:row];
}

@end
