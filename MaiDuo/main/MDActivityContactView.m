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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        MDContact *item1 = [[MDContact alloc] init];
        item1.firstName = @"三";
        item1.lastName = @"张";
        item1.phones = @[@"900022022",@"992828282"];
        MDContact *item2 = [[MDContact alloc] init];
        item2.firstName = @"三";
        item2.lastName = @"张";
        item2.phones = @[@"900022022",@"992828282"];
        MDContact *item3 = [[MDContact alloc] init];
        item3.firstName = @"三";
        item3.lastName = @"张";
        item3.phones = @[@"900022022",@"992828282"];
        _source = [NSMutableArray arrayWithObjects:item1, item2, item3, nil];
    }
    return self;
}

- (void)rightBarAction
{
    ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
    controller.peoplePickerDelegate = self;
    [self.viewController.navigationController presentModalViewController:controller animated:YES];
}

- (void)reloadData
{
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_source count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MDActivityContactTableViewCell";
//    MDActivityConCell *cell = (MDActivityConCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell==nil) {
//        cell = [[MDActivityConCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//    }
//    cell.item = [_source objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:identifier];
    }
    
//    cell.textLabel.text
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MDActivityConCell heightWithItem:[_source objectAtIndex:indexPath.row]];
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
    [_source addObject:contact];
    [self reloadData];
    [peoplePicker dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

@end
