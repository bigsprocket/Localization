//
//  NSIndexPath+BSPTouch.m
//  BSPTouch7
//
//  Created by Kyle Davis on 10/25/13.
//  Copyright (c) 2013 BigSprocket, LLC. All rights reserved.
//

#import "NSIndexPath+BSPTouch.h"

@implementation NSIndexPath (BSPTouch)

- (BOOL)isEqualToIndexPath:(NSIndexPath *)otherPath; {
    if (!otherPath) return NO;

    return (otherPath.row == self.row) && (otherPath.section == self.section);
}

- (NSString *)stringRepresentation {
    return [NSString stringWithFormat:@"{%ld,%ld}", (long)self.section, (long)self.row];
}

@end
