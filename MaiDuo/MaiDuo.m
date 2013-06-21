//
//  MaiDuo.m
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import "MaiDuo.h"

#define STORAGE_USER_KEY @"CURRENT_USER"

@implementation MaiDuo
@synthesize deviceToken=_deviceToken;

-(id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.service = @"dev";
    _storage = [NSUserDefaults standardUserDefaults];
    [_storage registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                @"deviceToken", @"0", nil]];
    
    self.users = [NSMutableDictionary dictionary];
    MDUserFactory *factory = [[MDUserFactory alloc] init];
    
    NSDictionary *dictionaryUser = [_storage objectForKey: STORAGE_USER_KEY];
    if (dictionaryUser) {
        self.user = [factory userWithDictionary:dictionaryUser];
        self.api  = [[MDHTTPAPI alloc] initWithUser:self.user];
    }
}

-(void)setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    [_storage setObject:deviceToken forKey:@"deviceToken"];
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

-(void)addUser:(MDUser *)aUser
{
    [self.users setValue:aUser
                  forKey:[NSString stringWithFormat:@"%d", aUser.userId]];
    self.user = aUser;
}

- (void)saveUser:(MDUser *)aUser
{
    self.user = aUser;
    self.api  = [[MDHTTPAPI alloc] initWithUser:self.user];
    
    if (aUser){
        [[NSUserDefaults standardUserDefaults] setObject:[aUser dictionaryValue]
                                                  forKey:STORAGE_USER_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(MaiDuo *)sharedInstance
{
    static MaiDuo *_instance;
    if (nil == _instance) {
        _instance = [[MaiDuo alloc] init];
    }
    return _instance;
}
@end
