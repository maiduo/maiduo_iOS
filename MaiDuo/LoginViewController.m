//
//  LoginViewController.m
//  MaiDuo
//
//  Created by 高 欣 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "LoginViewController.h"
#import "LatestViewController.h"
#import "MDHTTPAPI.h"
#import "YaabUser.h"
#import "iToast.h"

#define kLeftMargin				20.0
#define kRightMargin			20.0
#define kTextFieldWidth			160.0
#define kTextFieldHeight		25
#define kOffSet         		160
#define kViewTag				100
@interface LoginViewController ()
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) UITextField *txtUser;
@property (nonatomic, retain) UITextField *txtPass;
@end

static NSString *kSourceKey = @"sourceKey";
static NSString *kViewKey = @"viewKey";
@implementation LoginViewController

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    
    
    UIBarButtonItem *bbiRight=[[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    self.navigationItem.rightBarButtonItem = bbiRight;
    
    self.dataArray = [NSArray arrayWithObjects:
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"用  户  名：",kSourceKey,
					   self.txtUser,kViewKey,
					   nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"用户密码：",kSourceKey,
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
        _txtUser.text=@"13000000000";
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
        _txtPass.text=@"13000000000";
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
    MDUser *user=[YaabUser default].user;
    user.username=_txtUser.text;
    user.password=_txtPass.text;
    [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
        LatestViewController *latestVC = [[LatestViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:latestVC animated:YES];
    } failure:^(NSError *error) {
         [[[iToast makeText:@"登录失败!"] setGravity:iToastGravityCenter] show];
    }];

}
@end
