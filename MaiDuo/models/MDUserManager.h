//
//  MDUserManager.h
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDUser.h"
#import "MaiDuo.h"

/** 用户状态管理 - 这里和MaiDuo干了同样的事情，下次重构解决。
 */
@interface MDUserManager : NSObject

@property (nonatomic, strong) MDUser *user;

- (BOOL)userSessionValid;
- (MDUser*)getUserSession;
- (void)logout;
- (void)saveSessionWithUser:(MDUser *)aUser;
+ (MDUserManager *)sharedInstance;

@end
