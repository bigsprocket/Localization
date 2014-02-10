//
//  LDD.h
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Block) ();
typedef void (^ErrorReturningBlock)(NSError *err);
typedef void (^IdReturningBlock)(id retVal);
typedef void (^CompletionBlock)(BOOL finished);
typedef void (^ObjectReturningBlock) (NSObject *obj);

#import "NSDate+LDD.h"
#import "NSIndexPath+LDD.h"
#import "LDDStrings.h"

