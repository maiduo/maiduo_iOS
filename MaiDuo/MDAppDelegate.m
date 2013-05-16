//
//  AppDelegate.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDAppDelegate.h"
#import "MDLatestViewController.h"
#import "MDSendMessageViewController.h"
#import "MDLoginViewController.h"
#import "MDUserManager.h"
#import "MDHTTPAPI.h"
#import "iToast.h"

@interface MDAppDelegate() <MDLoginViewControllerDelegate>

@end

@implementation MDAppDelegate

- (void)setUp
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|
      UIRemoteNotificationTypeSound)];
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUp];
    
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[MDUserManager sharedInstance] userSessionValid]) {
        MDUser *user=[[MDUserManager sharedInstance] getUserSession];
        [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
            MDLatestViewController *latestVC = [[MDLatestViewController alloc] init];
            _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:latestVC];
        } failure:^(NSError *error) {
            [[error userInfo] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSLog(@"%@", [[error userInfo] objectForKey:key]);
            }];
            [[[iToast makeText:@"登录失败!"] setGravity:iToastGravityCenter] show];
        }];
 
    } else {
        MDLoginViewController *loginVC = [[MDLoginViewController alloc]  initWithStyle:UITableViewStyleGrouped];
        loginVC.delegate = self;
        _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    
    [self.window makeKeyAndVisible];
    
    _user = [YaabUser sharedInstance];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [_user getDeviceTokenWithData:deviceToken];
    
    if ([token isEqualToString:[_user deviceToken]])
        return;

    [_user setDeviceToken:token];
    
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

- (void)loginViewControllerDidLogin:(MDLoginViewController *)loginViewController
{
    MDLatestViewController *latestVC = [[MDLatestViewController alloc] init];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:latestVC];
}

@end
