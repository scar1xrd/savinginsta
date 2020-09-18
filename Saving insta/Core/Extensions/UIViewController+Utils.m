//
//  UIViewController+Utils.m
//  Saving insta
//
//  Created by Igor Sorokin on 15.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

- (void)showAlert:(NSString *)title
          message:(NSString *)message
completionHandler:(nullable void(^)(void))completionHandler {
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle: @"Oк"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) {
            completionHandler();
        }
    }];
    
    [alert addAction:OkAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
 
- (void)showSuccessHUD:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}

- (void)showErrorHUD:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}

@end
