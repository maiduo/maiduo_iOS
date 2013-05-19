//
//  YMessageViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-27.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "YMessageViewController.h"
#import "YMessageContactViewController.h"

#define ToolBarNomalFrame CGRectMake(0, 156, 320, 44)
#define TokenFieldViewFrame CGRectMake(0, 0, 320, 156)
#define MaxLength 240
@interface YMessageViewController (){
    PhotoStackView *_photoStack;
    UIButton *_btnDel;
    UILabel *_lblLength;
}
@property (strong,nonatomic) UIImagePickerController *picker;
@property (strong,nonatomic) PhotoStackView *photoStack;
@property (strong,nonatomic) UIToolbar *toolbar;
@property (nonatomic, strong) NSMutableArray *arrayImage;
@end
@implementation YMessageViewController


- (UIImagePickerController *)picker {
    if (!_picker) _picker = [[UIImagePickerController alloc] init];
     
    return _picker;
}
- (UIToolbar *)toolbar {
    if (!_toolbar) _toolbar = [[UIToolbar alloc] initWithFrame:ToolBarNomalFrame];
    return _toolbar;
}
-(PhotoStackView *)photoStack {
    if(!_photoStack) {
        
        self.photoStack = [[PhotoStackView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _photoStack.dataSourceType=DSTypeImage;
        _photoStack.center = CGPointMake(self.view.center.x, 300);
        _photoStack.dataSource = self;
        _photoStack.delegate = self;
        
    }
    
    return _photoStack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
//    [self setToolbarItems:@[camera] animated:YES];
//    self.navigationController.toolbarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [self setupAddressBook];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:@"新活动"];
    user = [YaabUser sharedInstance];
    msg = [[YMessage alloc] init];
	
	tokenFieldView = [[TITokenFieldView alloc] initWithFrame:TokenFieldViewFrame];
	[tokenFieldView setSourceArray:names];
	[self.view addSubview:tokenFieldView];
	
	[tokenFieldView.tokenField setDelegate:self];
	[tokenFieldView.tokenField addTarget:self
                                  action:@selector(tokenFieldFrameDidChange:)
                        forControlEvents:(UIControlEvents)TITokenFieldControlEventFrameDidChange];
	[tokenFieldView.tokenField setTokenizingCharacters:
     [NSCharacterSet characterSetWithCharactersInString:@""]];
	
	UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[addButton addTarget:self
                  action:@selector(showContactsPicker:)
        forControlEvents:UIControlEventTouchUpInside];
	[tokenFieldView.tokenField setRightView:addButton];
    
	[tokenFieldView.tokenField addTarget:self
                                  action:@selector(tokenFieldChangedEditing:)
                        forControlEvents:UIControlEventEditingDidBegin];
	[tokenFieldView.tokenField addTarget:self
                                  action:@selector(tokenFieldChangedEditing:)
                        forControlEvents:UIControlEventEditingDidEnd];
	
	messageView = [[UITextView alloc] initWithFrame:tokenFieldView.contentView.bounds];
	[messageView setScrollEnabled:NO];
	[messageView setAutoresizingMask:UIViewAutoresizingNone];
	[messageView setDelegate:self];
	[messageView setFont:[UIFont systemFontOfSize:15]];
	[messageView setText:@"活动的第一条消息"];
    messageView.returnKeyType=UIReturnKeyDone;
	[tokenFieldView.contentView addSubview:messageView];
	
    id center = [NSNotificationCenter defaultCenter];
	[center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
	[center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    // 键盘切换事件
    [center addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version >= 5.0) {
//        [center addObserver:self
//                   selector:@selector(keyboardWillShow:)
//                       name:UIKeyboardWillChangeFrameNotification
//                     object:nil];
//    }
    
    UIBarButtonItem *camera;
    camera = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
              target:self
              action:@selector(photo:)];
    UIBarButtonItem *flexItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexItem.width=220;
    _lblLength=[[UILabel alloc] initWithFrame:(CGRect){CGPointZero,{32,80}}];
    _lblLength.text=[NSString stringWithFormat:@"%d/%d",0,MaxLength];
    _lblLength.backgroundColor=[UIColor clearColor];
    _lblLength.textColor=[UIColor whiteColor];
    _lblLength.font=[UIFont systemFontOfSize:11.0f];
    UIBarButtonItem *lengthItem=[[UIBarButtonItem alloc] initWithCustomView:_lblLength];
    lengthItem.width=80;
    [self toolbar].items=@[camera,flexItem,lengthItem];
    [self.view addSubview:_toolbar];
    [self.view addSubview:[self photoStack]];
    _photoStack.hidden=YES;
    _btnDel=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnDel.frame=CGRectMake(self.view.bounds.size.width-37, self.view.bounds.size.height-84, 30, 30);
    _btnDel.hidden=YES;
    [_btnDel setImage:[UIImage imageNamed:@"garbage"] forState:UIControlStateNormal];
    [_btnDel setImage:[UIImage imageNamed:@"garbage_s"] forState:UIControlStateSelected];
    [self.view addSubview:_btnDel];
    _arrayImage=[[NSMutableArray alloc] init];
    
    
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
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"RHAuthorizationStatusRestricted"
                              message:@"Access to the addressbook is currently restricted."
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
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
                                                 identifier:j];
            [names addObject: contact];
        }
    }
    NSLog(@"Names length: %d", names.count);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//	[UIView animateWithDuration:duration animations:^{[self resizeViews];}]; // Make it pweeetty.
//}
//
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//	[self resizeViews];
//}

- (void)showContactsPicker:(id)sender {
	
	// Show some kind of contacts picker in here.
	// For now, here's how to add and customize tokens.
	
    ABPeoplePickerNavigationController *picker;
    picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.addressBook = addressBookRef;
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void) photo:(id) sender
{
    [self takePictureBySourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
-(void) takePictureBySourceType:(UIImagePickerControllerSourceType) sourceType
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    self.picker.sourceType = sourceType;

    [self presentModalViewController:self.picker animated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
//	CGRect kbRect = [[[notification userInfo]
//                        objectForKey:UIKeyboardFrameEndUserInfoKey]
//                       CGRectValue];
//    keyboardHeight = kbRect.size.height;
//    
//	[self resizeViews];
    NSDictionary *info = [notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"kbHeight: %f", kbHeight);
    
    // 抬高工具栏
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = _toolbar.center;
        center.y = self.view.frame.size.height - 22 - kbHeight;
        _toolbar.center = center;
        
        
        [tokenFieldView setFrame:((CGRect){
            tokenFieldView.frame.origin,
            {
                self.view.bounds.size.width,
                self.view.bounds.size.height - _toolbar.frame.origin.y-44
            }})];
        [messageView setFrame:tokenFieldView.contentView.bounds];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _toolbar.frame=ToolBarNomalFrame;
//	keyboardHeight = 0;
//	[self resizeViews];
    
}

- (void)resizeViews {
//    UIToolbar *toolbar = [self toolbar];
//    CGFloat toolbarWidth  = toolbar.frame.size.width;
//    CGFloat toolbarHeight = toolbar.frame.size.height;
//    CGFloat applicationHeight = [[UIScreen mainScreen]
//                                 applicationFrame].size.height;
////    CGFloat statusBarHeight = [[UIApplication sharedApplication]
////                               statusBarFrame].size.height;
//    CGFloat messageViewHeight = applicationHeight - keyboardHeight -
//                                toolbarHeight-44;
//    
//    int tabBarOffset = self.tabBarController == nil ? 0 :
//                       self.tabBarController.tabBar.frame.size.height;
//    
//    [toolbar setFrame:CGRectMake(0.0f, messageViewHeight, toolbarWidth,
//                                 toolbarHeight)];
    
//    [tokenFieldView setFrame:((CGRect){
//        tokenFieldView.frame.origin,
//        {
//            self.view.bounds.size.width,
//            self.view.bounds.size.height - keyboardHeight
//        }})];
//	[messageView setFrame:tokenFieldView.contentView.bounds];
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
#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
	//NSLog(@"Toolbar height:%f", self.navigationController.toolbar.frame.size.height);
    _lblLength.text=[NSString stringWithFormat:@"%d/%d",MaxLength-textView.text.length,MaxLength];
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        [tokenFieldView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

- (YPlainContact *)contactByPerson:(RHPerson *)person
                        identifier:(int)identifier
{
    __block YPlainContact *contact;
    [names enumerateObjectsUsingBlock:^(YPlainContact* _contact, NSUInteger idx,
                                        BOOL *stop) {
        if (_contact.identifier == identifier && _contact.person == person) {
            contact = _contact;
            *stop = YES;
        }
    }];
    
    return contact;
}

// FIXME 每次都会得到一个复制的副本
- (BOOL)hasContact:(YPlainContact *)contact
{
    NSArray *copy = [[tokenFieldView tokenField] tokenObjects];
    YPlainContact *_contact;
    BOOL found = NO;
    for (NSInteger i=0, size = [copy count]; i < size; i++) {
        _contact = (YPlainContact *)[copy objectAtIndex:i];
        if (_contact == contact) {
            found = YES;
        }
    };
    
    return found;
}





#pragma mark -
#pragma mark ImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(image){
        _photoStack.hidden=NO;
        [_arrayImage insertObject:image atIndex:0];
        [_photoStack reloadData];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Deck DataSource Protocol Methods

-(NSUInteger)numberOfPhotosInPhotoStackView:(PhotoStackView *)photoStack {
    NSInteger count=[_arrayImage count];
    _btnDel.hidden=count==0;
    return count;
}

-(UIImage *)photoStackView:(PhotoStackView *)photoStack imageForIndex:(NSUInteger)index {
    UIImage *image=[_arrayImage objectAtIndex:index];
    return image;
}



#pragma mark -
#pragma mark Deck Delegate Protocol Methods

-(void)photoStackView:(PhotoStackView *)photoStackView willStartMovingPhotoAtIndex:(NSUInteger)index {
    // User started moving a photo
}

-(void)photoStackView:(PhotoStackView *)photoStackView willFlickAwayPhotoAtIndex:(NSUInteger)index {
    // User flicked the photo away, revealing the next one in the stack
}

//-(void)photoStackView:(PhotoStackView *)photoStackView didRevealPhotoAtIndex:(NSUInteger)index {
//    self.pageControl.currentPage = index;
//}

-(void)photoStackView:(PhotoStackView *)photoStackView didSelectPhotoAtIndex:(NSUInteger)index {
    NSLog(@"selected %d", index);
}
-(void) photoStackView:(PhotoStackView *)photoStackView selectPhotoFrame:(CGRect)frame{
    frame.origin.y=frame.origin.y+_photoStack.frame.origin.y;
    frame.origin.x=frame.origin.x+_photoStack.frame.origin.x;
    //判断图片和删除按钮是否相交
    [_btnDel setSelected:CGRectIntersectsRect(frame,_btnDel.frame )];
    
}
-(BOOL) shouldDeletePhoto{
    return  _btnDel.isSelected;
}
-(void)photoStackView:(PhotoStackView *)photoStackView didDeletePhotoAtIndex:(NSUInteger)index {
    [_arrayImage removeObjectAtIndex:index];
    [_photoStack reloadData];
    [_btnDel setSelected:NO];
}

# pragma mark - TITokenField Delegate methods -
- (BOOL)tokenField:(TITokenField *)tokenField willAddToken:(TIToken *)token
{
    if (nil == token.representedObject)
        return NO;
    // FIXME 给TITokenField增加取消Tokenize的功能的开关
    // 处理重复的联系人，暂时在上传数据时筛选。
//    if ([self hasContact:token.representedObject])
//        return NO;
    return YES;
}

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
//    YPlainContact *contact = [[YPlainContact alloc] initWithPerson:aPerson
//                                                          property:property
//                                                        identifier:identifier];
    YPlainContact *contact = [self contactByPerson:aPerson
                                        identifier:identifier];
    [msg addContact:contact];
    [tokenFieldView.tokenField addTokenWithTitle:[aPerson getFullName] representedObject:contact];
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


#pragma mark - Custom Method -
-(void) clearContent
{
    messageView.text=@"";
    [_arrayImage removeAllObjects];
    _photoStack.hidden=YES;
    [_photoStack reloadData];
    
}
@end
