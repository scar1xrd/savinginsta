//
//  OnboardingView.m
//  Saving insta
//
//  Created by Igor Sorokin on 31.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "OnboardingView.h"

@interface OnboardingView ()

@property (weak, nonatomic, readwrite) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic, readwrite) IBOutlet UIButton *nextButton;

@end

@implementation OnboardingView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    [self.nextButton setTitle:@"Закрыть" forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 8;
    self.nextButton.layer.masksToBounds = YES;
}

@end
