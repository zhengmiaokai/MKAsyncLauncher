# MKAsyncLauncher

# 具体使用
```objective-c
self.launcher = [[MKAsyncLauncher alloc] init];
    
MKAsyncTask* highTask = [[MKAsyncTask alloc] initWithPriority:MKAsyncPriorityHigh useMultiThread:NO handler:^{
    sleep(1);
    NSLog(@"MKAsyncLauncher: high");
}];
[_launcher addAsyncTask:highTask];

    
MKAsyncTask* lowTask = [[MKAsyncTask alloc] initWithPriority:MKAsyncPriorityLow useMultiThread:YES handler:^{
    sleep(1);
    NSLog(@"MKAsyncLauncher: low");
}];
[_launcher addAsyncTask:lowTask];
    
MKAsyncTask* defaultTask = [[MKAsyncTask alloc] initWithPriority:MKAsyncPriorityDefault useMultiThread:YES handler:^{
    sleep(1);
    NSLog(@"MKAsyncLauncher: default");
}];
[_launcher addAsyncTask:defaultTask];
    
[_launcher start:^(NSArray * _Nonnull asyncSets) {
    NSLog(@"MKAsyncLauncher: over");
}];
```
