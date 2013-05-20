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
#import "MDActivity.h"
#import <RHAddressBook/RHPerson.h>

@interface MDActivityContactView : MDActivityContentView <UITableViewDelegate,
UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate> {
    RHAddressBook *_addressBook;
    ABAddressBookRef _addressBookRef;
}

@property (strong) UITableView *tableView;
@property (strong) MDActivity *activity;
@property (strong) NSMutableArray *contacts;

-(id)initWithActivity:(MDActivity *)anActivity;

@end
