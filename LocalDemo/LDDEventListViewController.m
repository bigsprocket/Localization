//
//  LDDEventListViewController.m
//  LocalDemo
//
//  Created by Kyle Davis on 2/7/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import "LDDEventListViewController.h"
#import "LDDEvent.h"
#import "LDDEventListCell.h"
#import "LDDAddEditEventViewController.h"

static CGFloat defaultRowHeight;
static NSString * cellIdentifier = @"LDDEventListCell";
static NSString * kKeyAddSegue = @"AddItem";
static NSString * kKeyEditSegue = @"EditItem";

@interface LDDEventListViewController ()
@property (nonatomic, strong) NSMutableArray *events;

@end

@implementation LDDEventListViewController

@synthesize events = _events;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fakeSomeData];
    
    self.title = [LDDStrings eventListTitle];
}

#pragma mark - tableview delegate/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDDEventListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    LDDEvent *event = [self.events objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = event.name;
//    cell.dateLabel.text = [event.date stringWithFormat:@"MMM dd, yyyy"]; // TODO: Localize
    cell.dateLabel.text = [event.date stringWithTemplate:@"MMM dd, yyyy"]; // TODO: Localize
    cell.noteLabel.text = event.note;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only compute the default height of a row once
    if (!defaultRowHeight) {
        LDDEventListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        defaultRowHeight = cell.bounds.size.height;
    }
    
    return defaultRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGSize layoutSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return MAX(44.0, layoutSize.height);
}

#pragma mark - My segue handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    LDDAddEditEventViewController *editor = [segue destinationViewController];

    NSString *segueId = [segue identifier];
    
    if ([segueId isEqualToString:kKeyEditSegue]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LDDEvent *event = [self.events objectAtIndex:indexPath.row];
        editor.eventEditing = event;
    } else if ([segueId isEqualToString:kKeyAddSegue]) {
        // an editor with no event is an add
    }
}

#pragma mark - Subordinate segue handling

- (IBAction)editorUnwindCancel:(UIStoryboardSegue *)segue {
    // editor canceled. Nothing to do.
}

- (IBAction)editorUnwindDone:(UIStoryboardSegue *)segue {
    // save the object changes
    LDDAddEditEventViewController *sourceVC = segue.sourceViewController;
    LDDEvent *event = sourceVC.eventEditing;
    
    // quick and dirty, no table animation
    if (! [self.events containsObject:event]) {
        [self.events addObject:event];
    }
    
    // re-sort the array
    NSSortDescriptor *dateAscending = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [self.events sortUsingDescriptors:@[dateAscending]];
    
    [self.tableView reloadData];
    
}

- (IBAction)editorUnwindDelete:(UIStoryboardSegue *)segue {
    // delete the object
    LDDAddEditEventViewController *sourceVC = segue.sourceViewController;
    LDDEvent *event = sourceVC.eventEditing;
    
    // quick and dirty, no table animation
    [self.events removeObject:event];
    [self.tableView reloadData];
}

#pragma mark - miscellaneous

- (void)fakeSomeData {
    
    if (! _events) {
        self.events = [NSMutableArray array];
    }
    
    LDDEvent *event = [[LDDEvent alloc] init];
    event.name = @"iOS Localization";
    event.date = [NSDate dateFromShortDate:@"02/18/2014"];
    event.note = @"Examine the tools and processes for iOS app localization";
    
    [self.events addObject:event];
}

@end
