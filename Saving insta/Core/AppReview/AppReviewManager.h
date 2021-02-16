//
//  AppReviewManager.h
//  Saving insta
//
//  Created by Igor Sorokin on 15.02.2021.
//  Copyright © 2021 Igor Sorokin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppReviewManager : NSObject

+ (instancetype)shared;
- (void)didDownloadMedia;
- (void)requestReviewAlertIfNeeded;

@end
