//
//  MDWriteMessageView.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-28.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDWriteMessageView.h"

@implementation MDWriteMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupGridView];
    }
    return self;
}

- (void)setup
{
    _textField = [[MDUITextView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
    _textField.placeholder = @"想说些什么？";
    _textField.scrollEnabled = NO;
    
    [self addSubview: _textField];
    
    self.pagingEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)setupGridView
{
    UIImage *asset1 = [UIImage
                       imageWithContentsOfFile:[[NSBundle mainBundle]
                                                pathForResource:@"default_avatar"
                                                ofType:@"jpg"]];
    _assets = [NSMutableArray arrayWithArray: @[asset1,asset1,asset1,asset1]];
    
    NSInteger spacing = INTERFACE_IS_PHONE ? 10 : 15;
    
    _cellSize = CGSizeMake(70.0f, 70.0f);
    CGRect msgFrame = self.frame;
    CGRect tfFrame  = self.textField.frame;
    CGFloat gridHeight = msgFrame.size.height - tfFrame.size.height - 1;
    CGRect gridFrame = CGRectMake(0, tfFrame.origin.y + 1,
                                  msgFrame.size.width, gridHeight);
    
    NSLog(@"Text field height %f", self.textField.frame.size.height);
    
    
    _gridView = [[GMGridView alloc] initWithFrame:gridFrame];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    _gridView.backgroundColor = [UIColor clearColor];
//    [self addSubview:_gridView];
    
    _gridView.style = GMGridViewStyleSwap;
//    _gridView.backgroundColor = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    _gridView.itemSpacing = spacing;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gridView.centerGrid = YES;
    _gridView.actionDelegate = self;
    _gridView.sortingDelegate = self;
    _gridView.transformDelegate = self;
    _gridView.dataSource = self;
    _gridView.scrollEnabled = NO;
}

- (void)setupPosition
{
    
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textField.text = text;
    [self setupPosition];
}

- (void)textChanged:(NSNotification *)notification
{
    self.contentSize = _textField.contentSize;
    
    CGRect msgFrame = self.frame;
    CGRect tfFrame  = self.textField.frame;
    CGFloat gridHeight = msgFrame.size.height - tfFrame.size.height - 1;
    CGRect gridFrame = CGRectMake(0, tfFrame.origin.y + 1,
                                  msgFrame.size.width, gridHeight);
    
    _gridView.frame = gridFrame;
    
    NSLog(@"Text did change.");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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


@end
