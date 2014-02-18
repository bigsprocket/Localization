//
//  LDDTextFieldCell.h
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDDTextFieldCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) BOOL editable;

@property (nonatomic, copy) IdReturningBlock blockChangingValue;
@property (nonatomic, copy) Block blockBecomingFirstResponder;

@end
