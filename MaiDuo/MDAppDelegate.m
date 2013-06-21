//
//  AppDelegate.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDAppDelegate.h"
#import "MDLatestViewController.h"
#import "MDWriteMessageViewController.h"
#import "MDLoginViewController.h"
#import "MDHTTPAPI.h"
#import "iToast.h"
#import "MBProgressHUD.h"


@interface MDAppDelegate() <MDLoginViewControllerDelegate>{
    MBProgressHUD *_HUD;
}

@end

@implementation MDAppDelegate

- (void)setUp
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|
      UIRemoteNotificationTypeSound)];
    
    _maiduo = [MaiDuo sharedInstance];
    _user = [_maiduo user];
    
    if (nil == _notification) {
        _notification = [MDNotificationCenter
                         notificationCenterWithUser:_user
                         delegate:nil];
    }
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUp];
    
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([_user isValid]) {
        // 只需要登陆一次
        // API使用user.accessToken保存用户状态
        
        // 直接进入活动列表并刷新
        // FIXME 这里的逻辑应该是进入活动列表，并自动刷新。
        MDLatestViewController *latestViewController;
        latestViewController = [[MDLatestViewController alloc] init];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:latestViewController];
         
//        [self.navigationController initWithRootViewController:latestViewController];
//                                     initWithRootViewController:latestViewController];

    } else {
        MDLoginViewController *loginViewController;
        loginViewController = [[MDLoginViewController alloc]
                               initWithStyle:UITableViewStyleGrouped];
        self.navigationController = [[UINavigationController alloc]
                                     initWithRootViewController:loginViewController];
    }
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    _maiduo = [MaiDuo sharedInstance];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [_maiduo getDeviceTokenWithData:deviceToken];
    
    if ([token isEqualToString:[_maiduo deviceToken]])
        return;

    [_maiduo setDeviceToken:token];
    
    NSString *registerTokenURL;
    registerTokenURL = @"https://himaiduo.com/aps/device/";
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          token, @"token", @"1", @"service", nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc]
                                    initWithBaseURL:[NSURL URLWithString:@"https://himaiduo.com/aps/"]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"device/" parameters:data];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", [JSON objectForKey:@"token"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error);
    }];
    [operation start];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [_notification post:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) showHUDWithLabel:(NSString*) text
{
    if(!_HUD){
        _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
	[self.navigationController.view addSubview:_HUD];
	_HUD.labelText = text;
    [_HUD show:YES];
}
-(void) hideHUD
{
    [_HUD hide:YES];
    [_HUD removeFromSuperview];
}

@end
