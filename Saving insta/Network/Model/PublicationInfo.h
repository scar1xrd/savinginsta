//
//  MediaInfo.h
//  Saving insta
//
//  Created by Igor Sorokin on 14.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicationInfo : NSObject

@property (nonatomic, nullable) NSString *mediaDescription;
@property (nonatomic, nonnull) NSMutableArray *media; // MediaInfo

- (BOOL)isCarousel;

@end
