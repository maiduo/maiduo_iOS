//
//  MDUserAssembly.m
//  MaiDuo
//
//  Created by Indvane Mini on 13-6-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDUserAssembler.h"

@implementation MDUserAssembler
-(MDUser *)userWithRHPerson:(RHPerson *)aPerson
                   property:(ABPropertyID)property
                 identifier:(ABMultiValueIdentifier)identifier
{
    NSString *mobile = [[aPerson getMultiValueForPropertyID:property]
                        valueAtIndex:identifier];
    
    mobile = [[[[mobile stringByReplacingOccurrencesOfString:@")" withString:@""]
                stringByReplacingOccurrencesOfString:@"(" withString:@""]
               stringByReplacingOccurrencesOfString:@"-" withString:@""]
              stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [MDUser userWithInvite:mobile name:[aPerson getFullName]];
}
@end
