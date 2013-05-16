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
 
@interface MDAppDelegate : UIResponder <UIApplicationDelegate> {
    YaabUser *_user;
}

@property (strong, nonatomic) UIWindow *window;

@end
