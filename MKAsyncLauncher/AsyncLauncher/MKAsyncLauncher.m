//
//  MKAsyncLauncher.m
//  Basic
//
//  Created by mikazheng on 2021/5/7.
//  Copyright © 2021 zhengmiaokai. All rights reserved.
//

#import "MKAsyncLauncher.h"

@interface MKAsyncTask ()

@property (nonatomic, assign) MKAsyncPriority priority;   // default: 0
@property (nonatomic, assign) BOOL useMultiThread;        // default: NO
@property (nonatomic, copy) void (^handler)(void);

@property (nonatomic, copy) NSString* identify;

@end

@implementation MKAsyncTask

- (instancetype)initWithPriority:(MKAsyncPriority)priority useMultiThread:(BOOL)useMultiThread handler:(void (^)(void))handler {
    self = [super init];
    if (self) {
        self.priority = priority;
        self.useMultiThread = useMultiThread;
        self.handler = handler;
    }
    return self;
}

- (instancetype)initWithHandler:(void (^)(void))handler {
    return [self initWithPriority:MKAsyncPriorityDefault useMultiThread:NO handler:handler];
}

@end

@interface MKAsyncLauncher ()

@property (nonatomic, strong) NSMutableArray* asyncSets;
@property (nonatomic, strong) NSMutableDictionary* prioritySets;

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, copy) void (^completionHandler)(NSArray *asyncSets);

@end

@implementation MKAsyncLauncher

- (instancetype)init {
    self = [super init];
    if (self) {
        self.asyncSets = [NSMutableArray array];
        self.prioritySets = [NSMutableDictionary dictionary];
        self.group = dispatch_group_create();
        self.queue = dispatch_queue_create("LAUNCH_CONCURRENT_QUEUE", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)addAsyncTask:(MKAsyncTask *)asyncTask {
    if (asyncTask) {
        asyncTask.identify = [NSString stringWithFormat:@"%lu", (unsigned long)_asyncSets.count];
        [_asyncSets addObject:asyncTask];
        
        NSMutableArray* priorityArr = [_prioritySets objectForKey:@(asyncTask.priority)];
        if (priorityArr) {
            [priorityArr addObject:asyncTask];
        } else {
            priorityArr = [NSMutableArray array];
            [priorityArr addObject:asyncTask];
            [_prioritySets setObject:priorityArr forKey:@(asyncTask.priority)];
        }
    }
}

- (void)start:(void (^)(NSArray* asyncSets))completionHandler {
    self.completionHandler = completionHandler;
    
    if (_prioritySets.count > 0) {
        NSArray* allKeys = [[_prioritySets allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull obj1, NSNumber*  _Nonnull obj2) {
            if (obj1.intValue > obj2.intValue) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        [self taskSettings:allKeys index:0];
    } else {
        if (_completionHandler) {
            _completionHandler(_asyncSets);
        }
    }
}

- (void)taskSettings:(NSArray *)allKeys index:(NSInteger)index {
    if (allKeys.count <= index) { // 结束递归
        if (_completionHandler) {
            _completionHandler(_asyncSets);
        }
        return;
    }
    
    NSNumber* priorityKey = [allKeys objectAtIndex:index];
    NSArray* priorityArr = [_prioritySets objectForKey:priorityKey];
    
    for (MKAsyncTask* asyncTask in priorityArr) {
        void (^block)(void) = ^{
            asyncTask.startTime = [[NSDate date] timeIntervalSince1970];
            asyncTask.handler();
            asyncTask.endTime = [[NSDate date] timeIntervalSince1970];
        };
        
        if (asyncTask.useMultiThread == NO) {
            dispatch_group_async(_group, dispatch_get_main_queue(), block);
        } else {
            dispatch_group_async(_group, _queue, block);
        }
    }
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        [self taskSettings:allKeys index:index + 1];
    });
}

@end
