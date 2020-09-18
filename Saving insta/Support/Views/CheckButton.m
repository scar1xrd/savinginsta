//
//  CheckButton.m
//  Saving insta
//
//  Created by Igor Sorokin on 21.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "CheckButton.h"

@implementation CheckButton

- (void)setIsChecked:(BOOL)isChecked {
    if (_isChecked != isChecked) {
        _isChecked = isChecked;
        isChecked ? [self setBackgroundImage:[UIImage imageNamed:@"check"]
                                   forState:UIControlStateNormal] :
                   [self setBackgroundImage:[UIImage imageNamed:@"uncheck"]
                                   forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isChecked = NO;
    [self setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
}

@end
