//
//  LoadingButton.h
//  Saving insta
//
//  Created by Igor Sorokin on 16.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingButton : UIControl

- (void)setTitle:(NSString *) title;
- (void)showLoadingState;
- (void)showNormalState;

@end
