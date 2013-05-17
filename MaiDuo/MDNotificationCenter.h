//
//  MDNotificationCenter.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-17.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDNotificationCenterDelegate.h"

@interface MDNotificationCenter : NSObject {
}

@property(strong) MDUser *user;
@property(strong) id<MDNotificationCenterDelegate> delegate;

-(id)initNotificationCenterWithUser:(MDUser *)aUser
                           delegate:(id<MDNotificationCenterDelegate>)aDelegate;

-(void)send:(NSDictionary *)userInfo;

+(MDNotificationCenter *)
notificationCenterWithUser:(MDUser *)aUser
delegate:(id<MDNotificationCenterDelegate>)aDelegate;
@end
