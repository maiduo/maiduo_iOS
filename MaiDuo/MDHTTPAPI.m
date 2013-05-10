//
//  MDHTTPAPI.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDHTTPAPI.h"
#import <AFNetworking/AFNetworking.h>

@implementation MDHTTPAPI
-(id) init
{
    self = [super init];
    if (self) {
        url = @"https://himaiduo.com/api/";
    }
    
    return self;
}

-(id) initWithUser:(MDUser *)user
{
    self = [self init];
    if (self) {
        self.user = user;
    }
    
    return self;
}

+(void)registerUser:(MDUser *)user
            success:(void (^)(MDUser *user, MDHTTPAPI *api))success
            failure:(void (^)(NSError *error))failure
{
    static NSString *url = @"https://himaiduo.com/api/";
    AFHTTPClient *client = [[AFHTTPClient alloc]
                            initWithBaseURL:[NSURL URLWithString:url]];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          user.username, @"username",
                          user.password, @"password",
                          nil];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST"
                                                        path:@"user/"
                                                  parameters:data];
    
    void (^blockSuccess)(NSURLRequest *, NSHTTPURLResponse *, id) =
    ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
            success(user, api);
        } failure:^(NSError *error) {
            failure(error);
        }];
    };
    void (^blockFailure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) =
    ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error,
      id JSON) {
        if (400 == [response statusCode]) {
            [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
                success(user, api);
            } failure:^(NSError *error2) {
                failure(error2);
            }];
            return;
        }
        if (nil != failure)
            failure(error);
    };
    
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation
                 JSONRequestOperationWithRequest:request
                 success:blockSuccess
                 failure:blockFailure];
    [operation start];
}

+(void)login:(MDUser *)user
    success:(void (^)(MDUser *user, MDHTTPAPI *api))success
    failure:(void (^)(NSError *error))failure
{
    static NSString *url = @"https://himaiduo.com/api/";
    AFHTTPClient *client = [[AFHTTPClient alloc]
                            initWithBaseURL:[NSURL URLWithString:url]];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          user.username, @"username",
                          user.password, @"password",
                          @"password", @"grant_type",
                          @"", @"scope",
                          @"104c03b3103e4d5e96d042330f6dd0c8", @"client_id",
                          nil];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST"
                                                        path:@"authentication/"
                                                  parameters:data];
    
    void (^blockSuccess)(NSURLRequest *, NSHTTPURLResponse *, id) =
    ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        user.access_token = [NSString stringWithFormat:@"%@",
                                  [JSON objectForKey:@"access_token"]];
        user.refresh_token = [NSString stringWithFormat:@"%@",
                                  [JSON objectForKey:@"refresh_token"]];
        MDHTTPAPI *api = [[MDHTTPAPI alloc] initWithUser:user];
        success(user, api);
    };
    void (^blockFailure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) =
    ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error,
      id JSON) {
        if (nil != failure)
            failure(error);
    };
    
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation
                 JSONRequestOperationWithRequest:request
                                         success:blockSuccess
                                         failure:blockFailure];
    [operation start];
}
@end
