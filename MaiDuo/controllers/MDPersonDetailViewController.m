//
//  PersonDetailViewController.m
//  MaiDuo
//
//  Created by yzf on 13-5-9.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDPersonDetailViewController.h"
#import "MDUserManager.h"
#import <QuartzCore/QuartzCore.h>

@interface MDPersonDetailViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MDPersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(backAction)];
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"立即拍摄", @"选择照片", nil];
    [sheet showInView:self.navigationController.view];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    if (indexPath.section==[self numberOfSectionsInTableView:tableView]-1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.contentView.layer.cornerRadius = 10;
        cell.contentView.backgroundColor = [UIColor redColor];
        cell.textLabel.text = @"退出登陆";
        return cell;
    } else {
        static NSString *identifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            if ([[MDUserManager sharedInstance].user.avatar hasPrefix:@"/"]) {
                [imgView setImageURL:[NSURL fileURLWithPath:[MDUserManager sharedInstance].user.avatar]];
            } else {
                [imgView setImageURL:[NSURL URLWithString:[MDUserManager sharedInstance].user.avatar]];
            }
            
            
            cell.accessoryView = imgView;
        } else if (indexPath.section==1) {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"姓名";
                    cell.detailTextLabel.text = [MDUserManager sharedInstance].user.username;
                    break;
                default:
                    cell.textLabel.text = @"电话";
                    cell.detailTextLabel.text = [MDUserManager sharedInstance].user.phone;
                    break;
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
    if (indexPath.row==1) {
        //todo编辑用户信息
    } else if (indexPath.row==2) {
        //todo退出登陆
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *headImg = [info objectForKey:UIImagePickerControllerEditedImage]; //头像文件
    NSData *headData = UIImagePNGRepresentation(headImg); //二进制数据
    //todo 调用上传接口上传头像
    
    [picker dismissModalViewControllerAnimated:YES];    
    
    //以下为测试
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *headPath = [docPath stringByAppendingString:@"/head.png"];
    [headData writeToFile:headPath atomically:YES];
    [MDUserManager sharedInstance].user.avatar = headPath;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
