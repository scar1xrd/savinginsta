//
//  DownloadMapper.m
//  Saving insta
//
//  Created by Igor Sorokin on 14.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "DownloadMapper.h"

@implementation DownloadMapper

- (PublicationInfo *)mapPublicationInfoFromData:(NSData *) data {
    
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (error) @throw [NSException exceptionWithName:@"Mapping exception (DownloadMapper)"
                                              reason:error.localizedDescription
                                            userInfo:error.userInfo];
    
    NSArray *captions = [dict valueForKeyPath:@"graphql.shortcode_media.edge_media_to_caption.edges"];
    NSArray *childrens = [dict valueForKeyPath:@"graphql.shortcode_media.edge_sidecar_to_children.edges"];
    
    PublicationInfo *publication = [[PublicationInfo alloc] init];
    publication.mediaDescription = [((NSDictionary *) captions.firstObject)valueForKeyPath:@"node.text"];
    
    if (childrens) {
        [self mapChildrens:childrens toPublication:publication];
    } else {
        [self mapSingleMedia:dict toPublication:publication];
    }
    
    if (!publication.media.count) {
        @throw [NSException exceptionWithName:@"Mapping exception (DownloadMapper)"
                                       reason:@"Не удалось загрузить пост\nВозможно вы пытаетесь загрузить пост из закрытого аккаунта"
                                     userInfo:nil];
    }
    
    return publication;
}

- (void)mapChildrens:(NSArray *)childrens toPublication:(PublicationInfo *) publication {
    
    for (NSDictionary *child in childrens) {
        NSNumber *isVideo = [child valueForKeyPath:@"node.is_video"];
        
        MediaInfo *media = [[MediaInfo alloc] init];
        media.previewURLString = [child valueForKeyPath:@"node.display_url"];
        media.isVideo = isVideo;
        
        if (isVideo.boolValue) {
            media.contentURLString = [child valueForKeyPath:@"node.video_url"];
        } else {
            media.contentURLString = [child valueForKeyPath:@"node.display_url"];
        }
        
        if (media.contentURLString && media.previewURLString) {
            [publication.media addObject:media];
        }
    }
    
}

- (void)mapSingleMedia:(NSDictionary *)dict toPublication:(PublicationInfo *) publication {
    NSNumber *isVideo = [dict valueForKeyPath:@"graphql.shortcode_media.is_video"];
    
    MediaInfo *media = [[MediaInfo alloc] init];
    media.previewURLString = [dict valueForKeyPath:@"graphql.shortcode_media.display_url"];
    media.isVideo = isVideo;
    
    if (isVideo.boolValue) {
        media.contentURLString = [dict valueForKeyPath:@"graphql.shortcode_media.video_url"];
    } else {
        media.contentURLString = [dict valueForKeyPath:@"graphql.shortcode_media.display_url"];
    }
    
    if (media.contentURLString && media.previewURLString) {
        [publication.media addObject:media];
    }
}

@end
