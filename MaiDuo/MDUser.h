//
//  MDUser.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>

/** MDUser
 */

@interface MDUser : NSObject
{
}

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (strong) NSString *avatar;
@property (nonatomic, strong) NSString *deviceToken;
@property (copy) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;

-(NSDictionary *)dictionaryValue;
-(id)initWithUsername:(NSString *)username password:(NSString *)password;
+(MDUser *)userWithDictionary:(NSDictionary *)aDictionary;
+(MDUser *)userWithJSON:(id)JSON;
+(NSArray *)usersWithJSON:(id)JSON;
@end
