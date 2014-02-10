//
//  LDDStrings.m
//  LocalDemo
//
//  Created by Kyle Davis on 2/9/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import "LDDStrings.h"

@implementation LDDStrings

+ (NSString *)eventListTitle {
    return NSLocalizedString(@"Events", @"Event list title");
}

+ (NSString *)editingEventTitle {
    return NSLocalizedString(@"Detail", @"Edit event title");
}

+ (NSString *)addingEventTitle {
    return NSLocalizedString(@"Add", @"Add event title");
}

+ (NSString *)cancelAction {
    return NSLocalizedString(@"Cancel", @"Cancel");
}

+ (NSString *)deleteAction {
    return NSLocalizedString(@"Delete", @"Delete an event");
}

+ (NSString *)eventPlaceholder {
    return NSLocalizedString(@"Event", @"Placeholder for event title text field");
}

+ (NSString *)notePlaceholder {
    return NSLocalizedString(@"Note", @"Placeholder for event note text field");
}

+ (NSString *)dateCaption {
    return NSLocalizedString(@"Date", @"Caption for date field");
}

+ (NSString *)selectPlaceholder {
    return NSLocalizedString(@"(select)", @"Placeholder when a date has not yet been selected");
}

@end
