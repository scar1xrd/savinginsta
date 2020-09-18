//
//  AsyncOperation.m
//  Saving insta
//
//  Created by Igor Sorokin on 24.05.2020.
//  Copyright © 2020 Igor Sorokin. All rights reserved.
//

#import "AsyncOperation.h"

@interface AsyncOperation ()

@property (nonatomic, readwrite, getter=isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter=isFinished) BOOL finished;

@property (nonatomic, nonnull) dispatch_queue_t blockQueue;

@end

@implementation AsyncOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"executing"];
    dispatch_barrier_sync(self.blockQueue, ^{
        _executing = executing;
    });
    [self didChangeValueForKey:@"executing"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"finished"];
    dispatch_barrier_sync(self.blockQueue, ^{
        _finished = finished;
    });
    [self didChangeValueForKey:@"finished"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.blockQueue = dispatch_queue_create("asyncOperation.savinginsta.com", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)start {
    NSLog(@"Operation start");
    self.executing = YES;
    self.finished = NO;
    [self main];
}

- (void)finish {
    self.executing = NO;
    self.finished = YES;
    NSLog(@"Operation finish");
}

@end
