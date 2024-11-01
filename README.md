# MKAsyncLauncher

# 具体使用
```objective-c
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
```
