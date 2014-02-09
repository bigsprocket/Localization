//
//  LDDTextFieldCell.m
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import "LDDTextFieldCell.h"

@interface LDDTextFieldCell()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation LDDTextFieldCell
{
    BOOL registered;
}

@synthesize editable = _editable;

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    
    self.textField.enabled = _editable;
    if (!_editable) [self resignFirstResponder];
}

- (BOOL)editable {
    return self.textField.enabled;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}

- (NSString *)placeholder {
    return self.textField.placeholder;
}

- (BOOL)becomeFirstResponder; {
    
    if (self.editable && [self.textField becomeFirstResponder]) {
        if (!registered) [self registerForNotifications];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

- (void)textFieldDidChange:(NSNotification *)notif {
    if (self.blockChangingValue) {
        self.blockChangingValue( self.textField.text );
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.blockBecomingFirstResponder) self.blockBecomingFirstResponder();
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    
    return YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if (registered) {
        [self unregisterForNotifications];
    }
    
    self.textField.delegate = nil;
    self.textField.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) [self becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) [self becomeFirstResponder];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    self.textField.delegate = self;
    registered = YES;
}

- (void)unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
    registered = NO;
}

- (void)didMoveToSuperview {
    if (self.superview) {
        if (!registered) {
            [self registerForNotifications];
        }
    } else {
        if (registered) {
            [self unregisterForNotifications];
        }
    }
}

@end
