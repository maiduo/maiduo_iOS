//
//  MDUserManager.h
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDUser.h"

@interface MDUserManager : NSObject

@property (nonatomic, strong) MDUser *user;

- (BOOL)userSessionValid;

+ (MDUserManager *)sharedInstance;

@end
