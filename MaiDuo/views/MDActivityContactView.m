//
//  MDActivityConView.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDActivityContactView.h"

@implementation MDActivityContactView

- (id)initWithActivity:(MDActivity *)anActivity
{
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] init];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _activity = anActivity;
        _people = [NSMutableArray arrayWithArray:anActivity.users];
        _invitations = [NSMutableArray arrayWithArray:anActivity.invitation];
        _user = [[MDUserManager sharedInstance] getUserSession];
        
        [self setupAddressBook];
        
        if([_user equal:_activity.owner]) {
            [_people addObjectsFromArray: _invitations];
        }
    }
    
    return self;
}

- (void)setupAddressBook
{
    _addressBook = [[RHAddressBook alloc] init];
    //if not yet authorized, force an auth.
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        [_addressBook requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            [self setupABRef];
        }];
    } else {
    }
    // warn re being denied access to contacts
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"RHAuthorizationStatusDenied"
                              message:@"Access to the addressbook is currently denied."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    // warn re restricted access to contacts
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusRestricted){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"RHAuthorizationStatusRestricted"
                              message:@"Access to the addressbook is currently restricted."
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self setupABRef];
}

- (void)setupABRef
{
    [_addressBook performAddressBookAction:^(ABAddressBookRef anAddressBookRef)
    {
        _addressBookRef = anAddressBookRef;
    }
                             waitUntilDone:YES];
}

- (void)rightBarAction
{
    ABPeoplePickerNavigationController *controller;
    controller = [[ABPeoplePickerNavigationController alloc] init];
    controller.peoplePickerDelegate = self;
    [self.viewController.navigationController
     presentModalViewController:controller
     animated:YES];
}

- (void)reloadData
{
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MDActivityContactTableViewCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:identifier]; 
    if (nil == cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:identifier];
    }
    
    MDUser *person = (MDUser *)[_people objectAtIndex:[indexPath row]];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"电话 %@",
                                 person.username];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    RHPerson *rh_person = [_addressBook personForABRecordRef:person];
    BOOL hasManyPhoneNumber = [rh_person.phoneNumbers count] > 1;
    if (hasManyPhoneNumber) {
        return YES;
    } else {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
}

- (BOOL)hasUser:(MDUser *)anUser
{
    
    NSInteger size = [_people count];
    NSInteger i = 0;
    MDUser *iter;
    for(;i < size;i++) {
        iter = (MDUser *)[_people objectAtIndex:i];
        if ([anUser.username isEqualToString:iter.username]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    RHPerson *aPerson = [_addressBook personForABRecordRef:person];
    MDUser *invited = [MDUser userWithRHPerson:aPerson
                                      property:property
                                    identifier:identifier];
    
    if (![self hasUser:invited]) {
        [_people addObject:invited];
        [_tableView reloadData];
        
        [[[YaabUser sharedInstance] api] inviteForActivity:_activity
                                                      user:invited
                                                   success:^(MDUser *anUser){}
                                                   failure:nil];
    }
    
    [peoplePicker dismissModalViewControllerAnimated:YES];
    return NO;
}

@end
