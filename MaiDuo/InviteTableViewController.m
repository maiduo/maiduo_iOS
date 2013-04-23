//
//  InviteTableViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "InviteTableViewController.h"
#import "AddressBook/AddressBook.h"
#import "MDContact.h"
#import "pinyin.h"
#import "ctype.h"

// TODO 仅仅做了一个样子，还需要完成对通讯录的上传和其他处理，把查询的代码逻辑转移到专门到
// MDContact做一个充血的领域模型

@interface InviteTableViewController ()

@end

@implementation InviteTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    letters = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K",
                @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V",
                @"W", @"X", @"Y", @"Z", @"#"];
    UIBarButtonItem* buttonInvite;
    buttonInvite = [[UIBarButtonItem alloc]
                    initWithTitle:@"邀请"
                    style:UIBarButtonItemStyleDone
                    target:self
                    action:@selector(didInvited)];
    self.navigationItem.rightBarButtonItem = buttonInvite;
    self.navigationItem.title = @"邀请好友";
    
    ABAddressBookRef addressBook = nil;
    
    group = [NSMutableArray arrayWithCapacity: 27];
    for (NSInteger i = 0; i < 27; i++) {
        group[i] = [NSMutableArray array];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        addressBook = ABAddressBookCreate();
    }
    
    CFArrayRef peoples = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSInteger numberOfPeople = CFArrayGetCount(peoples);
    NSInteger i = 0;
    MDContact* contact;
    NSMutableArray* contacts;
    
    for (;i < numberOfPeople; i++) {
        ABRecordRef people = CFArrayGetValueAtIndex(peoples, i);
        NSString *firstName, *lastName, *middleName;
        firstName = (__bridge NSString*)ABRecordCopyValue(people,
                                                  kABPersonFirstNameProperty);
        lastName = (__bridge NSString*)ABRecordCopyValue(people,
                                                  kABPersonLastNameProperty);
        middleName = (__bridge NSString*)ABRecordCopyValue(people,
                                                  kABPersonMiddleNameProperty);
        
        firstName = nil == firstName ? @"" : firstName;
        lastName  = nil == lastName  ? @"" : lastName;
        middleName = nil == middleName ? @"" : middleName;
        
      
        int first_letter;
        
        if (0 == lastName.length)
            lastName = firstName;
        if (0 == lastName.length)
            lastName = middleName;
        
        if (0 == lastName.length)
            first_letter = 35;
        else
            first_letter = toupper(pinyinFirstLetter([lastName characterAtIndex:0]));
        

        contact = [[MDContact alloc]
                   initWithFirstName:firstName
                   lastName:lastName
                   middleName:middleName
                   phones: nil];
        
        NSLog(@"%c %@ %@ %@", first_letter, lastName, firstName, middleName);
//
//
        if (65 > first_letter || 90 < first_letter)
            first_letter = 91;
        
        
        contacts = (NSMutableArray *)[group objectAtIndex:(first_letter - 65)];
        [contacts addObject: contact];
        NSMutableArray* phones = [self valuesWithProperty:kABPersonPhoneProperty peopel:people];
        for (NSString* value in phones) {
//            NSLog(@"%@", value);
        }
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSMutableArray *)valuesWithProperty:(ABPropertyID)property peopel:(ABRecordRef)people
{
    ABMultiValueRef values = ABRecordCopyValue(people, property);
    CFIndex count = ABMultiValueGetCount(values);
    NSInteger i = 0;
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:(NSInteger)count];
    for(; i<count; i++) {
        [result addObject: (__bridge id)ABMultiValueCopyValueAtIndex(values, i)];
    }
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 27;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* contacts;
    contacts = (NSMutableArray *)[group objectAtIndex: section];
    return [contacts count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return letters;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSInteger character = section;
//    NSLog(@"%d", section);
    if (25 < section) {
        character = -30;
    }
    return [NSString stringWithFormat: @"%c", (character + 65)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"%ld-%ld",
                      (long)[indexPath section], (long)[indexPath row]];
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
    }
    NSArray*  contacts = (NSArray *)[group
                                     objectAtIndex: [indexPath section]];
    MDContact* contact = (MDContact *)[contacts
                                       objectAtIndex: [indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",
                           contact.lastName,
                           contact.middleName,
                           contact.firstName];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
