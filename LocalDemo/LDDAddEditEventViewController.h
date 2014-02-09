//
//  LDDAddEditEventViewController.h
//  LocalDemo
//
//  Created by Kyle Davis on 2/7/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDDEvent;

@interface LDDAddEditEventViewController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) LDDEvent *eventEditing;

@end
