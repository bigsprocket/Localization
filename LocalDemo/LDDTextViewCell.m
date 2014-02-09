//
//  LDDTextViewCell.m
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import "LDDTextViewCell.h"

@interface LDDTextViewCell()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation LDDTextViewCell

{
    BOOL registered;
}

@synthesize editable = _editable;

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    
    self.textView.editable = _editable;
    
    if (!_editable) [self resignFirstResponder];
}

- (BOOL)editable {
    return self.textView.editable;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
    self.placeholderLabel.hidden = ([[self.textView text] length] > 0);
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (BOOL)becomeFirstResponder; {
    
    if (self.editable && [self.textView becomeFirstResponder]) {
        if (!registered) [self registerForNotifications];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)resignFirstResponder {
    return [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(NSNotification *)notif {
    if (self.blockChangingValue) {
        self.blockChangingValue( self.textView.text );
    }
    
    self.placeholderLabel.hidden = ([[self.textView text] length] > 0);
}

- (void)textViewDidBeginEditing:(UITextField *)textField {
    if (self.blockBecomingFirstResponder) self.blockBecomingFirstResponder();
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self.textView];
    self.textView.delegate = self;
    registered = YES;
}

- (void)unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:self.textView];
    registered = NO;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if (registered) {
        [self unregisterForNotifications];
    }
    
    self.textView.delegate = nil;
    self.textView.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) [self becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) [self becomeFirstResponder];
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
