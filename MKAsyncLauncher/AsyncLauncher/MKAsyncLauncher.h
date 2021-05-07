//
//  MKAsyncLauncher.h
//  Basic
//
//  Created by mikazheng on 2021/5/7.
//  Copyright © 2021 zhengmiaokai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAsyncModel : NSObject

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;

+ (instancetype)modelWithPriority:(NSUInteger)priority useMultiThread:(BOOL)useMultiThread asyncBlock:(void (^)(void))asyncBlock;

+ (instancetype)modelWithAsyncBlock:(void (^)(void))asyncBlock;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

@end

@interface MKAsyncLauncher : NSObject

- (void)addAsyncModel:(MKAsyncModel *)asyncModel;

- (void)start:(void (^)(NSArray* asyncSets))completion;

@end

NS_ASSUME_NONNULL_END
