//
//  YaabUser.m
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import "YaabUser.h"
#import "pinyin.h"

@implementation YaabUser
@synthesize group;

-(id)init
{
    self = [super init];
    if (self) {
        RHAddressBook *addressbook = [[RHAddressBook alloc] init];
        group = [self groupingWithPeople:[addressbook peopleOrderedByLastName]];
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
    for (int i = 0; i < count; i++) {
        RHPerson *person = (RHPerson *)[people objectAtIndex: i];
        index = [self indexOfGroupWithPerson:person];
        _people = (NSMutableArray *)[_group objectAtIndex:index];
        [_people addObject: person];
    }
    return _group;
}

-(int)indexOfGroupWithPerson:(RHPerson *)person
{
    int firstLetter;
    NSString *name;
    if (0 == person.lastName.length)
        name = person.firstName;
    if (0 == name.length)
        name = person.middleName;
    
    if (0 == person.lastName.length)
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
