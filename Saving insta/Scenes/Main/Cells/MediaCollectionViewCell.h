//
//  MediaCollectionViewCell.h
//  Saving insta
//
//  Created by Igor Sorokin on 16.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MediaCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet CheckButton *checkButton;

@end

NS_ASSUME_NONNULL_END
