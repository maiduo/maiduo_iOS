//
//  YaabUser.m
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import "YaabUser.h"
#import "pinyin.h"
#import "RHPerson+RHPersonCategory.h"

@implementation YaabUser
@synthesize deviceToken=_deviceToken;

-(id)init
{
    self = [super init];
    if (self) {
        [[NSUserDefaults standardUserDefaults]
         registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"deviceToken", @"0", nil]];
        
        nsUser = [NSUserDefaults standardUserDefaults];
        self.user=[[MDUser alloc] init];
        self.users = [NSMutableDictionary dictionary];
        self.apis = [NSMutableDictionary dictionary];
        self.service = @"dev";

    }
    return self;
}

-(void)setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    [nsUser setObject:deviceToken forKey:@"deviceToken"];
}

-(NSString *)getDeviceTokenWithData:(NSData *)nsdataToken
{
    NSString* token = [nsdataToken description];
	token = [token stringByTrimmingCharactersInSet:
                [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	token = [token stringByReplacingOccurrencesOfString:@" "
                                                   withString:@""];
    
    return token;
}

-(MDUser *)userWithID:(NSInteger)aUserID
{
    return [self.users objectForKey:[NSString stringWithFormat:@"%d", aUserID]];
}

-(void)addUser:(MDUser *)aUser
{
    [self.users setValue:aUser
                  forKey:[NSString stringWithFormat:@"%d", aUser.id]];
    self.user = aUser;
}

-(MDHTTPAPI *)api
{
    return [self apiWithUserID:self.user.id];
}

-(MDHTTPAPI *)apiWithUserID:(NSInteger)aUserID
{
    return [self.apis objectForKey:[NSString stringWithFormat:@"%d", aUserID]];
}

-(void)addAPI:(MDHTTPAPI *)aMDHTTPAPI user:(MDUser *)aUser
{
    [self.apis setValue:aMDHTTPAPI
                  forKey:[NSString stringWithFormat:@"%d", aUser.id]];
}

+(YaabUser *)sharedInstance
{
    static YaabUser *_instance;
    if (nil == _instance) {
        _instance = [[YaabUser alloc] init];
    }
    return _instance;
}
@end
