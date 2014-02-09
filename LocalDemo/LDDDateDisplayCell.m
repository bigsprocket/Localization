//
//  LDDDateDisplayCell.m
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import "LDDDateDisplayCell.h"
#import "NSDate+BSPFoundation.h"

@implementation LDDDateDisplayCell
@synthesize date=_date;

- (void)setDate:(NSDate *)date {
    _date = date;

    if (date) {
        self.detailTextLabel.text = [date shortDate];
    } else {
        self.detailTextLabel.text = self.noDatePlaceholder;
    }
}

- (NSDate *)date {
    return _date;
}

- (void)setCaption:(NSString *)caption {
    self.textLabel.text = caption;
}

- (NSString *)caption {
    return self.textLabel.text;
}

@end
