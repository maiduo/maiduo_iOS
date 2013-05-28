//
//  PersonDetailViewController.m
//  MaiDuo
//
//  Created by yzf on 13-5-9.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDPersonDetailViewController.h"
#import "MDUserManager.h"
#import "MDHTTPAPI.h"
#import <QuartzCore/QuartzCore.h>

@interface MDPersonDetailViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MDEditViewControllerDelegate> {
}

@end

@implementation MDPersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _api = [[YaabUser sharedInstance] api];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_user) {
        _user = [[MDUserManager sharedInstance].user copy];
    }
    
    self.title = @"个人资料";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(backAction)];
}

- (BOOL)isUserSelf
{
    return [MDUserManager sharedInstance].user.userId==_user.userId;
}

- (void)backAction
{
    if ([self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}

- (void)photoAction
{
    if ([self isUserSelf]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传头像"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"立即拍摄",
                                @"选择照片", nil];
        [sheet showInView:self.navigationController.view];
    }
}

- (void)logoutAction
{
    [[MDUserManager sharedInstance] logout];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self isUserSelf]) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.contentView.layer.cornerRadius = 7;
        cell.contentView.backgroundColor = [UIColor redColor];
        cell.textLabel.text = @"退出登陆";
        
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(logoutAction)]];
        
        return cell;
    } else {
        static NSString *identifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        if ([self isUserSelf]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.accessoryView = nil;
        if (indexPath.section==0) {
            cell.textLabel.text = @"用户头像";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
            imgView.userInteractionEnabled = YES;
            imgView.layer.cornerRadius = 5.0f;
            imgView.clipsToBounds = YES;
            imgView.backgroundColor = [UIColor grayColor];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoAction)]];
            if ([_user.avatar hasPrefix:@"/"]) {
                [imgView setImageURL:[NSURL fileURLWithPath:_user.avatar]];
            } else {
                [imgView setImageURL:[NSURL URLWithString:_user.avatar]];
            }
            cell.accessoryView = imgView;
        } else if (indexPath.section==1) {
            if (indexPath.row==0) {
                cell.textLabel.text = @"姓名";
                cell.detailTextLabel.text = _user.name;
            } else {
                cell.textLabel.text = @"电话";
                cell.detailTextLabel.text = _user.username;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        return cell;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"您的设备不支持拍照" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
            return;
        }
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = YES;
        controller.delegate = self;
        [self.navigationController presentModalViewController:controller animated:YES];
    } else if (buttonIndex==1) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = YES;        
        controller.delegate = self;
        [self.navigationController presentModalViewController:controller animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![self isUserSelf]) {
        return;
    }
    if (indexPath.section==1&&indexPath.row==0) {
        MDEditViewController *controller = [[MDEditViewController alloc] init];
        controller.value = _user.name;
        controller.title = @"姓名";
        controller.hint = @"不要超过10个字";
        controller.key = @"name";
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row==2) {
        //todo退出登陆
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *avatar = [info objectForKey:UIImagePickerControllerEditedImage]; //头像文件
    CGSize destinationSize = CGSizeMake(400.0f, 400.0f);
    UIGraphicsBeginImageContext(destinationSize);
    [avatar drawInRect:CGRectMake(0, 0, destinationSize.width,
                                  destinationSize.height)];
    UIImage *smallAvatar = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData *headData = UIImageJPEGRepresentation(smallAvatar, 0.5);
    // NSData *headData = UIImagePNGRepresentation(smallAvatar); //二进制数据
    [_api uploadAvatar:headData
                  user:_user
              progress:^(NSUInteger bytesWritten,
                                           long long totalBytesWritten,
                                           long long totalBytesExpectedToWrite) {
        NSLog(@"上传数据 %lld ", totalBytesWritten / totalBytesExpectedToWrite);
    }
               success:^{
        NSLog(@"上传头像完成。");
    }
               failure:^(NSError *error) {
        NSLog(@"上传头像失败。");
    }];
    //todo 调用上传接口上传头像
    
    [picker dismissModalViewControllerAnimated:YES];    
    
    //以下为测试
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *headPath = [docPath stringByAppendingString:@"/head.png"];
    [headData writeToFile:headPath atomically:YES];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MDEditViewControllerDelegate

- (void)editViewControllerDidEdit:(MDEditViewController *)controller text:(NSString *)text
{
    if ([controller.key isEqualToString:@"name"]) {
        _user.name = text;
        [self.tableView reloadData];
    }
}

@end

@implementation MDEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"返回";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, 39)];
    _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.text = _value;
    [self.view addSubview:_textField];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textField.left, _textField.bottom+10, _textField.width, 16)];
    hintLabel.font = [UIFont systemFontOfSize:16];
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.text = _hint;
    [self.view addSubview:hintLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_textField becomeFirstResponder];
}

#pragma mark - Actions

- (void)doneAction
{
    [_delegate editViewControllerDidEdit:self text:_textField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneAction];
    return YES;
}

@end

