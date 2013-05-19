//
//  MDActivityActView.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDActivityActView.h"
#import "AsyncImageView.h"
#import "YaabUser.h"


#define PictureRow 0

@implementation MDActivityActView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _source = [NSMutableArray arrayWithObjects:nil];
        _message = [NSMutableArray array];
        [[[YaabUser sharedInstance] api] messagesWithActivity:self.activity
                                                         page:1
                                                      success:^(NSArray *messages) {
                                                       [_message addObjectsFromArray:messages];
                                                       [_tableView reloadData];
                                                }      failure:^(NSError *error) {
                                                   }];
    }
    return self;
}

- (void)rightBarAction
{
    
}


#pragma mark -tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case PictureRow:
            return [self createCellWithImageTesttableView:tableView
                                    cellForRowAtIndexPath:indexPath];
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == PictureRow) {
        return 500;
    } else {
        return 100;
    }
    
}

#pragma mark -cell
- (UITableViewCell *)createCellWithImageTesttableView:(UITableView *)tableView
                                cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld",
                                (long)[indexPath row]];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    AsyncImageView* imageView;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
        cell.indentationWidth = 10;
        cell.indentationLevel = 1;
        imageView = [[AsyncImageView alloc]
                     initWithFrame: CGRectMake(50.0f, 10.0f, 200.0f, 200.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = 1;
        
        [cell addSubview: imageView];
        
        
        imageView = (AsyncImageView *)[cell viewWithTag: 1];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        
        static NSString* image_url;
        image_url = @"http://img0.ddove.com/upload/20100707/071007321979.png";
        imageView.imageURL = [NSURL URLWithString:
                              [NSString stringWithFormat:image_url,
                               @"test"]];
        
        AsyncImageView* imageView2;
        imageView2 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(10.0f, 200.0f, 50.0f, 50.0f)];
        imageView2.contentMode = UIViewContentModeScaleAspectFill;
        imageView2.clipsToBounds = YES;
        imageView2.tag = 2;
        imageView2 = (AsyncImageView *)[cell viewWithTag: 2];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        
        image_url = @"http://img0.ddove.com/upload/20100707/071007321979.png";
        imageView2.imageURL = [NSURL URLWithString:
                               [NSString stringWithFormat:image_url,
                                @"test"]];
        [cell addSubview: imageView2];
        
        
        AsyncImageView* imageView3;
        imageView3 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(90.0f, 200.0f, 50.0f, 50.0f)];
        imageView3.contentMode = UIViewContentModeScaleAspectFill;
        imageView3.clipsToBounds = YES;
        imageView3.tag = 3;
        imageView3 = (AsyncImageView *)[cell viewWithTag: 3];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView2];
        
        image_url = @"http://img0.ddove.com/upload/20100707/071007321979.png";
        imageView3.imageURL = [NSURL URLWithString:
                               [NSString stringWithFormat:image_url,
                                @"test"]];
        [cell addSubview: imageView3];
    }
    return cell;
}




@end
