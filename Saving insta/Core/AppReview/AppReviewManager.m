//
//  AppReviewManager.m
//  Saving insta
//
//  Created by Igor Sorokin on 15.02.2021.
//  Copyright © 2021 Igor Sorokin. All rights reserved.
//

#import "AppReviewManager.h"
#import <StoreKit/StoreKit.h>

@interface AppReviewManager ()

@property (nonatomic) NSUserDefaults *userDefaults;
@property (nonatomic) NSString *kDownloadedMediaCount;
@property (nonatomic) NSString *kReviewRequestCount;
@property (nonatomic) NSString *kLastReviewVesrion;

@end

@implementation AppReviewManager

+ (instancetype)shared {
    static AppReviewManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[AppReviewManager alloc] init];
        shared.userDefaults = NSUserDefaults.standardUserDefaults;
        shared.kDownloadedMediaCount = @"appreview.downloaded-media";
        shared.kReviewRequestCount = @"appreview.request-count";
        shared.kLastReviewVesrion = @"appreview.last-version";
        [shared setup];
    });
    return shared;
}

- (void)setup {
    NSString *currentVersion = [self appVersion];
    NSString *lastReviewVersion = [self lastReviewVersion];
    
    if (![lastReviewVersion isEqualToString:currentVersion]) {
        [self resetMediaCount];
        [self resetReviewRequestCount];
        [self updateLastReviewVersion];
    }
}

- (void)didDownloadMedia {
    NSInteger mediaCount = [self downloadedMediaCount];
    [self.userDefaults setInteger:++mediaCount forKey:self.kDownloadedMediaCount];
}

- (NSInteger)downloadedMediaCount {
    return [self.userDefaults integerForKey:self.kDownloadedMediaCount];
}

- (void)requestReviewAlertIfNeeded {
    NSInteger mediaCount = [self downloadedMediaCount];
    NSInteger reviewCount = [self reviewRequestCount];
    reviewCount++;
    
    if (mediaCount >= 6 * reviewCount) {
        [SKStoreReviewController requestReview];
        [self incrementReviewRequestCount];
        [self resetMediaCount];
        [self updateLastReviewVersion];
    }
    
}

- (void)resetMediaCount {
    [self.userDefaults setInteger:0 forKey:self.kDownloadedMediaCount];
}

- (NSInteger)reviewRequestCount {
    return [self.userDefaults integerForKey:self.kReviewRequestCount];
}

- (void)resetReviewRequestCount {
    [self.userDefaults setInteger:0 forKey:self.kReviewRequestCount];
}

- (void)incrementReviewRequestCount {
    NSInteger reviewCount = [self reviewRequestCount];
    [self.userDefaults setInteger:++reviewCount forKey:self.kReviewRequestCount];
}

- (NSString *)lastReviewVersion {
    return [self.userDefaults stringForKey:self.kLastReviewVesrion];
}

- (void)updateLastReviewVersion {
    NSString *version = [self appVersion];
    return [self.userDefaults setObject:version forKey:self.kLastReviewVesrion];
}

- (NSString *)appVersion {
    return [NSBundle.mainBundle.infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
}

@end
