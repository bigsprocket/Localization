//
//  LDDDatePickerCell.m
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import "LDDDatePickerCell.h"

@interface LDDDatePickerCell()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation LDDDatePickerCell

- (void)setDate:(NSDate *)date {
    if (!date) date = [NSDate date];
    self.datePicker.date = date;
}

- (NSDate *)date {
    return self.datePicker.date;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    self.datePicker.minimumDate = minimumDate;
}

- (NSDate *)minimumDate {
    return self.datePicker.minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    self.datePicker.maximumDate = maximumDate;
}

- (NSDate *)maximumDate {
    return self.datePicker.maximumDate;
}

- (IBAction)dateChanged:(id)sender {
    if (self.blockChangingValue) {
        self.blockChangingValue(self.datePicker.date);
    }
}

@end
