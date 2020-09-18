//
//  MediaInfo.m
//  Saving insta
//
//  Created by Igor Sorokin on 14.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "PublicationInfo.h"

@implementation PublicationInfo

- (NSMutableArray *)media {
    if (!_media) _media = [[NSMutableArray alloc] init];
    return _media;
}

- (BOOL)isCarousel {
    return self.media.count == 1;
}

@end
