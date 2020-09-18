//
//  VideoLoader.m
//  Saving insta
//
//  Created by Igor Sorokin on 17.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "MediaSaverManager.h"

@interface MediaSaverManager ()
<
DownloadMediaOperationDelegate
>

@property (nonatomic, nonnull) NSOperationQueue *operationQueue;
@property (nonatomic, nonnull) NSURLSession *session;
@property (nonatomic, nonnull) NSCache *imageCache;
@property (nonatomic, nonnull) NSURL *documentsDirectory;

@property (assign, nonatomic) NSUInteger totalMedia;

@end

@implementation MediaSaverManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
        self.documentsDirectory = [[NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory
                                                                          inDomains:NSUserDomainMask] firstObject];
        self.imageCache = [[NSCache alloc] init];
        self.totalMedia = 0;
    }
    return self;
}

- (void)downloadMedia:(NSArray *)mediaArray {
    self.totalMedia = mediaArray.count;
    
    NSMutableArray *operationArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < mediaArray.count; i++) {
        MediaInfo *media = [mediaArray objectAtIndex:i];
        DownloadMediaOperation *operation = [self createOperationForMedia:media atIndex:i];
        if (operationArray.count > 0) {
            [operation addDependency:operationArray.lastObject];
        }
        [operationArray addObject:operation];
    }
    
    [self.operationQueue addOperations:operationArray waitUntilFinished:NO];
}

- (DownloadMediaOperation *)createOperationForMedia:(MediaInfo *)media atIndex:(NSUInteger)index {
    DownloadMediaOperation *operation = [[DownloadMediaOperation alloc] init];
    operation.session = self.session;
    operation.documentsDirectory = self.documentsDirectory;
    operation.imageCache = self.imageCache;
    operation.media = media;
    operation.delegate = self;
    operation.mediaIndex = index;
    operation.onErrorHandler = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.operationQueue cancelAllOperations]; // TODO:
            [self.delegate mediaSaverDidReceiveError:error];
        });
    };
    return operation;
}

#pragma mark - DownloadMediaOperationDelegate

- (void)downloadMediaOperationDownloadingProgressUpdated:(NSNumber *)progress atMediaIndex:(NSUInteger)index {
    NSNumber *totalDownload = [NSNumber numberWithFloat:(progress.floatValue + index)];
    NSNumber *downloadPercentage = [NSNumber numberWithFloat:(totalDownload.floatValue / self.totalMedia)];
    DownloadMediaProgress downloadProgress = DownloadMediaProgressMakeProgress(index + 1, self.totalMedia, downloadPercentage);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate mediaSaverDownloadingMedia:downloadProgress];
    });
}

- (void)downloadMediaOperationWillSavingMediaAtIndex:(NSUInteger)index {
    NSNumber *downloadPercentage = [NSNumber numberWithFloat:(((float)index + 1) / (float)self.totalMedia)];
    DownloadMediaProgress downloadProgress = DownloadMediaProgressMakeProgress(index + 1, self.totalMedia, downloadPercentage);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate mediaSaverWillSaveMedia:downloadProgress];
    });
}

- (void)downloadMediaOperationDidSaveMediaAtIndex:(NSUInteger)index {
    if (index + 1 == self.totalMedia) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mediaSaverCompleteDownloading];
        });
    }
}

@end
