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

@interface MDActivityContactView : MDActivityContentView <UITableViewDelegate,
UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate> {
    UITableView *_tableView;
    NSMutableArray *_source;
}

@end
