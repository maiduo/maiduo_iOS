//
//  RegisterViewController.m
//  MaiDuo
//
//  Created by D on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDRegisterViewController.h"

@interface MDRegisterViewController ()

@end

@implementation MDRegisterViewController

- (void)addForget
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 30)];
    label.text = @"忘记密码?";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forget)];
    [label addGestureRecognizer:tapGesture];
    [self.myTableView addSubview:label];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *kCellIdentifier = @"Forget";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel * myPlaceHolder = [[UILabel alloc]initWithFrame:
                                                CGRectMake(12, 12, 60, 20)];
    myPlaceHolder.text = [self.myPlaceHolder objectAtIndex:indexPath.row];
    [myPlaceHolder setBackgroundColor:[UIColor clearColor]];
    
    [cell.contentView addSubview:myPlaceHolder];

    UITextField *theTextField = [[UITextField alloc] initWithFrame:
                                                    CGRectMake(72, 12, 300, 20)];
    theTextField.keyboardType = (indexPath.row == 0) ?
                                UIKeyboardTypePhonePad : UIKeyboardTypeDefault;
    theTextField.returnKeyType = UIReturnKeyDone;
    theTextField.secureTextEntry = (indexPath.row != 0);
    theTextField.clearButtonMode = YES;
    theTextField.tag = indexPath.row;
    theTextField.delegate = self;
    [theTextField addTarget:self
                     action:@selector(textFieldWithText:)
           forControlEvents:UIControlEventEditingDidEnd];
    
    if (indexPath.row == 0) {
        [theTextField becomeFirstResponder];
    }
    [cell.contentView addSubview:theTextField];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)forget
{
    
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            NSLog(@"%@",textField.text);
            break;
        case 1:
            NSLog(@"%@",textField.text);
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView = [[UITableView alloc]initWithFrame:
                         CGRectMake(0, 0, 320, self.view.bounds.size.height)
                                                    style:UITableViewStyleGrouped];
    //self.myTableView.backgroundColor = [UIColor redColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    self.myPlaceHolder = @[@"手机号",@"密码"];
    
    [self addForget];
    
    [self titleSet];
}

- (void)titleSet
{
    self.title = @"注册麦垛";
    UIBarButtonItem* reg;
    reg = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemDone
              target:self action:@selector(registerMaiduo)];
    
    [[self navigationItem] setRightBarButtonItem: reg];
}

- (void)registerMaiduo
{
    NSLog(@"reg");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
