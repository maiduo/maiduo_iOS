//
//  MDAddonViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-29.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDAddonViewController.h"
#import "MDAppDelegate.h"
@interface MDAddonViewController (){
    UINavigationController *_navigationPicker;
}
 
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
//    UIImage *asset1 = [UIImage
//                       imageWithContentsOfFile:[[NSBundle mainBundle]
//                                                pathForResource:@"default_avatar"
//                                                ofType:@"jpg"]];
    
    _assets = [NSMutableArray array];
//    for (NSInteger i = 0; i < 50; i++)
//        [_assets addObject:@"assets-library://asset/asset.PNG?id=0FA66916-F06B-45ED-80D3-50FAD6B6DB0E&ext=PNG"];
    _library = [[ALAssetsLibrary alloc] init];
    
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
    
 
     MDAppDelegate *delegate = (MDAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.navigationController presentModalViewController:_navigationPicker animated:YES];
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
//    CGSize size = [self GMGridView:gridView
//sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication]
//                                    statusBarOrientation]];
    
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
    return _cellSize;
    
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
@end
