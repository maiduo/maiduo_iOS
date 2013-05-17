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

@property(copy) NSString *payload;
@property(strong) id<MDNotificationCenterDelegate> delegate;

-(id)initWithNotificationCenterWithPayload:(NSString *)aPayload
delegate:(id<MDNotificationCenterDelegate>)aDelegate;

+(MDNotificationCenter *)
notificationCenterWithPlayload:(NSString *)aPayload
delegate:(id<MDNotificationCenterDelegate>)aDelegate;
@end
