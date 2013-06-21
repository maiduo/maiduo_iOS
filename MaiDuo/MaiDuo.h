//
//  MaiDuo.h
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import <Foundation/Foundation.h>
#import "MDUser.h"
#import "MDHTTPAPI.h"

@interface MaiDuo : NSObject
{
    NSUserDefaults *_storage;
}

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) MDUser *user;
@property (strong) NSMutableDictionary *users;
@property (strong) NSMutableDictionary *apis;
@property (strong) NSString *service;
-(void)setDeviceToken:(NSString *)deviceToken;
-(NSString *)getDeviceTokenWithData:(NSData *)nsdataToken;

-(MDUser *)userWithID:(NSInteger)aUserID;
-(void)addUser:(MDUser *)aUser;

-(MDHTTPAPI *)apiWithUserID:(NSInteger)aUserID;
-(MDHTTPAPI *)api;
-(void)addAPI:(MDHTTPAPI *)aMDHTTPAPI user:(MDUser *)aUser;

+(MaiDuo *)sharedInstance;

@end
