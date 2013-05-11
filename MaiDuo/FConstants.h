//
//  FConstants.h
//  IDEAL
//
//  Created by 高 欣 on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LIGHT_BACKGROUND [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0]

#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b) RGBAColor(r,g,b,1.0)
#define DefaultNavigationTintColor  RGBColor(21,144,204)
#define DegreesToRadians(X) (M_PI * (x) / 180.0)
#define DeviceType @"1"
#define DeviceModel [NSString stringWithFormat:@"%@%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]]
#define Version [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DeviceToken @"devicetoken"

 

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_EN [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0] isEqualToString:@"en"]


#define RandomInt(from,to) (int)(from + (arc4random() % (to - from + 1)))

#if DEBUG
#define CLog(log, ...) NSLog((@"%s [Line %d] " log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define CLog(log, ...)
#endif
#define _ps(o) CLog(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) CLog(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.x, (o).size.width, (o).size.height)
#define COBJ(obj)  CLog(@"%s: %@", #obj, [(obj) description])

//extern NSString *const HttpServerURL;

extern NSString *const DefaultNavigationBackImage;//默认的NavigationBar背景图
 
 
extern NSString *const DefaultImage;//默认的下载图片图
#pragma mark -
#pragma mark NotificationKey
extern NSString *const DFNotificationUpdateMessage;
extern NSString *const DFNotificationHideLoading;
extern NSString *const DFNotificationShowLoading;
extern NSString *const DFNotificationHideTabBarMaskView;
extern NSString *const DFNotificationCloseAllFilter;
 