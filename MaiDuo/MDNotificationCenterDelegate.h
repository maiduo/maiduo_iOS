//
//  MDNotificationCenterDelegate.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-16.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDActivity.h"

@protocol MDNotificationCenterDelegate <NSObject>

-(void)didReceiveActivity:(MDActivity *)anActivity;

@end
