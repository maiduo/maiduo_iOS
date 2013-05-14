//
//  MDHTTPAPI.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDUser.h"
#import "MDMessage.h"
#import "MDActivity.h"

@interface MDHTTPAPI : NSObject
{
    NSString *url;
}

@property(nonatomic, strong) MDUser *user;

-(id) initWithUser:(MDUser *)user;

-(void)ActivitiesUsingBlockWithSuccess:(void (^)(NSArray *))success
                                    failure:(void (^)(NSError *error))failure;

-(void)createActivity:(MDActivity *)aActivity
              success:(void (^)(NSArray *))success
              failure:(void (^)(NSError *error))failure;

-(void)sendMessage:(MDMessage *)message
           success:(void (^)(MDMessage *))success
           failure:(void (^)(NSError *error))failure;

-(void)messagesWithActivity:(MDActivity *)activity
                    success:(void (^)(NSArray *))success
                    failure:(void (^)(NSError *error))failure;

+(void)registerUser:(MDUser *)user
            success:(void (^)(MDUser *user, MDHTTPAPI *api))success
            failure:(void (^)(NSError *error))failure;

+(void)login:(MDUser *)user
     success:(void (^)(MDUser *user, MDHTTPAPI *api))success
     failure:(void (^)(NSError *error))failure;

+(MDHTTPAPI *)MDHTTPAPIWithToken:(MDUser *)user;
@end
