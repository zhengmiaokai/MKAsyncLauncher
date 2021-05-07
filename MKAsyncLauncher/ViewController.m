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
    
    [self creatLauncher];
}

#pragma mark - 异步启动器 -
- (void)creatLauncher {
    self.launcher = [[MKAsyncLauncher alloc] init];
    
    MKAsyncModel* test1 = [MKAsyncModel modelWithPriority:3 useMultiThread:NO asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== test1");
        sleep(1);
    }];
    [_launcher addAsyncModel:test1];
    
    MKAsyncModel* test2 = [MKAsyncModel modelWithPriority:3 useMultiThread:YES asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== test2");
        sleep(1);
    }];
    [_launcher addAsyncModel:test2];
    
    MKAsyncModel* test3 = [MKAsyncModel modelWithPriority:2 useMultiThread:NO asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== test3");
        sleep(1);
    }];
    [_launcher addAsyncModel:test3];
    
    MKAsyncModel* test4 = [MKAsyncModel modelWithPriority:2 useMultiThread:YES asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== test4");
        sleep(1);
    }];
    [_launcher addAsyncModel:test4];
    
    MKAsyncModel* test5 = [MKAsyncModel modelWithPriority:1 useMultiThread:YES asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== test5");
        sleep(1);
    }];
    [_launcher addAsyncModel:test5];
    
    MKAsyncModel* test6 = [MKAsyncModel modelWithPriority:0 useMultiThread:YES asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== test6");
        sleep(1);
    }];
    [_launcher addAsyncModel:test6];
    
    [_launcher start:^(NSArray * _Nonnull asyncSets) {
        NSLog(@"MKAsyncLauncher: ==== over");
    }];
}

@end
