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
@interface YaabUser : NSObject
{
    NSUserDefaults *nsUser;
}

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) MDUser *user;
-(void)setDeviceToken:(NSString *)deviceToken;
-(NSString *)getDeviceTokenWithData:(NSData *)nsdataToken;

+(YaabUser *)default;

@end
