//
//  NSIndexPath+LDD.m
//
//  Created by Kyle Davis on 2/9/14.
//  Copyright 2014 BigSprocket, LLC. All rights reserved.
//

#import "NSIndexPath+LDD.h"

@implementation NSIndexPath (LDD)

- (BOOL)isEqualToIndexPath:(NSIndexPath *)otherPath; {
    if (!otherPath) return NO;

    return (otherPath.row == self.row) && (otherPath.section == self.section);
}

- (NSString *)stringRepresentation {
    return [NSString stringWithFormat:@"{%ld,%ld}", (long)self.section, (long)self.row];
}

@end
