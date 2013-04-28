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

-(id)init
{
    self = [super init];
    if (self) {
        RHAddressBook *ab = [[RHAddressBook alloc] init];
        
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

-(NSString *)formatLabel:(NSString *)label
{
    if ([label isEqualToString:@"_$!<Anniversary>!$_"]) return @"anniversary";
    if ([label isEqualToString:@"_$!<Assistant>!$_"]) return @"assistant";
    if ([label isEqualToString:@"_$!<AssistantPhone>!$_"]) return @"assistant";
    if ([label isEqualToString:@"_$!<Brother>!$_"]) return @"brother";
    if ([label isEqualToString:@"_$!<Car>!$_"]) return @"car";
    if ([label isEqualToString:@"_$!<Child>!$_"]) return @"child";
    if ([label isEqualToString:@"_$!<CompanyMain>!$_"]) return @"company main";
    if ([label isEqualToString:@"_$!<Father>!$_"]) return @"father";
    if ([label isEqualToString:@"_$!<Friend>!$_"]) return @"friend";
    if ([label isEqualToString:@"_$!<Home>!$_"]) return @"家";
    if ([label isEqualToString:@"_$!<HomeFAX>!$_"]) return @"home fax";
    if ([label isEqualToString:@"_$!<HomePage>!$_"]) return @"home page";
    if ([label isEqualToString:@"_$!<Main>!$_"]) return @"主要";
    if ([label isEqualToString:@"_$!<Manager>!$_"]) return @"manager";
    if ([label isEqualToString:@"_$!<Mobile>!$_"]) return @"移动电话";
    if ([label isEqualToString:@"_$!<Mother>!$_"]) return @"mother";
    if ([label isEqualToString:@"_$!<Other>!$_"]) return @"other";
    if ([label isEqualToString:@"_$!<Pager>!$_"]) return @"pager";
    if ([label isEqualToString:@"_$!<Parent>!$_"]) return @"parent";
    if ([label isEqualToString:@"_$!<Partner>!$_"]) return @"partner";
    if ([label isEqualToString:@"_$!<Radio>!$_"]) return @"radio";
    if ([label isEqualToString:@"_$!<Sister>!$_"]) return @"sister";
    if ([label isEqualToString:@"_$!<Spouse>!$_"]) return @"spouse";
    if ([label isEqualToString:@"_$!<Work>!$_"]) return @"work";
    if ([label isEqualToString:@"_$!<WorkFAX>!$_"]) return @"work fax";
    return label;
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

+(YaabUser *)default
{
    static YaabUser *_instance;
    if (nil == _instance) {
        _instance = [[YaabUser alloc] init];
    }
    return _instance;
}
@end
