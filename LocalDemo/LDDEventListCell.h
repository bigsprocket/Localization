//
//  LDDEventListCell.h
//  LocalDemo
//
//  Created by Kyle Davis on 2/7/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDDEventListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;

@end
