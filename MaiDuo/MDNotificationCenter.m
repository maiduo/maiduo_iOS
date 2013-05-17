//
//  MDNotificationCenter.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-17.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDNotificationCenter.h"

@implementation MDNotificationCenter
-(id)initWithNotificationCenterWithPayload:(NSString *)aPayload
                                  delegate:(id<MDNotificationCenterDelegate>)aDelegate
{
    self = [self init];
    if (self)
    {
        MDNotificationCenter *center = [[MDNotificationCenter alloc]init];
        center.payload = aPayload;
        center.delegate = aDelegate;
    }
    return self;
}

+(MDNotificationCenter *)
notificationCenterWithPlayload:(NSString *)aPayload
delegate:(id<MDNotificationCenterDelegate>)aDelegate
{
    return [[MDNotificationCenter alloc]
            initWithNotificationCenterWithPayload:aPayload
            delegate:aDelegate];
}

@end
