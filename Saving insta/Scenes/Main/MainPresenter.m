//
//  MainPresenter.m
//  Saving insta
//
//  Created by Igor Sorokin on 24.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "MainPresenter.h"
#import "MediaSaverManager.h"
#import "DownloadMapper.h"
#import "ImageProcessor.h"
#import "DownloadMediaProgress.h"
#import "UIViewController+Utils.h"
#import "AppReviewManager.h"

@interface MainPresenter ()
<
MediaSaverDelegate
>

@property (weak, nonatomic) MainViewController* viewController;
@property (nonatomic, nonnull) MediaSaverManager *mediaSaver;
@property (nonatomic, readwrite, nullable) PublicationInfo *publication;
@property (nonatomic) DownloadMapper *mapper;

@end

@implementation MainPresenter

- (instancetype)initViewController:(MainViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.mapper = [[DownloadMapper alloc] init];
        self.mediaSaver = [[MediaSaverManager alloc] init];
        self.mediaSaver.delegate = self;
        self.mediaQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadPublicationFromURLString:(NSString *) urlString {
    [self.viewController showLoadingState];
    NSURL *url = [self buildURLFromString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController showNormalState];
                [self.viewController showAlert:@"Ошибка" message:error.localizedDescription completionHandler:nil];
            });
            return;
        }
        
        @try {
            PublicationInfo *publication = [self.mapper mapPublicationInfoFromData:data];
            self.publication = publication;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mediaQueue removeAllObjects];
                [self.viewController showNormalState];
                [self.viewController updatePublicationAndCaption:self.publication.mediaDescription];
            });
        } @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController showNormalState];
                [self.viewController showAlert:@"Ошибка" message:exception.reason completionHandler:nil];
            });
        }
        
    }] resume];
    
}

- (NSURL *)buildURLFromString:(NSString *) urlString {
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    if (components.query) {
        NSURL *url = [NSURL URLWithString:[urlString stringByAppendingString:@"&__a=1"]];
        return url;
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAppendingString:@"?__a=1"]];
    return url;
}

- (BOOL)canDownloadPasteboardTextFieldText:(NSString *)text {
    BOOL isAutodownload = [NSUserDefaults.standardUserDefaults boolForKey:@"is_autodownload"];
    
    if (!isAutodownload) {
        return NO;
    }
    
    if (UIPasteboard.generalPasteboard.string == nil) {
        return NO;
    }
    
    NSString *pasteboard = [NSString stringWithString:UIPasteboard.generalPasteboard.string];
    
    if (pasteboard) {
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
                                                                     options:0 error:&error];
        BOOL isValidLink = ([[regex matchesInString:pasteboard options:0 range:NSMakeRange(0, [pasteboard length])] count] > 0);
        return isValidLink && ![text isEqualToString:pasteboard];
    }
    
    return NO;
}

- (void)copyToPasteboardCaption:(NSString *)caption {
    UIPasteboard.generalPasteboard.string = caption;
    [self.viewController showAlert:@"" message:@"Описание успешно скопировано!" completionHandler:nil];
}

- (void)addObjectToQueueAtIndex:(NSUInteger)index {
    [self.mediaQueue addObject:self.publication.media[index]];
}

- (void)removeObjectFromQueueAtIndex:(NSUInteger)index {
    [self.mediaQueue removeObject:self.publication.media[index]];
}

- (void)saveMediaFromQueue {
    if (self.mediaQueue.count == 0) {
        [self.viewController showAlert:@"" message:@"Выберите фото или видео" completionHandler:nil];
    } else {
        [self.mediaSaver downloadMedia:self.mediaQueue];
    }
}

#pragma mark - Download Image

- (void)loadImageURLString:(NSString *)urlString
              resizeToSize:(CGSize)size
     withCompletionHandler:(void (^)(UIImage *))completionHandler {
    [ImageProcessor.sharedProcessor loadImageURLString:urlString
                                          resizeToSize:size
                                 withCompletionHandler:completionHandler];
}

#pragma mark - MediaSaverDelegate

- (void)mediaSaverWillSaveMedia:(DownloadMediaProgress)progress {
    NSString *labelStatus = [NSString stringWithFormat:@"Cохраняю %lu из %lu",
                             (unsigned long)progress.index,
                             (unsigned long)progress.total];
    [self.viewController showProgressHudStatus:labelStatus progress:progress.progress];
}

- (void)mediaSaverDownloadingMedia:(DownloadMediaProgress)progress {
    NSString *labelStatus = [NSString stringWithFormat:@"Загружаю %lu из %lu",
                             (unsigned long)progress.index,
                             (unsigned long)progress.total];
    [self.viewController showProgressHudStatus:labelStatus progress:progress.progress];
}

- (void)mediaSaverCompleteDownloading {
    [self.viewController hideProgressHud];
    [self.viewController showSuccessHUD:@"Cохранено"];
    [AppReviewManager.shared didDownloadMedia];
    [AppReviewManager.shared requestReviewAlertIfNeeded];
}

- (void)mediaSaverDidReceiveError:(NSError *)error {
    // TODO:
}

@end
