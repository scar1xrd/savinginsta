//
//  ImageLoader.h
//  Saving insta
//
//  Created by Igor Sorokin on 16.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageProcessor : NSObject

+ (instancetype)sharedProcessor;

- (void)loadImageURLString:(NSString *)urlString
              resizeToSize:(CGSize)size
     withCompletionHandler:(void (^)(UIImage *))completionHandler;

@end

NS_ASSUME_NONNULL_END
