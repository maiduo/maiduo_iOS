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
    NSMutableString *name = [NSMutableString stringWithString:self.lastName];
    if (nil != self.middleName)
        [name appendString:self.middleName];
    if (nil != self.firstName)
        [name appendString:self.firstName];
    
    return (NSString *)name;
}
@end
