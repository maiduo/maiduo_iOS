//
//  MDActivityConView.h
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDActivityContentView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <RHAddressBook/RHAddressBook.h>
#import <RHAddressBook/RHPerson.h>
#import "MDActivity.h"
#import "MDUserManager.h"

@interface MDActivityContactView : MDActivityContentView <UITableViewDelegate,
UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate> {
    UITableView *_tableView;
    MDActivity *_activity;
    MDUser *_user;
    NSMutableArray *_people;
    NSMutableArray *_invitations;
    RHAddressBook *_addressBook;
    ABAddressBookRef _addressBookRef;
}

@property (strong) MDActivity *activity;
@property (strong) NSMutableArray *people;

-(id) initWithActivity:(MDActivity *)anActivity;
@end
