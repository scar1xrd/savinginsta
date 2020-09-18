//
//  DownloadMapper.h
//  Saving insta
//
//  Created by Igor Sorokin on 14.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PublicationInfo.h"
#import "MediaInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadMapper : NSObject

- (PublicationInfo *)mapPublicationInfoFromData:(NSData *) data;

@end

NS_ASSUME_NONNULL_END
