//
//  MDCache.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDUser.h"
#import "MDActivity.h"

@interface MDCache : NSObject
{
    NSMutableDictionary *_users;
    NSMutableDictionary *_activities;
}

-(MDActivity *)activity:(NSInteger)activityID;
-(MDActivity *)addActivity:(MDActivity *)anActivity;
-(MDUser *)user:(NSInteger)userID;
-(MDUser *)addUser:(MDUser *)aUser;
+(MDCache *)sharedInstance;
@end
