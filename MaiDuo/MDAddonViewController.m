//
//  MDAddonViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-29.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDAddonViewController.h"

@interface MDAddonViewController ()

@end

@implementation MDAddonViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setupGridView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupGridView
{
    UIImage *asset1 = [UIImage
                       imageWithContentsOfFile:[[NSBundle mainBundle]
                                                pathForResource:@"default_avatar"
                                                ofType:@"jpg"]];
    _assets = [NSMutableArray arrayWithArray: @[asset1,asset1,asset1,asset1,
               asset1,asset1,asset1,asset1]];
    
    NSInteger spacing = INTERFACE_IS_PHONE ? 4 : 15;
    
    _cellSize = CGSizeMake(75.0f, 75.0f);

    _gridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.style = GMGridViewStyleSwap;
    _gridView.itemSpacing = spacing;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gridView.centerGrid = NO;
    _gridView.actionDelegate = self;
    _gridView.sortingDelegate = self;
    _gridView.transformDelegate = self;
    _gridView.dataSource = self;
    
    [self.view addSubview:_gridView];
    
    UIBarButtonItem *buttonOpenImagePicker;
    buttonOpenImagePicker = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                 target:self
                 action:@selector(willOpenImagePicker:)];
    self.navigationItem.rightBarButtonItem = buttonOpenImagePicker;
    self.navigationItem.title = @"消息内容";
}

- (void)willOpenImagePicker:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    NSArray *mediaYypes = [UIImagePickerController
                            availableMediaTypesForSourceType:picker.sourceType];
    picker.mediaTypes = mediaYypes;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:picker animated:YES];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return _assets.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView
sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return _cellSize;
    
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(170, 135);
        }
        else
        {
            return CGSizeMake(140, 110);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(230, 175);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView
            cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView
sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication]
                                    statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIImageView *image = [[UIImageView alloc]
                              initWithImage: [_assets objectAtIndex:index]];
        image.frame = CGRectMake(0.0f, 0.0f, _cellSize.width, _cellSize.height);
        cell.contentView = image;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSLog(@"%f %f %f %f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView
didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
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
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         //                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         //                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView
shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell
           atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView
   moveItemAtIndex:(NSInteger)oldIndex
           toIndex:(NSInteger)newIndex
{
    //    NSObject *object = [_currentData objectAtIndex:oldIndex];
    //    [_currentData removeObject:object];
    //    [_currentData insertObject:object atIndex:newIndex];
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
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(320, 210);
        }
        else
        {
            return CGSizeMake(300, 310);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(700, 530);
        }
        else
        {
            return CGSizeMake(600, 500);
        }
    }
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
    
    if (INTERFACE_IS_PHONE)
    {
        label.font = [UIFont boldSystemFontOfSize:15];
    }
    else
    {
        label.font = [UIFont boldSystemFontOfSize:20];
    }
    
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

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //取得圖片
//        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        //取得影片位置
//        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    }
    
    
    //已動畫方式返回先前畫面
    [picker dismissModalViewControllerAnimated:YES];
}
@end
