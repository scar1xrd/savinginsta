//
//  DownloadMediaOperation.h
//  Saving insta
//
//  Created by Igor Sorokin on 24.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncOperation.h"
#import "MediaInfo.h"
#import "DownloadMediaProgress.h"

@protocol DownloadMediaOperationDelegate <NSObject>

- (void)downloadMediaOperationWillSavingMediaAtIndex:(NSUInteger)index;
- (void)downloadMediaOperationDidSaveMediaAtIndex:(NSUInteger)index;
- (void)downloadMediaOperationDownloadingProgressUpdated:(NSNumber *_Nonnull)progress atMediaIndex:(NSUInteger)index;

@end

/*
 Initialize operation with properties needs for init
 operation automatically check if media has in cache
 if not it will download it
*/
@interface DownloadMediaOperation : AsyncOperation

// needs for init
@property (assign, nonatomic) NSUInteger mediaIndex;
@property (weak, nonatomic, nullable) NSURLSession * session;
@property (weak, nonatomic, nullable) NSCache *imageCache;
@property (weak, nonatomic, nullable) NSURL *documentsDirectory;
@property (weak, nonatomic, nullable) MediaInfo *media;
@property (copy, nonnull) void (^onErrorHandler)(NSError *_Nonnull);

@property (weak, nonatomic, nullable) id <DownloadMediaOperationDelegate> delegate;

@end
