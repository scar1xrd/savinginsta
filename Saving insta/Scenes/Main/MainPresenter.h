//
//  MainPresenter.h
//  Saving insta
//
//  Created by Igor Sorokin on 24.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MediaInfo.h"
#import "PublicationInfo.h"
#import "MainViewController.h"

@interface MainPresenter : NSObject

@property (nonatomic, nullable, readonly) PublicationInfo *publication;
@property (nonatomic, nonnull) NSMutableArray *mediaQueue;

NS_ASSUME_NONNULL_BEGIN

- (instancetype)initViewController:(MainViewController *)viewController;

- (BOOL)canDownloadPasteboardTextFieldText:(NSString *)text;
- (void)loadPublicationFromURLString:(NSString *)url;
- (void)saveMediaFromQueue;
- (void)copyToPasteboardCaption:(NSString *)caption;

- (void)addObjectToQueueAtIndex:(NSUInteger)index;
- (void)removeObjectFromQueueAtIndex:(NSUInteger)index;

- (void)loadImageURLString:(NSString *)urlString
              resizeToSize:(CGSize)size
     withCompletionHandler:(void (^)(UIImage *))completionHandler;

@end

NS_ASSUME_NONNULL_END
