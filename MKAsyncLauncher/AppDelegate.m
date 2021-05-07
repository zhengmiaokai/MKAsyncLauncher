//
//  AppDelegate.m
//  MKAsyncLauncher
//
//  Created by zhengMK on 2021/5/7.
//  Copyright © 2021 zhengmiaokai. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
       
    ViewController* vc = [[ViewController alloc] init];
    
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

@end
