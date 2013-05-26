//
//  MDCache.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDCache.h"

@implementation MDCache
-(id)init
{
    self = [super init];
    if (self) {
        _users = [NSMutableDictionary dictionary];
        _activities = [NSMutableDictionary dictionary];
    }
    return self;
}

-(MDActivity *)activity:(NSInteger)activityID
{
    return [_activities
            objectForKey:[NSString stringWithFormat:@"%d", activityID]];
}

-(MDActivity *)addActivity:(MDActivity *)anActivity
{
    if ([self activity:anActivity.id] == nil) {
        [_activities setValue:anActivity
                       forKey:[NSString stringWithFormat:@"%d", anActivity.id]];
    }
    return anActivity;
}

-(MDUser *)user:(NSInteger)userID
{
    return [_users objectForKey:[NSString stringWithFormat:@"%d", userID]];
}

-(MDUser *)addUser:(MDUser *)aUser
{
    if([self user:aUser.userId] == nil)
    {
        [_users setValue:aUser
                  forKey:[NSString stringWithFormat:@"%d", aUser.userId]];
    }
    return aUser;
}

+(MDCache *)sharedInstance
{
    static MDCache *instance;
    if (nil == instance) {
        instance = [[MDCache alloc]init];
    }
    return instance;
}
@end
