//
//  MDUser.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    SMALL_AVATAR,
    MIDDLE_AVATAR,
    BIG_AVATAR
} typedef AvatarSize;

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
@property (nonatomic, strong) NSString *deviceToken;
@property (copy) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (copy, readonly) NSString *avatar;


-(NSDictionary *)dictionaryValue;
-(id)initWithUsername:(NSString *)anUsername password:(NSString *)aPassword;
-(id)initWithUsername:(NSString *)anUsername
                 name:(NSString *)aName
             password:(NSString *)aPassword;
-(BOOL)equal:(MDUser *)aUser;
- (NSString *)avatar;
- (NSString *)avatarWithSize:(AvatarSize)size;
- (BOOL)isValid;
+(MDUser *)userWithDictionary:(NSDictionary *)aDictionary;
+(MDUser *)userWithInvite:(NSString *)anUsername name:(NSString *)aName;

+(MDUser *)userWithJSON:(id)JSON;
+(NSArray *)usersWithJSON:(id)JSON;
@end
