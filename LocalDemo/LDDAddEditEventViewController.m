//
//  LDDAddEditEventViewController.m
//  LocalDemo
//
//  Created by Kyle Davis on 2/7/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import "LDDAddEditEventViewController.h"
#import "LDDEvent.h"
#import "NSArray+BSPTouch.h"
#import "NSIndexPath+BSPTouch.h"
#import "LDDDatePickerCell.h"
#import "LDDDateDisplayCell.h"
#import "LDDCenterLabelCell.h"
#import "LDDTextFieldCell.h"
#import "LDDTextViewCell.h"

static NSString * kKeyDateCell = @"kKeyDateCell";
static NSString * kKeyNameCell = @"kKeyNameCell";
static NSString * kKeyNoteCell = @"kKeyNoteCell";
static NSString * kKeyDeleteCell = @"kKeyDeleteCell";
static NSString * kKeyDeleteSegue = @"DeleteItem";

static int kTagDeleteConfirmation = 456;

@interface LDDAddEditEventViewController ()
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation LDDAddEditEventViewController
{
    BOOL canDelete;
    
    NSArray *tableStructure;
    NSIndexPath *pickerPath;
    NSIndexPath *dateCellPath;
    NSIndexPath *lastRowSelected;

    NSMutableDictionary *heights;
    
    UIControl *currentResponder;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerForNotifications];
    
    if (self.eventEditing) {
        self.title = @"Detail";

        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = NO;

        tableStructure = @[
                           @[kKeyNameCell],
                           @[kKeyDateCell],
                           @[kKeyNoteCell],
                           @[kKeyDeleteCell]
                           ];
        dateCellPath = [NSIndexPath indexPathForRow:0 inSection:1];

    } else {
        self.eventEditing = [[LDDEvent alloc] init];
        self.doneButton.enabled = NO;
        self.title = @"Add Event";          // TODO: Localize

        tableStructure = @[
                           @[kKeyNameCell],
                           @[kKeyDateCell],
                           @[kKeyNoteCell],
                           ];
        dateCellPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    
    heights = [NSMutableDictionary dictionary];
        
}

#pragma mark - table view datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableStructure count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *secStructure = [tableStructure objectAtIndex:section];
    NSInteger rowCount = [secStructure count];

    if (pickerPath && pickerPath.section == section) rowCount++;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    __weak typeof(tableView) table = tableView;
    
    Block scrollToVisible = ^{
        [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    };
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (pickerPath)
    {
        if ([pickerPath isEqualToIndexPath:indexPath]) {
            // it's the date picker
            LDDDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDDDatePickerCell class])];
            cell.date = self.eventEditing.date;
            cell.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
            
            cell.blockChangingValue = ^(NSDate *newDate) {
                [weakSelf dateChanged:newDate];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
    // this assumes the date picker is the last row of its section, and that there is only
    // ever one date picker. Defensive code against this removed for brevity.
    NSString *key = [[tableStructure objectAtIndex:section] objectAtIndex:row];

    if ([key isEqualToString:kKeyDeleteCell]) {
        LDDCenterLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDDCenterLabelCell class])];
        cell.caption = @"Delete";                               // TODO: Localize
        cell.captionColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1];
        
        return cell;
    } else if ([key isEqualToString:kKeyNoteCell]) {
        LDDTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDDTextViewCell class])];
        cell.text = self.eventEditing.note;
        cell.placeholderText = @"Note";                         // TODO: Localize
        cell.blockChangingValue = ^(NSString *newString) {
            [weakSelf noteChanged:newString];
        };
        cell.blockBecomingFirstResponder = scrollToVisible;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    } else if ([key isEqualToString:kKeyDateCell]) {
        LDDDateDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDDDateDisplayCell class])];
        cell.caption = @"Date";                                 // TODO: Localize
        cell.noDatePlaceholder = @"(select)";                   // TODO: Localize
        cell.date = self.eventEditing.date;

        return cell;
    } else if ([key isEqualToString:kKeyNameCell]) {
        LDDTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDDTextFieldCell class])];
        cell.text = self.eventEditing.name;
        cell.placeholderText = @"Event Name";                   // TODO: Localize
        cell.blockChangingValue = ^(NSString *newString) {
            [weakSelf nameChanged:newString];
        };
        cell.blockBecomingFirstResponder = scrollToVisible;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    // unknown key. throw the error.
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BOOL removePicker = (pickerPath && ![pickerPath isEqualToIndexPath:indexPath]);
    BOOL addpicker = ([dateCellPath isEqualToIndexPath:indexPath] && !pickerPath);
    
    if (lastRowSelected) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:lastRowSelected];
        if ([cell respondsToSelector:@selector(resignFirstResponder)]) {
            [cell resignFirstResponder];
        }
    }
    
    lastRowSelected = indexPath;
    
    if (removePicker) {
        [self hidePickerIfShown];
    } else if (addpicker) {
        
        // they just picked the date, so show the picker
        
        // Fill in a default date only once they've tapped the date field
        // for the first time.
        if (!self.eventEditing.date) [self dateChanged:[NSDate date]];
        
        [self addDatePickerBelowIndex:dateCellPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // We can cache these because the heights on this form are static. If any row
    // wasn't static, this wouldn't work.
    NSNumber *height = [heights valueForKey:[indexPath stringRepresentation]];
    
    if (!height) {
        CGFloat minSize = [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        CGSize layoutSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        height = [NSNumber numberWithFloat:MAX(layoutSize.height, minSize)];
        [heights setValue:height forKey:[indexPath stringRepresentation]];
    }
    
    return [height floatValue];
}

#pragma mark - segue handling

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kKeyDeleteSegue]) {
        [self scheduleNextRunLoopToCallSelector:@selector(confirmDelete) withObject:nil];

        return NO;
    }
    
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

# pragma mark - cell events

- (void)confirmDelete
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                              cancelButtonTitle:@"Cancel"   // TODO: Localize
                                         destructiveButtonTitle:@"Delete"   // TODO: Localize
                                              otherButtonTitles:nil];
    sheet.tag = kTagDeleteConfirmation;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kTagDeleteConfirmation) {

        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            [self performSegueWithIdentifier:kKeyDeleteSegue sender:self];
        }
    }
}

- (void)dateChanged:(NSDate *)newDate {
    self.eventEditing.date = newDate;
    [self.tableView reloadRowsAtIndexPaths:@[ dateCellPath ] withRowAnimation:UITableViewRowAnimationFade];
    
    [self markDirty];
}

- (void)noteChanged:(NSString *)newString {
    self.eventEditing.note = newString;
    
    [self markDirty];
}

- (void)nameChanged:(NSString *)newString {
    self.eventEditing.name = newString;
    
    [self markDirty];
}

- (void)markDirty {
    self.navigationItem.leftBarButtonItem = self.doneButton;
    self.navigationItem.hidesBackButton = YES;
    self.doneButton.enabled = ([self.eventEditing.name length] > 0) && self.eventEditing.date;
}

#pragma mark - keyboard and picker stuff

- (void)hidePickerIfShown {
    if (pickerPath) {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[ pickerPath ] withRowAnimation:UITableViewRowAnimationFade];
        pickerPath = nil;
        [self.tableView endUpdates];
    }
}

- (void)dismissKeyboard {
    [currentResponder resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(NSNotification *)n {
    [self hidePickerIfShown];
    currentResponder = n.object;
}

- (void)textFieldDidEndEditing:(NSNotification *)n {
    currentResponder = nil;
}

#pragma mark - Miscellaneous


- (void)registerForNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(textFieldDidBeginEditing:)
                   name:UITextFieldTextDidBeginEditingNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(textFieldDidEndEditing:)
                   name:UITextFieldTextDidEndEditingNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(textFieldDidBeginEditing:)
                   name:UITextViewTextDidBeginEditingNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(textFieldDidEndEditing:)
                   name:UITextViewTextDidEndEditingNotification
                 object:nil];
}

- (void)unregisterForNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [center removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [center removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [center removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)scheduleNextRunLoopToCallSelector:(SEL)selector withObject:(id)obj {
    [[NSRunLoop mainRunLoop] performSelector:selector target:self argument:obj order:0 modes:@[NSDefaultRunLoopMode]];
}

- (void)addDatePickerBelowIndex:(NSIndexPath *)indexPath
{
    [self dismissKeyboard];

    [self.tableView beginUpdates];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    pickerPath = pickerIndex;
    [self.tableView insertRowsAtIndexPaths:@[ pickerIndex ] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dealloc {
    [self unregisterForNotifications];
}

@end
