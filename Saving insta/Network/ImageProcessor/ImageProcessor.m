//
//  ImageLoader.m
//  Saving insta
//
//  Created by Igor Sorokin on 16.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "ImageProcessor.h"

@interface ImageProcessor ()

@property (nonatomic, nonnull) NSCache *cache;

@end

@implementation ImageProcessor

+ (instancetype)sharedProcessor {
    static ImageProcessor *sharedProcessor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProcessor = [[self alloc] init];
    });
    return sharedProcessor;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    
    return self;
}

- (void)loadImageURLString:(NSString *)urlString
              resizeToSize:(CGSize)size
     withCompletionHandler:(void (^)(UIImage *))completionHandler {
     
    if ([self.cache objectForKey:urlString]) {
        completionHandler([self.cache objectForKey:urlString]);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        if (!CGSizeEqualToSize(size, CGSizeZero)) {
            image = [self resizeImage:image toSize:size];
        }
        
        [self.cache setObject:image forKey:urlString];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(image);
        });
    });
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    CGFloat imageProportional;
    BOOL isPortrait = (image.size.height > image.size.width);
    if (isPortrait) {
        imageProportional = image.size.width / image.size.height;
    } else {
        imageProportional = image.size.height / image.size.width;
    }
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        if (isPortrait) {
            CGFloat width = size.width * imageProportional;
            CGFloat xOffset = (size.width - width) / 2;
            [image drawInRect:CGRectMake(xOffset, 0, width, size.height)];
        } else {
            CGFloat height = size.height * imageProportional;
            CGFloat yOffset = (size.height - height) / 2;
            [image drawInRect:CGRectMake(0, yOffset, size.width, height)];
        }
    }];
}

@end
