//
//  AppDelegate.m
//  WXReactiveCocoaDemo
//
//  Created by WX on 16/11/28.
//  Copyright © 2016年 WXmozhuxuanke. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
//    [self lyh_setThreeLibKey];
    return YES;
    return YES;
}
/** 设置第三方库的key */
- (void)lyh_setThreeLibKey
{
    [UMSocialData setAppKey:YM_Share_App_Key];
    // 微信
    [UMSocialWechatHandler setWXAppId:@"微信 APP_Id"
                            appSecret:@"微信 APP_Secret"
                                  url:@"http://www.umeng.com/social"];
    // 新浪
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"微博 APP_Id"
                                              secret:@"微博 APP_Secret"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    // QQ和QQ空间
    [UMSocialQQHandler setQQWithAppId:@"QQ_APP_Id"
                               appKey:@"QQ_APP_Key"
                                  url:@"http://www.umeng.com/social"];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
