//
//  LDDDatePickerCell.h
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDDDatePickerCell : UITableViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, copy) IdReturningBlock blockChangingValue;

@end
