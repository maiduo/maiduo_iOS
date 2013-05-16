//
//  MDUserManager.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDUserManager.h"
#define MDUserKey @"MDUser"
#define NameKey @"MDName"
#define PwdKey @"MDPwd"
#define DeviceTokenKey @"MDDeviceToken"
@implementation MDUserManager

-(id)init
{
    self = [super init];
    if (self) {
        self.user=[[MDUser alloc] init];
    }
    return self;
}
- (BOOL)userSessionValid
{
    return [self getUserSession] != nil;
}
- (MDUser*)getUserSession
{
    NSDictionary *dicUser=[[NSUserDefaults standardUserDefaults] objectForKey:MDUserKey];
    if(dicUser){
        self.user.username=dicUser[NameKey];
        self.user.password=dicUser[PwdKey];
        self.user.deviceToken=dicUser[DeviceTokenKey];
        return self.user;
    }else{
        return nil;
    }
}
- (void) saveUserSession
{
    if(_user){
        NSDictionary *dicUser=@{NameKey:_user.username,PwdKey:_user.password,DeviceTokenKey:_user.deviceToken};
        [[NSUserDefaults standardUserDefaults] setValue:dicUser forKey:MDUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (MDUserManager *)sharedInstance
{
    static id _instance = nil;
    if (!_instance) {
        _instance = [[MDUserManager alloc] init];
    }
    return _instance;
}

@end
