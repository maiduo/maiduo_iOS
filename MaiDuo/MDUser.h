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

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;

-(id)initWithUsername:(NSString *)username password:(NSString *)password;
+(MDUser *)userWithJSON:(id)JSON;
+(NSArray *)usersWithJSON:(id)JSON;
@end
