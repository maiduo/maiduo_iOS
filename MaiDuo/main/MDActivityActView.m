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
//        [[[YaabUser sharedInstance] api] messagesWithActivity:self.activity
//                                                         page:1
//                                                      success:^(NSArray *messages) {
//                                                       [_message addObjectsFromArray:messages];
//                                                       [_tableView reloadData];
//                                                }      failure:^(NSError *error) {
//                                                   }];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case PictureRow:
            return [self createCellWithImageTableView:tableView
                                cellForRowAtIndexPath:indexPath];
            break;
            
        default:
            return [self createCellWithTextTableView:tableView
                               cellForRowAtIndexPath:indexPath];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == PictureRow) {
        return 300;
    } else {
        return 50;
    }
    
}

#pragma mark -cell
- (UITableViewCell *)createCellWithImageTableView:(UITableView *)tableView
                            cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"test";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: @"test"];
        cell.indentationWidth = 10;
        cell.indentationLevel = 1;
        AsyncImageView* imageView;
        imageView = [[AsyncImageView alloc]
                     initWithFrame: CGRectMake(30.0f, 5.0f, 250.0f, 200.0f)];
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
                     initWithFrame: CGRectMake(10.0f, 210.0f, 65.0f, 50.0f)];
        imageView2.contentMode = UIViewContentModeScaleAspectFill;
        imageView2.clipsToBounds = YES;
        imageView2.tag = 2;
        
        [cell addSubview: imageView2];
        imageView2 = (AsyncImageView *)[cell viewWithTag: 2];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView2];
        
        image_url = @"http://img0.ddove.com/upload/20100707/071007321979.png";
        imageView2.imageURL = [NSURL URLWithString:
                              [NSString stringWithFormat:image_url,
                               @"test"]];
        
        AsyncImageView* imageView3;
        imageView3 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(90.0f, 210.0f, 65.0f, 50.0f)];
        imageView3.contentMode = UIViewContentModeScaleAspectFill;
        imageView3.clipsToBounds = YES;
        imageView3.tag = 3;
        
        [cell addSubview: imageView3];
        imageView3 = (AsyncImageView *)[cell viewWithTag: 3];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView3];
        
        image_url = @"http://img0.ddove.com/upload/20100707/071007321979.png";
        imageView3.imageURL = [NSURL URLWithString:
                               [NSString stringWithFormat:image_url,
                                @"test"]];
        
        AsyncImageView* imageView4;
        imageView4 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(170.0f, 210.0f, 65.0f, 50.0f)];
        imageView4.contentMode = UIViewContentModeScaleAspectFill;
        imageView4.clipsToBounds = YES;
        imageView4.tag = 4;
        
        [cell addSubview: imageView4];
        imageView4 = (AsyncImageView *)[cell viewWithTag: 4];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView4];
        
        image_url = @"http://img0.ddove.com/upload/20100707/071007321979.png";
        imageView4.imageURL = [NSURL URLWithString:
                               [NSString stringWithFormat:image_url,
                                @"test"]];
        
        AsyncImageView* imageView5;
        imageView5 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(250.0f, 210.0f, 65.0f, 50.0f)];
        imageView5.contentMode = UIViewContentModeScaleAspectFill;
        imageView5.clipsToBounds = YES;
        imageView5.tag = 5;
        
        [cell addSubview: imageView5];
        imageView5 = (AsyncImageView *)[cell viewWithTag: 5];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView5];
        
        image_url = @"http://img0.ddove.com/upload/20100707/071007321979.png";
        imageView5.imageURL = [NSURL URLWithString:
                               [NSString stringWithFormat:image_url,
                                @"test"]];
    }
    return cell;
}

- (UITableViewCell *)createCellWithTextTableView:(UITableView *)tableView
                            cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"text"];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    NSString *textLabel;
    switch (indexPath.row) {
        case 1:
            textLabel = @"活动内容1";
            break;
        
        case 2:
            textLabel = @"活动内容2";
            break;
        default:
            break;
    }
   
    cell.textLabel.text = textLabel;
    
	return cell;
}

@end
