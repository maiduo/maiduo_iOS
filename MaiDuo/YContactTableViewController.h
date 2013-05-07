//
//  ContactsTableViewController.h
//  Yaab
//
//  Created by 魏琮举 on 13-4-26.
//
//

#import <UIKit/UIKit.h>
#import "YaabUser.h"
#import "RHPerson+RHPersonCategory.h"

@interface YContactTableViewController : UITableViewController {
    NSArray *letters;
    NSMutableArray *group;
}

@property (nonatomic, strong) RHAddressBook *addressbook;

-(void) setAllowsMultipleSelection:(BOOL)allow;
-(BOOL) getAllowsMultipleSelection;
@end
