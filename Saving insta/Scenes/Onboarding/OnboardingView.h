//
//  OnboardingView.h
//  Saving insta
//
//  Created by Igor Sorokin on 31.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnboardingView : UIView

@property (weak, nonatomic, readonly) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic, readwrite) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic, readonly) IBOutlet UIButton *nextButton;

@end

NS_ASSUME_NONNULL_END
