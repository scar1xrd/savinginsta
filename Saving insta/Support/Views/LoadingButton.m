//
//  LoadingButton.m
//  Saving insta
//
//  Created by Igor Sorokin on 16.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "LoadingButton.h"

@interface LoadingButton ()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation LoadingButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    
    return self;
}

- (void)setupViews {
    UILabel *tmpLabel = [[UILabel alloc] init];
    tmpLabel.textColor = UIColor.whiteColor;
    
    UIActivityIndicatorView *tmpIndicator = [[UIActivityIndicatorView alloc] init];
    tmpIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    tmpIndicator.hidden = YES;
    
    self.label = tmpLabel;
    self.activityIndicator = tmpIndicator;
    
    [self addSubview:self.label];
    [self addSubview:self.activityIndicator];
}

- (void)setupConstraints {
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.label
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1
                                      constant:0],
        
        [NSLayoutConstraint constraintWithItem:self.label
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0],
        
        [NSLayoutConstraint constraintWithItem:self.activityIndicator
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0],
        
        [NSLayoutConstraint constraintWithItem:self.activityIndicator
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1
                                      constant:-12],
    ]];
}

- (void)setTitle:(NSString *) title {
    self.label.text = title;
}

- (void)showLoadingState {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    self.alpha = 0.6;
}

- (void)showNormalState {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.alpha = 1;
}

@end
