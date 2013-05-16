//
//  MDActivity.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-12.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDActivity.h"

@implementation MDActivity

-(id)init
{
    self = [super init];
    if (self) {
        self.invitation = [NSMutableArray array];
    }
    return self;
}

-(MDUser *)invite:(MDUser *)user
{
    [self.invitation addObject: user];
    return user;
}
 
-(void)removeAllInvitations
{
    [self.invitation removeAllObjects];
}

+(NSArray *)activitiesWithJSON:(id)JSON
{
    NSArray *jsonActivities = (NSArray *)JSON;
    NSMutableArray *activies = [NSMutableArray
                                arrayWithCapacity:jsonActivities.count];
    NSInteger size = [jsonActivities count];
    for (NSInteger i=0; i < size; i++) {
        activies[i] = [MDActivity activityWithJSON:[jsonActivities objectAtIndex:i]];
    }
    
    return activies;
}

+(MDActivity *)activityWithSubject:(NSString *)aSubject
{
    MDActivity *activity = [[MDActivity alloc]init];
    activity.subject = aSubject;
    
    return activity;
}

+(MDActivity *)activityWithSubject:(NSString *)aSubject
                       description:(NSString *)aDescription
{
    
}

+(MDActivity *)activityWithJSON:(id)JSON
{
    NSInteger userID = [[JSON objectForKey:@"id"] intValue];
    NSString *subject = [JSON objectForKey:@"subject"];
    
    return [MDActivity activityWithID:userID
                              subject:subject
                                owner:[MDUser userWithJSON:
                                       [JSON objectForKey:@"owner"]]
                                users:[MDUser usersWithJSON:
                                       [JSON objectForKey:@"users"]]];
}

+(MDActivity *)activityWithID:(NSInteger)aID
                      subject:(NSString *)aSubject
                        owner:(MDUser *)aOwner
                        users:(NSArray *)aUsers
{
    MDActivity *activity = [[MDActivity alloc] init];
    activity.id =aID;
    activity.subject = aSubject;
    activity.owner =aOwner;
    activity.users = aUsers;
    return activity;
}
@end
