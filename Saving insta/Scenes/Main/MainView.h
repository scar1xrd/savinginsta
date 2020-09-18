//
//  MainView.h
//  Saving insta
//
//  Created by Igor Sorokin on 14.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainView : UIView

@property (weak, nonatomic, readonly) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic, readonly) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic, readonly) IBOutlet UIButton *captionCopyButton;
@property (weak, nonatomic, readonly) IBOutlet UITextField *linkTextField;
@property (weak, nonatomic, readonly) IBOutlet LoadingButton *downloadButton;
@property (weak, nonatomic, readonly) IBOutlet UIButton *downloadMediaButton;
@property (weak, nonatomic, readonly) IBOutlet UIView *cardView;

@end

NS_ASSUME_NONNULL_END
