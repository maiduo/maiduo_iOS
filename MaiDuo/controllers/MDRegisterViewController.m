//
//  RegisterViewController.m
//  MaiDuo
//
//  Created by D on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDRegisterViewController.h"

@interface MDRegisterViewController () {
    UITextField *_phoneText;
    UITextField *_passText;
    UITextField *_nameText;
}

@end

@implementation MDRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册麦垛";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    
    _phoneText = [self createTextField];
    _passText = [self createTextField];
    _nameText = [self createTextField];
    
    _phoneText.keyboardType = UIKeyboardTypePhonePad;
    _phoneText.returnKeyType = UIReturnKeyNext;
    
    _passText.secureTextEntry = YES;
    _passText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passText.returnKeyType = UIReturnKeyNext;
    
    _nameText.keyboardType = UIKeyboardTypeNamePhonePad;
    _nameText.returnKeyType = UIReturnKeyDone;
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.text = @"忘记密码?";
    bottomLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    bottomLabel.font = [UIFont systemFontOfSize:16];
    bottomLabel.textAlignment = UITextAlignmentCenter;
    self.tableView.tableFooterView = bottomLabel;
}

- (UITextField *)createTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, 240, 40)];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    return textField;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_phoneText becomeFirstResponder];
}

#pragma mark - Actions

- (void)doneAction
{
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"电话";
            cell.accessoryView = _phoneText;
            break;
        case 1:
            cell.textLabel.text = @"密码";
            cell.accessoryView = _passText;
            break;
        default:
            cell.textLabel.text = @"姓名";
            cell.accessoryView = _nameText;
            break;
    }
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_phoneText) {
        [_passText becomeFirstResponder];
    } else if (textField==_passText) {
        [_nameText becomeFirstResponder];
    } else {
        [self doneAction];
    }
    return YES;
}

@end
