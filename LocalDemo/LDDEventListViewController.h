//
//  LDDEventListViewController.h
//  LocalDemo
//
//  Created by Kyle Davis on 2/7/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDDEventListViewController : UITableViewController

- (IBAction)editorUnwindCancel:(UIStoryboardSegue *)segue;
- (IBAction)editorUnwindDone:(UIStoryboardSegue *)segue;
- (IBAction)editorUnwindDelete:(UIStoryboardSegue *)segue;

@end
