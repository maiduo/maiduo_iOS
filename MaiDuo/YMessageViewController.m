//
//  YMessageViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-27.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "YMessageViewController.h"

@interface YMessageViewController ()
@end
@implementation YMessageViewController
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:@"新活动"];

	
	tokenFieldView = [[TITokenFieldView alloc] initWithFrame:self.view.bounds];
	[tokenFieldView setSourceArray:user.names];
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
	[messageView setText:@"\n\n\n\n\n\n\n\n活动的第一条消息"];
	[tokenFieldView.contentView addSubview:messageView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
	// You can call this on either the view on the field.
	// They both do the same thing.
	[tokenFieldView becomeFirstResponder];
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
	
	NSArray * names = user.names;
	
	TIToken * token = [tokenFieldView.tokenField addTokenWithTitle:[names objectAtIndex:(arc4random() % names.count)]];
	[token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
	// If the size of the token might change, it's a good idea to layout again.
	[tokenFieldView.tokenField layoutTokensAnimated:YES];
	
	NSUInteger tokenCount = tokenFieldView.tokenField.tokens.count;
	[token setTintColor:((tokenCount % 3) == 0 ? [TIToken redTintColor] : ((tokenCount % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
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

- (NSString *)tokenField:(TITokenField *)tokenField searchResultSubtitleForRepresentedObject:(id)object
{
    return @"移动电话： 13900000000";
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
@end
