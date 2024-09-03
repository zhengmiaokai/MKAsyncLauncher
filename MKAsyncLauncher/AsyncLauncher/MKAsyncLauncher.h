//
//  MKAsyncLauncher.h
//  Basic
//
//  Created by mikazheng on 2021/5/7.
//  Copyright © 2021 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MKAsyncPriorityVeryLow  = -2,
    MKAsyncPriorityLow      = -1,
    MKAsyncPriorityDefault  = 0,
    MKAsyncPriorityHigh     = 1,
    MKAsyncPriorityVeryHigh = 2,
} MKAsyncPriority;

@interface MKAsyncTask : NSObject

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;

- (instancetype)initWithPriority:(MKAsyncPriority)priority
                  useMultiThread:(BOOL)useMultiThread handler:(void (^)(void))handler;

- (instancetype)initWithHandler:(void (^)(void))handler;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

@end

@interface MKAsyncLauncher : NSObject

- (void)addAsyncTask:(MKAsyncTask *)asyncTask;

- (void)start:(void (^)(NSArray* asyncSets))completionHandler;

@end

NS_ASSUME_NONNULL_END
