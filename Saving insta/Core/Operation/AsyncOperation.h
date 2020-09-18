//
//  AsyncOperation.h
//  Saving insta
//
//  Created by Igor Sorokin on 24.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsyncOperation : NSOperation {
    @private
    BOOL _executing;
    BOOL _finished;
}

- (void)finish;

@end

NS_ASSUME_NONNULL_END
