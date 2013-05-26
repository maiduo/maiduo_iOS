//
//  MDUser.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RHAddressBook/RHAddressBook.h>
#import <RHAddressBook/RHPerson.h>
#import <AddressBook/AddressBook.h>
#import "RHPerson+RHPersonCategory.h"

/** MDUser
 */

@interface MDUser : NSObject <NSCopying>
{
}

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (assign) BOOL isActive;
@property (strong) NSString *avatar;
@property (nonatomic, strong) NSString *deviceToken;
@property (copy) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;

-(NSDictionary *)dictionaryValue;
-(id)initWithUsername:(NSString *)anUsername password:(NSString *)aPassword;
-(id)initWithUsername:(NSString *)anUsername
                 name:(NSString *)aName
             password:(NSString *)aPassword;
-(BOOL)equal:(MDUser *)aUser;
+(MDUser *)userWithDictionary:(NSDictionary *)aDictionary;
+(MDUser *)userWithInvite:(NSString *)anUsername name:(NSString *)aName;
+(MDUser *)userWithRHPerson:(RHPerson *)aPerson
                   property:(ABPropertyID)property
                 identifier:(ABMultiValueIdentifier)identifier;
+(MDUser *)userWithJSON:(id)JSON;
+(NSArray *)usersWithJSON:(id)JSON;
@end
