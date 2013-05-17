//
//  YaabUser.h
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import <Foundation/Foundation.h>
#import <RHAddressBook/AddressBook.h>
#import "MDUser.h"
#import "MDHTTPAPI.h"

@interface YaabUser : NSObject
{
    NSUserDefaults *nsUser;
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

+(YaabUser *)sharedInstance;

@end
