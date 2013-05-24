//
//  AppDelegate.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YaabUser.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AFNetworking.h>
#import "MDUserManager.h"
#import "MDNotificationCenter.h"

@interface MDAppDelegate : UIResponder <UIApplicationDelegate> {
    YaabUser *_user;
    MDNotificationCenter *_notification;
    MDUserManager *_userManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UINavigationController *navigationController;
-(void) showHUDWithLabel:(NSString*) text;
-(void) hideHUD;
@end
