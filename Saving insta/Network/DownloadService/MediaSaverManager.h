//
//  VideoLoader.h
//  Saving insta
//
//  Created by Igor Sorokin on 17.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadMediaOperation.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MediaSaverDelegate <NSObject>

- (void)mediaSaverWillSaveMedia:(DownloadMediaProgress)progress;
- (void)mediaSaverDownloadingMedia:(DownloadMediaProgress)progress;
- (void)mediaSaverDidReceiveError:(NSError *)error;
- (void)mediaSaverCompleteDownloading;

@end



@interface MediaSaverManager : NSObject

@property (weak, nonatomic, nullable) id <MediaSaverDelegate> delegate;

- (void)downloadMedia:(NSArray *)mediaArray; // Media Info

@end

NS_ASSUME_NONNULL_END
