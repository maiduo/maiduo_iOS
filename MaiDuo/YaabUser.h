//
//  YaabUser.h
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import <Foundation/Foundation.h>
#import <RHAddressBook/AddressBook.h>

@interface YaabUser : NSObject
{
    NSUserDefaults *nsUser;
}

@property (nonatomic, strong) RHAddressBook *addressbook;
@property (nonatomic, strong) NSMutableArray *group;
@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSMutableArray *description;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, assign) ABAddressBookRef addressBookRef;

-(void)setDeviceToken:(NSString *)deviceToken;
-(NSString *)getDeviceTokenWithData:(NSData *)nsdataToken;

+(YaabUser *)default;

@end
