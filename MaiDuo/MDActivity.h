//
//  MDActivity.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-12.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MDUser.h"

@interface MDActivity : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) MDUser *owner;
@property (nonatomic, strong) NSArray *users;

+(NSArray *)activitiesWithJSON:(id)JSON;
+(MDActivity *)activityWithJSON:(id)JSON;
+(MDActivity *)activityWithID:(NSInteger)aID
                      subject:(NSString *)aSubject
                        owner:(MDUser *)aOwner
                        users:(NSArray *)aUsers;
@end
