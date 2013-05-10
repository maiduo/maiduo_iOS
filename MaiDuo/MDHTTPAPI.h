//
//  MDHTTPAPI.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDUser.h"

@interface MDHTTPAPI : NSObject
{
    NSString *url;
}

@property(nonatomic, strong) MDUser *user;

-(id) initWithUser:(MDUser *)user;

+(void)registerUser:(MDUser *)user
            success:(void (^)(MDUser *user, MDHTTPAPI *api))success
            failure:(void (^)(NSError *error))failure;

+(void)login:(MDUser *)user
     success:(void (^)(MDUser *user, MDHTTPAPI *api))success
     failure:(void (^)(NSError *error))failure;
@end
