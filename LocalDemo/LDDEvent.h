//
//  LDDEvent.h
//  LocalDemo
//
//  Created by Kyle Davis on 2/7/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDDEvent : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *note;

@end
