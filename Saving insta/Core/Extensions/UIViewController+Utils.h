//
//  UIViewController+Utils.h
//  Saving insta
//
//  Created by Igor Sorokin on 15.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Utils)

- (void)showAlert:(NSString *)title
          message:(NSString *)message
completionHandler:(nullable void(^)(void))completionHandler;

- (void)showSuccessHUD:(NSString *)title;
- (void)showErrorHUD:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
