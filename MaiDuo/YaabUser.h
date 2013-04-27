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
}

@property (nonatomic, strong) NSMutableArray *group;

+(YaabUser *)default;

@end
