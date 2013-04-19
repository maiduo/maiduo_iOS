//
//  AppDelegate.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UITableViewController*  latestView;
    UINavigationController* navigation;
}

@property (strong, nonatomic) UIWindow *window;

@end
