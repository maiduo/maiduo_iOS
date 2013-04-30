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
@synthesize group;
@synthesize names;
@synthesize description;
@synthesize deviceToken=_deviceToken;

-(id)init
{
    self = [super init];
    if (self) {
        RHAddressBook *ab = [[RHAddressBook alloc] init];
        [[NSUserDefaults standardUserDefaults]
         registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"deviceToken", @"0", nil]];
        
        nsUser = [NSUserDefaults standardUserDefaults];
        
        //if not yet authorized, force an auth.
        if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
            [ab requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
                group = [self groupingWithPeople:[ab peopleOrderedByLastName]];
            }];
        }
        
        // warn re being denied access to contacts
        if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RHAuthorizationStatusDenied" message:@"Access to the addressbook is currently denied." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        // warn re restricted access to contacts
        if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusRestricted){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RHAuthorizationStatusRestricted" message:@"Access to the addressbook is currently restricted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        group = [self groupingWithPeople:[ab peopleOrderedByLastName]];
    }
    return self;
}

-(NSMutableArray *)groupingWithPeople:(NSArray *)people
{    
    NSMutableArray *_group = [NSMutableArray arrayWithCapacity:27];
    for (int i = 0; i < 27; i++) {
        _group[i] = [NSMutableArray array];
    }
    int count = [people count];
    NSMutableArray *_people;
    int index;
    names = [NSMutableArray array];
    description = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        RHPerson *person = (RHPerson *)[people objectAtIndex: i];
        index = [self indexOfGroupWithPerson:person];
        _people = (NSMutableArray *)[_group objectAtIndex:index];
        [_people addObject: person];
        
        RHMultiStringValue *phoneNumbers = [person phoneNumbers];
        for (int j = 0, c = [phoneNumbers count]; j < c; j++) {
            [names addObject: [person getFullName]];
            [description addObject:[NSString stringWithFormat:@"%@:%@",
                                    [phoneNumbers localizedLabelAtIndex:j],
                                    [phoneNumbers valueAtIndex: j]]];
            
        }
    }
    return _group;
}

-(int)indexOfGroupWithPerson:(RHPerson *)person
{
    int firstLetter;
    NSString *name = [person getFullName];
    if (0 == name.length)
        firstLetter = 35;
    else
        firstLetter = toupper(pinyinFirstLetter([name characterAtIndex:0]));
    
    if (65 > firstLetter || 90 < firstLetter)
        firstLetter = 91;
    
    
    return firstLetter - 65;
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

+(YaabUser *)default
{
    static YaabUser *_instance;
    if (nil == _instance) {
        _instance = [[YaabUser alloc] init];
    }
    return _instance;
}
@end
