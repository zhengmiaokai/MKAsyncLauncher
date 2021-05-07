//
//  MKAsyncLauncher.m
//  Basic
//
//  Created by mikazheng on 2021/5/7.
//  Copyright © 2021 zhengmiaokai. All rights reserved.
//

#import "MKAsyncLauncher.h"

@interface MKAsyncModel ()

@property (nonatomic, assign) NSUInteger priority;  /// default 1, 1优先级最大，1+逐步递减
@property (nonatomic, assign) BOOL useMultiThread;     /// default NO, 是否在子线程执行
@property (nonatomic, copy) void (^asyncBlock)(void);

@property (nonatomic, copy) NSString* identify;

@end

@implementation MKAsyncModel

+ (instancetype)modelWithPriority:(NSUInteger)priority useMultiThread:(BOOL)useMultiThread asyncBlock:(void (^)(void))asyncBlock {
    MKAsyncModel* model = [[MKAsyncModel alloc] init];
    model.priority = priority;
    model.useMultiThread = useMultiThread;
    model.asyncBlock = asyncBlock;
    return model;
}

+ (instancetype)modelWithAsyncBlock:(void (^)(void))asyncBlock {
    return [self modelWithPriority:1 useMultiThread:NO asyncBlock:asyncBlock];
}

@end

@interface MKAsyncLauncher ()

@property (nonatomic, strong) NSMutableArray* asyncSets;
@property (nonatomic, strong) NSMutableDictionary* prioritySets;

@property (nonatomic, strong) dispatch_group_t gcdGroup;
@property (nonatomic, strong) dispatch_queue_t gcdQueue;

@property (nonatomic, copy) void (^completion)(NSArray *asyncSets);

@end

@implementation MKAsyncLauncher

- (instancetype)init {
    self = [super init];
    if (self) {
        self.asyncSets = [NSMutableArray array];
        self.prioritySets = [NSMutableDictionary dictionary];
        self.gcdGroup = dispatch_group_create();
        self.gcdQueue = dispatch_queue_create("LAUNCH_CONCURRENT_QUEUE", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)addAsyncModel:(MKAsyncModel *)asyncModel {
    if (asyncModel) {
        asyncModel.identify = [NSString stringWithFormat:@"%lu", (unsigned long)_asyncSets.count];
        [_asyncSets addObject:asyncModel];
        
        NSMutableArray* priorityArr = [_prioritySets objectForKey:@(asyncModel.priority)];
        if (priorityArr) {
            [priorityArr addObject:asyncModel];
        } else {
            priorityArr = [NSMutableArray array];
            [priorityArr addObject:asyncModel];
            [_prioritySets setObject:priorityArr forKey:@(asyncModel.priority)];
        }
    }
}

- (void)start:(void (^)(NSArray* asyncSets))completion {
    self.completion = completion;
    
    if (_prioritySets.count > 0) {
        NSArray* allKeys = [[_prioritySets allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull obj1, NSNumber*  _Nonnull obj2) {
            if (obj1.intValue < obj2.intValue) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        [self taskSettings:allKeys index:0];
    } else {
        if (_completion) {
            _completion(_asyncSets);
        }
    }
}

- (void)taskSettings:(NSArray *)allKeys index:(NSInteger)index {
    if (allKeys.count <= index) { /// 结束递归
        if (_completion) {
            _completion(_asyncSets);
        }
        return;
    }
    
    NSNumber* priorityKey = [allKeys objectAtIndex:index];
    NSArray* priorityArr = [_prioritySets objectForKey:priorityKey];
    
    for (MKAsyncModel* asyncModel in priorityArr) {
        void (^block)(void) = ^{
            asyncModel.startTime = [[NSDate date] timeIntervalSince1970];
            asyncModel.asyncBlock();
            asyncModel.endTime = [[NSDate date] timeIntervalSince1970];
        };
        
        if (asyncModel.useMultiThread == NO) {
            dispatch_group_async(_gcdGroup, dispatch_get_main_queue(), block);
        } else {
            dispatch_group_async(_gcdGroup, _gcdQueue, block);
        }
    }
    
    dispatch_group_notify(_gcdGroup, dispatch_get_main_queue(), ^{
        [self taskSettings:allKeys index:index + 1];
    });
}

@end
