//
//  SendMessageTableViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDWriteMessageViewController.h"
#import "MDAppDelegate.h"
#import "PHTextView.h"
#define MaxTextLength 200
@interface MDWriteMessageViewController (){
    UINavigationController *_navigationPicker;
    CGFloat spacing;
    IBOutlet PHTextView *_tvMessage;
    IBOutlet UILabel *_lblLength;
    IBOutlet UIView *_toolBar;
    IBOutlet GMGridView *_gridView;
    IBOutlet UIButton *_buttonPhoto;
    
}
-(IBAction)photo:(id)sender;
@end
@implementation MDWriteMessageViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setupGridView];
    [_gridView reloadData];
    
}
 
//- (void)didTapClose:(id)sender
//{
//    [self dismissModalViewControllerAnimated:YES];
//}

- (void)didTapPublish:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    self.navigationItem.title = @"新消息";
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc]
                             initWithTitle:@"发布"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(didTapPublish:)];
//    UIBarButtonItem *close = [[UIBarButtonItem alloc]
//                              initWithTitle:@"取消"
//                              style:UIBarButtonItemStyleBordered
//                              target:self
//                              action:@selector(didTapClose:)];
    
    self.navigationItem.rightBarButtonItem = send;
    //self.navigationItem.leftBarButtonItem = close;
    spacing=4.0f;
    _tvMessage.placehold=@"请写些什么吧";
    [_tvMessage becomeFirstResponder];
    _lblLength.text=[NSString stringWithFormat:@"0/%d",MaxTextLength];
    
    // 键盘切换事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoardEvent:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}
- (void)setupGridView
{
    //    UIImage *asset1 = [UIImage
    //                       imageWithContentsOfFile:[[NSBundle mainBundle]
    //                                                pathForResource:@"default_avatar"
    //                                                ofType:@"jpg"]];
    
    self.assets = [NSMutableArray array];
    //    for (NSInteger i = 0; i < 50; i++)
    //        [_assets addObject:@"assets-library://asset/asset.PNG?id=0FA66916-F06B-45ED-80D3-50FAD6B6DB0E&ext=PNG"];
    _library = [[ALAssetsLibrary alloc] init];
    
    //NSInteger spacing = INTERFACE_IS_PHONE ? 4 : 15;
    
    _cellSize = CGSizeMake(75.0f, 75.0f);
    
    _gridView.style = GMGridViewStyleSwap;
    _gridView.itemSpacing = spacing;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gridView.centerGrid = NO;
  
    
}




- (void)willOpenImagePicker:(id)sender
{
    QBImagePickerController *picker = [[QBImagePickerController alloc] init];
    
    NSMutableOrderedSet *selectedAssets=[[NSMutableOrderedSet alloc] init];
    [_assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedAssets addObject:obj];
    }];
    
    
    picker.delegate = self;
    picker.filterType = QBImagePickerFilterTypeAllPhotos;
    picker.showsCancelButton = YES;
    picker.fullScreenLayoutEnabled = YES;
    picker.allowsMultipleSelection = YES;
    
    picker.limitsMaximumNumberOfSelection = YES;
    picker.maximumNumberOfSelection = 20;
    
    
    if(!_navigationPicker){
        _navigationPicker = [[UINavigationController alloc] initWithRootViewController:picker];
    }
    
    [[MDAppDelegate sharedInstance].navigationController presentModalViewController:_navigationPicker animated:YES];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    //初始有个添加按钮
    return _assets.count+1;
}

- (CGSize)GMGridView:(GMGridView *)gridView
sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return _cellSize;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView
            cellForItemAtIndex:(NSInteger)index
{
    //    CGSize size = [self GMGridView:gridView
    //sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication]
    //                                    statusBarOrientation]];
    
    if(index==_assets.count){
        GMGridViewCell *cell = [[GMGridViewCell alloc] init];
        UIButton *deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageReleased=[UIImage imageNamed:@"imagepicker_add_photo_button_released"];
        UIImage *imagePressed=[UIImage imageNamed:@"imagepicker_add_photo_button_pressed"];
        [deleteButton setImage:imageReleased forState:UIControlStateNormal];
        [deleteButton setImage:imagePressed forState:UIControlStateHighlighted];
        cell.contentView = deleteButton;
        return cell;
    }
    
    
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    NSString *reference = [_assets objectAtIndex:index];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
    }
    
    __block UIImageView *image_view;
    //        imageView.frame = CGRectMake(0.0f, 0.0f, _cellSize.width, _cellSize.height);
    
    ALAssetsLibraryAssetForURLResultBlock result_block = ^(ALAsset *asset)
    {
        image_view = [[UIImageView alloc]
                      initWithImage:[UIImage
                                     imageWithCGImage:asset.thumbnail]];
        cell.contentView = image_view;
    };
    
    ALAssetsLibraryAccessFailureBlock failure_block = ^(NSError *error)
    {
    };
    //        NSLog(@"asset library url %@", reference);
    NSURL *asset_url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", reference]];
    [_library assetForURL:asset_url
              resultBlock:result_block
             failureBlock:failure_block];
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    NSLog(@"%f %f %f %f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return index>0;
    //return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView
didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    if(position==self.assets.count){
        [self willOpenImagePicker:nil];
    }
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView
processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    //    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        //        [_gridView removeObjectAtIndex:_lastDeleteItemIndexAsked
        //                         withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView
didStartMovingCell:(GMGridViewCell *)cell
{
//    [UIView animateWithDuration:0.3
//                          delay:0
//                        options:UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         cell.contentView.backgroundColor = [UIColor orangeColor];
//                         //                         cell.contentView.layer.shadowOpacity = 0.7;
//                     }
//                     completion:nil
//     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
//    [UIView animateWithDuration:0.3
//                          delay:0
//                        options:UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         cell.contentView.backgroundColor = [UIColor redColor];
//                         //                         cell.contentView.layer.shadowOpacity = 0;
//                     }
//                     completion:nil
//     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView
shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell
           atIndex:(NSInteger)index
{
    return index!=self.assets.count;
}

- (void)GMGridView:(GMGridView *)gridView
   moveItemAtIndex:(NSInteger)oldIndex
           toIndex:(NSInteger)newIndex
{
    NSObject *object = [_assets objectAtIndex:oldIndex];
    [_assets removeObject:object];
    [_assets insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView
exchangeItemAtIndex:(NSInteger)index1
   withItemAtIndex:(NSInteger)index2
{
    //    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView
sizeInFullSizeForCell:(GMGridViewCell *)cell
             atIndex:(NSInteger)index
inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return _cellSize;
    
     
}

- (UIView *)GMGridView:(GMGridView *)gridView
   fullSizeViewForCell:(GMGridViewCell *)cell
               atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    //    fullView.layer.masksToBounds = NO;
    //    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    label.font = [UIFont boldSystemFontOfSize:15];
        
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView
didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         //                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView
didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         //                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    MDAppDelegate *delegate = (MDAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController
didFinishPickingMediaWithInfo:(id)info
{
    [_assets removeAllObjects];
    if(imagePickerController.allowsMultipleSelection) {
        NSArray *infoArray = (NSArray *)info;
        
        [infoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx,
                                                BOOL *stop) {
            NSString *asset;
            asset = [obj objectForKey:@"UIImagePickerControllerReferenceURL"];
            [self.assets addObject:asset];
            
            //            [_gridView insertObjectAtIndex:self.assets.count - 1
            //                             withAnimation:GMGridViewItemAnimationFade|
            //             GMGridViewItemAnimationScroll];
        }];
    }
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        [_gridView reloadData];
        
    }];
}
#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    _lblLength.text=[NSString stringWithFormat:@"%d/%d",textView.text.length,MaxTextLength];
    //if([textView.text length]==0){
        [textView setNeedsDisplay];
    //}

    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
 
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _buttonPhoto.selected=NO;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _buttonPhoto.selected=YES;
}
#pragma mark -
#pragma mark KeyBoard delegate
- (void)showKeyBoardEvent:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CLog(@"kbHeight: %f", kbHeight);
    
    // 抬高工具栏
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = _toolBar.center;
        center.y = self.view.frame.size.height - 22 - kbHeight;
        _toolBar.center = center;
    }];
}
#pragma mark -
#pragma mark IBAction
-(IBAction) photo:(id)sender
{
    UIButton *button=sender;
    if(button.isSelected){
        button.selected=NO;
        [_tvMessage becomeFirstResponder];
    }else{
        button.selected=YES;
        [_tvMessage resignFirstResponder];
        //[self willOpenImagePicker:nil];
    }
}
@end;