//
//  LDDDateDisplayCell.h
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDDDateDisplayCell : UITableViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *noDatePlaceholder;

@end
