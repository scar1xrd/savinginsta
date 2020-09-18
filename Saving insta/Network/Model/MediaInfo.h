//
//  MediaInfo.h
//  Saving insta
//
//  Created by Igor Sorokin on 14.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaInfo : NSObject

@property (nonatomic) NSString *previewURLString;
@property (nonatomic) NSString *contentURLString;
@property (nonatomic) NSNumber *isVideo;

@end

NS_ASSUME_NONNULL_END
