//
//  AppDelegate.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MaiDuo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AFNetworking.h>
#import "MDNotificationCenter.h"

@interface MDAppDelegate : UIResponder <UIApplicationDelegate> {
    MDNotificationCenter *_notification;
    MDUser *_user;
    MaiDuo *_maiduo;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UINavigationController *navigationController;
-(void) showHUDWithLabel:(NSString*) text;
-(void) hideHUD;
@end
