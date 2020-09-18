//
//  DownloadMediaOperation.m
//  Saving insta
//
//  Created by Igor Sorokin on 24.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <Photos/Photos.h>

#import "DownloadMediaOperation.h"

@implementation DownloadMediaOperation

- (void)main {
    if (self.media.isVideo.boolValue) {
        [self downloadVideoFromPath:self.media.contentURLString withCompletionHandler:^(NSURL *url) {
            NSLog(@"Operation did receive video");
            [self.delegate downloadMediaOperationWillSavingMediaAtIndex:self.mediaIndex];
            [self saveVideoMedia:url];
        }];
    } else {
        [self downloadImageFromPath:self.media.contentURLString withCompletionHandler:^(UIImage *image) {
            NSLog(@"Operation did receive image");
            [self.delegate downloadMediaOperationWillSavingMediaAtIndex:self.mediaIndex];
            [self saveImageMedia:image];
        }];
    }
}

#pragma mark - Downloading

- (void)downloadVideoFromPath:(NSString *)urlString
        withCompletionHandler:(void(^)(NSURL *))completionHandler {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *fileName = [[urlString componentsSeparatedByString:@"="] lastObject];
    NSString *document = [NSString stringWithFormat:@"%@%@", fileName, @".mov"];
    NSURL *destinationURL = [[self documentsDirectory] URLByAppendingPathComponent:document];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:destinationURL.absoluteString]) {
        completionHandler(destinationURL);
        return;
    }
    
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url
                     completionHandler:^(NSURL * _Nullable location,
                                         NSURLResponse * _Nullable response,
                                         NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        [data writeToURL:destinationURL atomically:YES];
        completionHandler(destinationURL);
    }];
    
    [task.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    [task resume];
}

- (void)downloadImageFromPath:(NSString *)urlString
             withCompletionHandler:(void (^)(UIImage *))completionHandler {
    
    if ([self.imageCache objectForKey:urlString]) {
        completionHandler([self.imageCache objectForKey:urlString]);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url
                     completionHandler:^(NSURL * _Nullable location,
                                         NSURLResponse * _Nullable response,
                                         NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        completionHandler(image);
    }];
    
    [task.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    [task resume];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"fractionCompleted"]) {
        NSNumber *progress = change[@"new"];
        NSLog(@"PROGRESS: %.1f", progress.floatValue);
        
        [self.delegate downloadMediaOperationDownloadingProgressUpdated:progress atMediaIndex:self.mediaIndex];
    }
}

#pragma mark - Save photo

- (void)saveImageMedia:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        self.onErrorHandler(error);
    }
    
    [self.delegate downloadMediaOperationDidSaveMediaAtIndex:self.mediaIndex];
    [self finish];
}

#pragma mark - Save video

- (void)saveVideoMedia:(NSURL *)videoURL {
    NSError *error;
    [PHPhotoLibrary.sharedPhotoLibrary performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
    } error:&error];
    
    if (error) {
        self.onErrorHandler(error);
    }
    
    [self.delegate downloadMediaOperationDidSaveMediaAtIndex:self.mediaIndex];
    [self finish];
}

@end
