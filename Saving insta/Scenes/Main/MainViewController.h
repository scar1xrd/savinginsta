//
//  ViewController.h
//  Saving insta
//
//  Created by Igor Sorokin on 11.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

- (void)showNormalState;
- (void)showLoadingState;

- (void)showProgressHudStatus:(NSString *)labelStatus progress:(NSNumber *)progress;
- (void)hideProgressHud;

- (void)updatePublicationAndCaption:(NSString *)caption;

@end

