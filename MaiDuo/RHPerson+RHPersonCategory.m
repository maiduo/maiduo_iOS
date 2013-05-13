//
//  RHPerson+RHPersonCategory.m
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import "RHPerson+RHPersonCategory.h"

@implementation RHPerson (RHPersonCategory)
-(NSString *)getFullName
{
    if (nil == self.lastName)
        self.lastName = @"";
    NSMutableString *name = [NSMutableString stringWithString:self.lastName];
    if (nil != self.firstName)
        [name appendString:self.firstName];
    if (nil != self.middleName)
        [name appendString:self.middleName];
    
    return (NSString *)name;
}
@end
