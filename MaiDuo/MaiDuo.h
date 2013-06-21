//
//  MaiDuo.h
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import <Foundation/Foundation.h>
#import "MDUser.h"
#import "MDUserFactory.h"
#import "MDHTTPAPI.h"

@interface MaiDuo : NSObject
{
    NSUserDefaults *_storage;
}

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) MDUser *user;
@property (strong) NSMutableDictionary *users;
@property (strong) MDHTTPAPI *api;
@property (strong) NSString *service;

- (void)setDeviceToken:(NSString *)deviceToken;
- (NSString *)getDeviceTokenWithData:(NSData *)nsdataToken;

- (void)addUser:(MDUser *)aUser;
- (void)saveUser:(MDUser *)aUser;

+ (MaiDuo *)sharedInstance;

@end
