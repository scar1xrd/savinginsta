//
//  AppDelegate.m
//  Saving insta
//
//  Created by Igor Sorokin on 11.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManagerSwift-Swift.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    IQKeyboardManager.shared.enable = YES;
    return YES;
}


@end
