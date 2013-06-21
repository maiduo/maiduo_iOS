//
//  MDUserManager.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDUserManager.h"
#import "MDAppDelegate.h"
#define MDUserKey @"MDUser"
#define NameKey @"MDName"
#define PwdKey @"MDPwd"
#define DeviceTokenKey @"MDDeviceToken"
@implementation MDUserManager

-(id)init
{
    self = [super init];
    if (self) {
        self.user= ];
    }
    return self;
}

- (BOOL)userSessionValid
{
    BOOL valid = YES;
    MDUser *user = [self getUserSession];
    valid = user != nil;
    valid = user.userId > 0;
    
    return valid;
}

- (MDUser*)getUserSession
{
    static MDUser *session;
    if (nil != session) {
        return session;
    }
    
    NSDictionary *dictionaryUser=[[NSUserDefaults standardUserDefaults]
                                  objectForKey:MDUserKey];
    if(dictionaryUser){
        session = [MDUser userWithDictionary:dictionaryUser];
        [[MaiDuo sharedInstance]
         addAPI:[[MDHTTPAPI alloc] initWithUser:session]
           user:session];
        [[MaiDuo sharedInstance] setUser:session];
        return session;
    }else{
        return nil;
    }
}

- (void)logout
{
    MDUser *user = [self getUserSession];
    user.userId = 0;
    [self saveSessionWithUser:user];
}

- (void)saveSessionWithUser:(MDUser *)aUser
{
    _user = aUser;
    if(aUser){
        [[NSUserDefaults standardUserDefaults] setObject:[aUser dictionaryValue]
                                                 forKey:MDUserKey];
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
