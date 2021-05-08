# MKAsyncLauncher


#具体使用
 、this、
 
    self.launcher = [[MKAsyncLauncher alloc] init];
    
    MKAsyncModel* firstModel = [MKAsyncModel modelWithPriority:1 useMultiThread:NO asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== firstModel");
        sleep(1);
    }];
    [_launcher addAsyncModel:firstModel];
    
    MKAsyncModel* secondModel = [MKAsyncModel modelWithPriority:2 useMultiThread:YES asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== secondModel");
        sleep(1);
    }];
    [_launcher addAsyncModel:secondModel];
    
    MKAsyncModel* secondModel1 = [MKAsyncModel modelWithPriority:2 useMultiThread:NO asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== secondModel1");
        sleep(1);
    }];
    [_launcher addAsyncModel:secondModel1];
    
    MKAsyncModel* thirdModel = [MKAsyncModel modelWithPriority:3 useMultiThread:YES asyncBlock:^{
        NSLog(@"MKAsyncLauncher: ==== thirdModel");
        sleep(1);
    }];
    [_launcher addAsyncModel:thirdModel];
    
    [_launcher start:^(NSArray * _Nonnull asyncSets) {
        NSLog(@"MKAsyncLauncher: ==== over");
    }];
