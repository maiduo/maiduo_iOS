//
//  YMessageViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-27.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "YMessageViewController.h"
#import "YMessageContactViewController.h"

@interface YMessageViewController ()
@end
@implementation YMessageViewController
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *camera;
    camera = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
              target:nil
              action:nil];
    [self setToolbarItems:@[camera] animated:YES];
    self.navigationController.toolbarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [self setupAddressBook];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:@"新活动"];
    user = [YaabUser default];
    msg = [[YMessage alloc] init];
	
	tokenFieldView = [[TITokenFieldView alloc] initWithFrame:self.view.bounds];
	[tokenFieldView setSourceArray:names];
	[self.view addSubview:tokenFieldView];
	
	[tokenFieldView.tokenField setDelegate:self];
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:TITokenFieldControlEventFrameDidChange];
	[tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;."]]; // Default is a comma
	
	UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[tokenFieldView.tokenField setRightView:addButton];
    
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
	
	messageView = [[UITextView alloc] initWithFrame:tokenFieldView.contentView.bounds];
	[messageView setScrollEnabled:NO];
	[messageView setAutoresizingMask:UIViewAutoresizingNone];
	[messageView setDelegate:self];
	[messageView setFont:[UIFont systemFontOfSize:15]];
	[messageView setText:@"活动的第一条消息"];
	[tokenFieldView.contentView addSubview:messageView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
	[tokenFieldView becomeFirstResponder];
}

- (void)setupAddressBook
{
    addressBook = [[RHAddressBook alloc] init];
    //if not yet authorized, force an auth.
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        [addressBook requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            [self setupPeople];
        }];
    } else {
        [self setupPeople];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RHAuthorizationStatusRestricted" message:@"Access to the addressbook is currently restricted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setupPeople
{
    NSArray *people = [addressBook peopleOrderedByLastName];
    [addressBook performAddressBookAction:^(ABAddressBookRef _addressBookRef) {
        addressBookRef = _addressBookRef;
    } waitUntilDone:YES];
    
    int count = [people count];
    names = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        RHPerson *person = (RHPerson *)[people objectAtIndex: i];
        
        RHMultiStringValue *phoneNumbers = [person phoneNumbers];
        for (int j = 0, c = [phoneNumbers count]; j < c; j++) {
            YPlainContact *contact;
            contact = [[YPlainContact alloc] initWithPerson:person
                                                   property:kABPersonPhoneProperty
                                                 identifier:i];
            [names addObject: contact];
        }
    }
    NSLog(@"Names length: %d", names.count);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{[self resizeViews];}]; // Make it pweeetty.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self resizeViews];
}

- (void)showContactsPicker:(id)sender {
	
	// Show some kind of contacts picker in here.
	// For now, here's how to add and customize tokens.
	
    ABPeoplePickerNavigationController *picker;
    picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.addressBook = addressBookRef;
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect kbRect = [[[notification userInfo]
                        objectForKey:UIKeyboardFrameEndUserInfoKey]
                       CGRectValue];
    keyboardHeight = kbRect.size.height;
    
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	keyboardHeight = 0;
	[self resizeViews];
}

- (void)resizeViews {
    UIToolbar *toolbar = self.navigationController.toolbar;    
    CGFloat toolbarWidth  = toolbar.frame.size.width;
    CGFloat toolbarHeight = toolbar.frame.size.height;
    CGFloat applicationHeight = [[UIScreen mainScreen]
                                 applicationFrame].size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication]
                               statusBarFrame].size.height;
    CGFloat messageViewHeight = applicationHeight - keyboardHeight -
                                toolbarHeight + statusBarHeight;
    
    int tabBarOffset = self.tabBarController == nil ? 0 :
                       self.tabBarController.tabBar.frame.size.height;
    
    [toolbar setFrame:CGRectMake(0.0f, messageViewHeight, toolbarWidth,
                                 toolbarHeight)];
    
    [tokenFieldView setFrame:((CGRect){
        tokenFieldView.frame.origin,
        {
            self.view.bounds.size.width,
            self.view.bounds.size.height + tabBarOffset - keyboardHeight
        }})];
	[messageView setFrame:tokenFieldView.contentView.bounds];
}

- (BOOL)tokenField:(TITokenField *)tokenField willRemoveToken:(TIToken *)token {
	
	if ([token.title isEqualToString:@"Tom Irving"]){
		return NO;
	}
	
	return YES;
}

- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
	[tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
	[self textViewDidChange:messageView];
}

- (void)textViewDidChange:(UITextView *)textView
{
	NSLog(@"Toolbar height:%f", self.navigationController.toolbar.frame.size.height);
	CGFloat oldHeight = tokenFieldView.frame.size.height - tokenFieldView.tokenField.frame.size.height;
	CGFloat newHeight = textView.contentSize.height + textView.font.lineHeight;
	
	CGRect newTextFrame = textView.frame;
	newTextFrame.size = textView.contentSize;
	newTextFrame.size.height = newHeight;
	
	CGRect newFrame = tokenFieldView.contentView.frame;
	newFrame.size.height = newHeight;
	
	if (newHeight < oldHeight){
		newTextFrame.size.height = oldHeight;
		newFrame.size.height = oldHeight;
	}
    
	[tokenFieldView.contentView setFrame:newFrame];
	[textView setFrame:newTextFrame];
	[tokenFieldView updateContentSize];
}

# pragma mark - TITokenField Delegate methods -

- (NSString *)tokenField:(TITokenField *)tokenField searchResultSubtitleForRepresentedObject:(id)object
{
    YPlainContact *contact = (YPlainContact *)object;
    RHPerson *person = contact.person;
    NSString *label, *value;
    if ( kABPersonPhoneProperty == contact.property) {
        label = [[person phoneNumbers]
                           localizedLabelAtIndex:contact.identifier];
        value = (NSString *)[[person phoneNumbers]
                                             valueAtIndex:contact.identifier];
    }
    return [NSString stringWithFormat:@"%@ %@", label, value];
}

- (NSString *)tokenField:(TITokenField *)tokenField
displayStringForRepresentedObject:(id)object
{
    YPlainContact *contact = (YPlainContact *)object;
    return [contact.person getFullName];
}

- (NSString *)tokenField:(TITokenField *)tokenField
searchResultStringForRepresentedObject:(id)object
{
    return [self tokenField:tokenField
displayStringForRepresentedObject:object];
}

#pragma mark - ABPeoplePickerNavigationController Delegate -
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    RHPerson *aPerson = [addressBook personForABRecordRef:person];
    YPlainContact *contact = [[YPlainContact alloc] initWithPerson:aPerson
                                                          property:property
                                                        identifier:identifier];
    [msg addContact:contact];
    [tokenFieldView.tokenField addTokenWithTitle: [aPerson getFullName]];
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    RHPerson *rh_person = [addressBook personForABRecordRef:person];
    BOOL hasManyPhoneNumber = [rh_person.phoneNumbers count] > 1;
    if (hasManyPhoneNumber) {
        return YES;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
}
@end
