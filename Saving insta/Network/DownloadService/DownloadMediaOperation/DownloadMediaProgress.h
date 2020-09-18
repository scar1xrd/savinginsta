//
//  DownloadMediaProgress.h
//  Saving insta
//
//  Created by Igor Sorokin on 24.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

struct DownloadMediaProgress {
    NSUInteger index;
    NSUInteger total;
    NSNumber *progress;
};

typedef struct DownloadMediaProgress DownloadMediaProgress;

CG_INLINE DownloadMediaProgress DownloadMediaProgressMakeProgress(NSUInteger index, NSUInteger total, NSNumber *progress) {
    DownloadMediaProgress downloadProgress;
    downloadProgress.index = index;
    downloadProgress.total = total;
    downloadProgress.progress = progress;
    return downloadProgress;
}
