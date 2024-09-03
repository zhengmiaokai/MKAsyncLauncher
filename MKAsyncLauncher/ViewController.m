//
//  ViewController.m
//  MKAsyncLauncher
//
//  Created by zhengMK on 2021/5/7.
//  Copyright © 2021 zhengmiaokai. All rights reserved.
//

#import "ViewController.h"
#import "MKAsyncLauncher.h"

@interface ViewController ()

@property (nonatomic, strong) MKAsyncLauncher* launcher;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatLauncher];
}

#pragma mark - 异步启动器 -
- (void)creatLauncher {
    self.launcher = [[MKAsyncLauncher alloc] init];
    
    MKAsyncTask* highTask = [[MKAsyncTask alloc] initWithPriority:MKAsyncPriorityHigh useMultiThread:NO handler:^{
        NSLog(@"MKAsyncLauncher: high");
    }];
    [_launcher addAsyncTask:highTask];
    
    MKAsyncTask* veryLowTask = [[MKAsyncTask alloc] initWithPriority:MKAsyncPriorityVeryLow useMultiThread:YES handler:^{
        sleep(1);
        NSLog(@"MKAsyncLauncher: veryLow");
    }];
    [_launcher addAsyncTask:veryLowTask];
    
    MKAsyncTask* lowTask = [[MKAsyncTask alloc] initWithPriority:MKAsyncPriorityLow useMultiThread:YES handler:^{
        NSLog(@"MKAsyncLauncher: low");
    }];
    [_launcher addAsyncTask:lowTask];
    
    MKAsyncTask* veryHighTask = [[MKAsyncTask alloc] initWithPriority:MKAsyncPriorityVeryHigh useMultiThread:NO handler:^{
        NSLog(@"MKAsyncLauncher: veryHigh");
    }];
    [_launcher addAsyncTask:veryHighTask];
    
    MKAsyncTask* defaultTask = [[MKAsyncTask alloc] initWithPriority:MKAsyncPriorityDefault useMultiThread:YES handler:^{
        sleep(1);
        NSLog(@"MKAsyncLauncher: default");
    }];
    [_launcher addAsyncTask:defaultTask];
    
    [_launcher start:^(NSArray * _Nonnull asyncSets) {
        NSLog(@"MKAsyncLauncher: over");
    }];
}

@end
