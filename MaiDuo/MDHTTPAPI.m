//
//  MDHTTPAPI.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDHTTPAPI.h"
#import "AFMDClient.h"
#import <AFNetworking/AFNetworking.h>

@implementation MDHTTPAPI
-(id) init
{
    self = [super init];
    if (self) {
        url = @"https://himaiduo.com/api/";
        _cache = [MDCache sharedInstance];
    }
    
    return self;
}

-(id) initWithUser:(MDUser *)user
{
    self = [self init];
    if (self) {
        self.user = user;
        self.factory = [MDHTTPAPIFactory factoryWithAccessToken:user.accessToken
                                                        service:@"dev"];
    }
    
    return self;
}

-(void)activitiesSuccess:(void (^)(NSArray *))success
                 failure:(void (^)(NSError *error))failure
{
    void (^blockSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Activity fetch data success.");
        NSArray *activities = [MDActivity activitiesWithJSON:JSON];
        [activities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx,
                                                 BOOL *stop) {
            [_cache addActivity:obj];
            
            MDActivity *activity = (MDActivity *)obj;
            [activity.users enumerateObjectsUsingBlock:^(id aIDUser,
                                                         NSUInteger idx,
                                                         BOOL *stop) {
                MDUser *aUser = (MDUser *)aIDUser;
                [_cache addUser:aUser];
            }];
        }];
        success(activities);
    };
    
    void (^blockFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (nil != failure)
            failure(error);
    };
    
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.user.accessToken, @"access_token", nil];
    
    [[AFMDClient sharedClient] getPath:@"activity/"
                            parameters:query
                               success:blockSuccess
                               failure:blockFailure];
}

-(void)createActivity:(MDActivity *)activity
              success:(void (^)(MDActivity *anActivity))success
              failure:(void (^)(NSError *error))failure
{
    void (^blockSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
        success([MDActivity activityWithJSON: JSON]);
    };
    
    void (^blockFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self printError:error];
        if (nil != failure)
            failure(error);
    };
    
    NSDictionary *dictionaryActivity;
    dictionaryActivity = [self.factory dictionaryForCreateActivity:activity];
    
    [[AFMDClient sharedClient] postPath:@"activity/"
                             parameters:dictionaryActivity
                                success:blockSuccess
                                failure:blockFailure];
}

-(void)messagesWithActivity:(MDActivity *)activity
                       page:(NSInteger)page
                    success:(void (^)(NSArray *messages))success
                    failure:(void (^)(NSError *error))failure
{
    void (^blockSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
        success([MDMessage messagesWithJSON:JSON]);
    };
    
    void (^blockFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (nil != failure)
            failure(error);
    };
    
    NSDictionary *dictionaryChats;
    dictionaryChats = [self.factory dictionaryForChatsWithActivity:activity
                                                              page:page];
    
    NSString *chatsURL = [NSString
                            stringWithFormat:@"messages/%d/", activity.id];
    [[AFMDClient sharedClient] getPath:chatsURL
                            parameters:dictionaryChats
                               success:blockSuccess
                               failure:blockFailure];
}

-(void)chatsWithActivity:(MDActivity *)activity
                    page:(NSInteger)page
                 success:(void (^)(NSArray *chats))success
                 failure:(void (^)(NSError *error))failure
{
    [self chatsWithActivity:activity
                       page:page
                   pageSize:0
                    success:success
                    failure:failure];
}

-(void)chatsWithActivity:(MDActivity *)activity
                    page:(NSInteger)page
                pageSize:(NSInteger)pageSize
                 success:(void (^)(NSArray *chats))success
                 failure:(void (^)(NSError *error))failure
{
    void (^blockSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
        success([MDChat chatsWithJSON:JSON]);
    };
    
    void (^blockFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (nil != failure)
            failure(error);
    };
    
    NSDictionary *dictionaryMessages;
    dictionaryMessages = [self.factory
                          dictionaryForChatsWithActivity:activity
                          page:page
                          pageSize:pageSize];
    
    NSString *messagesURL = [NSString
                             stringWithFormat:@"chats/%d/", activity.id];
    [[AFMDClient sharedClient] getPath:messagesURL
                            parameters:dictionaryMessages
                               success:blockSuccess
                               failure:blockFailure];
}

-(void)sendMessage:(MDMessage *)message
           success:(void (^)(MDMessage *))success
           failure:(void (^)(NSError *error))failure
{
    void (^blockSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
        success([MDMessage messageWithJSON:JSON]);
    };
    
    void (^blockFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (nil != failure)
            failure(error);
    };
    
    NSDictionary *dictionaryMessage;
    dictionaryMessage = [self.factory dictionaryForSendMessage:message];
    
    [[AFMDClient sharedClient] postPath:@"message/"
                             parameters:dictionaryMessage
                                success:blockSuccess
                                failure:blockFailure];
}

-(void)messagesWithActivity:(MDActivity *)activity
                    success:(void (^)(NSArray *))success
                    failure:(void (^)(NSError *error))failure
{
    
}

-(void)sendChat:(MDChat *)chat
        success:(void (^)(MDChat *))success
        failure:(void (^)(NSError *))failure
{
    NSDictionary *chatDictionary;
    chatDictionary = [self.factory dictionaryForSendChat:chat];
    [[AFMDClient sharedClient] postPath:@"chat/"
                             parameters:chatDictionary
                                success:^(AFHTTPRequestOperation *operation,
                                          id JSON)
    {
        success([MDChat chatWithJSON:JSON]);
    }
                                failure:^(AFHTTPRequestOperation *operation,
                                          NSError *error)
    {
        [self printError:error];
        if (nil != failure)
            failure(error);
    }];
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
    
    NSDictionary *dicParams = [NSDictionary dictionaryWithObjectsAndKeys:
                          user.username, @"username",
                          user.password, @"password",
                          @"password", @"grant_type",
                          @"", @"scope",
                          @"104c03b3103e4d5e96d042330f6dd0c8", @"client_id",
                          user.deviceToken, @"device_token",
                          nil];
    [[AFMDClient sharedClient] postPath:@"authentication/"
                             parameters:dicParams
                                success:^(AFHTTPRequestOperation *operation, id JSON)
    {
        user.password = nil;
        
        MDUser *newUser = [MDUser userWithJSON: [JSON objectForKey:@"user"]];
        newUser.accessToken = [NSString stringWithFormat:@"%@",
                             [JSON objectForKey:@"access_token"]];
        newUser.refreshToken = [NSString stringWithFormat:@"%@",
                              [JSON objectForKey:@"refresh_token"]];
        MDHTTPAPI *api = [[MDHTTPAPI alloc] initWithUser:newUser];
        success(newUser, api);
    }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (nil != failure)
            failure(error);
    }];
}

+(MDHTTPAPI *)MDHTTPAPIWithToken:(MDUser *)user
{
    return [[MDHTTPAPI alloc] initWithUser:user];
}

-(void)printError:(NSError *)error
{
    [error.userInfo
     enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
         NSLog(@"key:%@\nvalue:%@\n", key, obj);
     }];
}
@end
