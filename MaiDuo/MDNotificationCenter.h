//
//  MDNotificationCenter.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-17.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDNotificationCenterDelegate.h"
#import "MDCache.h"

#define kDidReceiveMessage @"didReceiveMessage"
#define kDidReceiveChat @"didReceiveChat"
#define kDidReceiveActivity @"didReceiveActivity"

/** MDNotificationCenter 推送中心
 
 和NSNotificationCenter有很大的不同，MDNotificationCenter并不是单例类，主要是反序列化推
送的数据成为对象，并传递给NSNotificationCenter。
 
 MDAppDelegate.m
 
     - (void)application:(UIApplication *)application
     didReceiveRemoteNotification:(NSDictionary *)userInfo
     {
        // MDNotificationCenter
        [_notification post:userInfo];
     }
 
 ChatViewController.m
 
    - (void)pullReceiveChat:(id)sender
    {
        MDChat *chat = (MDChat *)[[sender userInfo] objectForKey:@"object"];
    }
 
    - (void)viewDidLoad {
         [[NSNotificationCenter defaultCenter] addObserver:self
          selector:@selector(pullReceiveChat:)
          name:kDidReceiveChat
          object:nil];
    }
 */
@interface MDNotificationCenter : NSObject {
    MDCache *_cache;
}

@property(strong) MDUser *user;
@property(strong) id<MDNotificationCenterDelegate> delegate;

-(id)initNotificationCenterWithUser:(MDUser *)aUser
                           delegate:(id<MDNotificationCenterDelegate>)aDelegate;

-(void)post:(NSDictionary *)userInfo;

+(MDNotificationCenter *)
notificationCenterWithUser:(MDUser *)aUser
delegate:(id<MDNotificationCenterDelegate>)aDelegate;
@end
