//
//  MDActivityConView.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDActivityContactView.h"
#import "MDActivityConCell.h"

@implementation MDActivityContactView

-(id)initWithActivity:(MDActivity *)anActivity
{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        
        _activity = anActivity;
        _contacts = [NSMutableArray arrayWithArray:anActivity.users];
    }
    
    return self;
}

- (void)setupAddressBook
{
    _addressBook = [[RHAddressBook alloc] init];
    //if not yet authorized, force an auth.
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        [_addressBook requestAuthorizationWithCompletion:^(bool granted,
                                                           NSError *error) {
//            [self setupPeople];
        }];
    } else {
//        [self setupPeople];
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
}

- (void)rightBarAction
{
    ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
    controller.peoplePickerDelegate = self;
    [self.viewController.navigationController presentModalViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MDActivityContactTableViewCell";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:identifier];
    }
    
    MDUser *user = [_contacts objectAtIndex:[indexPath row]];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = [NSString
                                 stringWithFormat:@"手机 %@", user.username];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    MDContact *contact = [[MDContact alloc] init];
    contact.firstName =  (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    contact.middleName =  (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    contact.lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableArray *phones = [NSMutableArray array];
    for (int k = 0; k<ABMultiValueGetCount(phone); k++) {
        NSString * personPhone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phone, k);
        [phones addObject:personPhone];
    }
    [_contacts addObject:contact];
    [self.tableView reloadData];
    [peoplePicker dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    RHPerson *rh_person = [_addressBook personForABRecordRef:person];
    BOOL hasManyPhoneNumber = [rh_person.phoneNumbers count] > 1;
    if (hasManyPhoneNumber) {
        return YES;
    } else {
        [peoplePicker dismissModalViewControllerAnimated:YES];
        return NO;
    }
}

@end
