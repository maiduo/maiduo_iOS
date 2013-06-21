//
//  LoginViewController.m
//  MaiDuo
//
//  Created by 高 欣 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MaiDuo.h"
#import "iToast.h"
#import "MDHTTPAPI.h"
#import "MDLoginViewController.h"
#import "MDRegisterViewController.h"
#import "MDLatestViewController.h"
#import "MDUserManager.h"
#import "MBProgressHUD.h"
#import "MDAppDelegate.h"

#define kLeftMargin				20.0
#define kRightMargin			20.0
#define kTextFieldWidth			160.0
#define kTextFieldHeight		25
#define kOffSet         		160
#define kViewTag				100
@interface MDLoginViewController (){
    MBProgressHUD *_HUD;
}
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) UITextField *txtUser;
@property (nonatomic, retain) UITextField *txtPass;
@end

static NSString *kSourceKey = @"sourceKey";
static NSString *kViewKey = @"viewKey";
@implementation MDLoginViewController

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
    self.navigationItem.title=@"用户登录";
    
    
    UIBarButtonItem *bbiRight=[[UIBarButtonItem alloc]
                               initWithTitle:@"登录"
                               style:UIBarButtonItemStyleDone
                               target:self action:@selector(login)];

    self.navigationItem.rightBarButtonItem = bbiRight;

    UIBarButtonItem *buttonItemRegister;
    buttonItemRegister = [[UIBarButtonItem alloc]
                          initWithTitle:@"注册"
                          style:UIBarButtonItemStyleBordered
                          target:self
                          action:@selector(regAction)];
    self.navigationItem.leftBarButtonItem = buttonItemRegister;
    
    self.dataArray = [NSArray arrayWithObjects:
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"手机号",kSourceKey,
					   self.txtUser,kViewKey,
					   nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"密码",kSourceKey,
					   self.txtPass,kViewKey,
					   nil],
					  nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"用户登录";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"loginCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
	}else {
		UIView *viewToCheck = nil;
		viewToCheck = [cell.contentView viewWithTag:kViewTag];
		if (viewToCheck) {
			[viewToCheck removeFromSuperview];
		}
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	//配置单元格
	cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] valueForKey:kSourceKey];
	UITextField *tmpTxtField = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:kViewKey];
    tmpTxtField.backgroundColor=[UIColor clearColor];
    if(indexPath.row==1){
        tmpTxtField.secureTextEntry=YES;
    }
	[cell.contentView addSubview:tmpTxtField];
	
	return cell;
}

#pragma mark -
#pragma mark TextFields

- (UITextField *)txtUser{
	if (_txtUser == nil) {
		CGRect frame = CGRectMake(kLeftMargin + 80, 10.0, kTextFieldWidth, kTextFieldHeight);
		_txtUser = [[UITextField alloc] initWithFrame:frame];
		_txtUser.borderStyle = UITextBorderStyleNone;
		_txtUser.textColor = [UIColor blackColor];
		_txtUser.font = [UIFont systemFontOfSize:17];
		_txtUser.placeholder = @"请输入用户名";
		_txtUser.backgroundColor = [UIColor whiteColor];
		_txtUser.autocorrectionType = UITextAutocorrectionTypeNo;
		_txtUser.keyboardType = UIKeyboardTypeDefault;
		_txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
		_txtUser.tag = kViewTag;
		_txtUser.delegate = self;
        //_txtUser.text=@"13000000000";
	}
	return _txtUser;
}

- (UITextField *)txtPass{
	if (_txtPass == nil) {
		CGRect frame = CGRectMake(kLeftMargin + 80, 10.0, kTextFieldWidth, kTextFieldHeight);
		_txtPass = [[UITextField alloc] initWithFrame:frame];
		_txtPass.borderStyle = UITextBorderStyleNone;
		_txtPass.textColor = [UIColor blackColor];
		_txtPass.font = [UIFont systemFontOfSize:17];
		_txtPass.placeholder = @"请输入用户密码";
		_txtPass.backgroundColor = [UIColor whiteColor];
		_txtPass.autocorrectionType = UITextAutocorrectionTypeNo;
		_txtPass.keyboardType = UIKeyboardTypeDefault;
		_txtPass.returnKeyType = UIReturnKeyDone;
		_txtPass.clearButtonMode = UITextFieldViewModeWhileEditing;
		_txtPass.tag = kViewTag;
		_txtPass.delegate = self;
        //_txtPass.text=@"13000000000";
	}
	return _txtPass;
}
#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
	return YES;
}
#pragma mark Customer methods
-(void) login
{
    MDUser *user=[MDUserManager sharedInstance].user;
    MDAppDelegate *appDelegate=(MDAppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate showHUDWithLabel:@"正在登录..."];
    [self showHUDWithLabel:@"正在登录..."];
    user.username=_txtUser.text;
    user.password=_txtPass.text;
    user.deviceToken = [MaiDuo sharedInstance].deviceToken;
    [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
        [[MDUserManager sharedInstance] saveSessionWithUser:user];
        //[appDelegate hideHUD];
        [self hideHUD];
        [[MaiDuo sharedInstance] addUser:user];
        [[MaiDuo sharedInstance] addAPI:api user:user];
//        [self.delegate loginViewControllerDidLogin:self];
        MDLatestViewController *latestVC = [[MDLatestViewController alloc] init];
        [self.navigationController pushViewController:latestVC animated:YES];
        
//        [appDelegate.navigationController pushViewController:latestVC animated:YES];
    } failure:^(NSError *error) {
        [self hideHUD];
        [[error userInfo] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"%@", [[error userInfo] objectForKey:key]);
        }];
         [[[iToast makeText:@"登录失败!"] setGravity:iToastGravityCenter] show];
    }];

    // 暂时沿用旧的代码，下次重构应用新的思路
    // [[MDUserManager sharedInstance] setUser:[[MDUser alloc] init]];
    // [_delegate loginViewControllerDidLogin:self];
}

-(void)regAction
{
    [self.navigationController
     pushViewController:[[MDRegisterViewController alloc] initWithStyle:UITableViewStyleGrouped]
     animated:YES];
}


-(void) showHUDWithLabel:(NSString*) text
{
    if(!_HUD){
        _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
	[self.navigationController.view addSubview:_HUD];
	_HUD.labelText = text;
    [_HUD show:YES];
}

-(void) hideHUD
{
    [_HUD hide:YES];
    [_HUD removeFromSuperview];
}

@end
