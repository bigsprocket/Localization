//
//  LDDCenterLabelCell.m
//  LocalDemo
//
//  Created by Kyle Davis on 2/8/14.
//  Copyright (c) 2014 BigSprocket, LLC. All rights reserved.
//

#import "LDDCenterLabelCell.h"

@interface LDDCenterLabelCell()
@property (nonatomic, strong) IBOutlet UILabel *captionLabel;

@end

@implementation LDDCenterLabelCell

- (NSString *)caption {
    return self.captionLabel.text;
}

- (void)setCaption:(NSString *)caption {
    self.captionLabel.text = caption;
}

- (UIColor *)captionColor {
    return self.captionLabel.textColor;
}

- (void)setCaptionColor:(UIColor *)captionColor {
    self.captionLabel.textColor = captionColor;
}

@end
