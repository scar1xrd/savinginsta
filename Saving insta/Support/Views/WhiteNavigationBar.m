//
//  WhiteNavigationBar.m
//  Saving insta
//
//  Created by Igor Sorokin on 17.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "WhiteNavigationBar.h"

@implementation WhiteNavigationBar

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    self.shadowImage = [[UIImage alloc] init];
}

@end
