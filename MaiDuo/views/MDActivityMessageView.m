//
//  MDActivityActView.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

//<<<<<<< HEAD:MaiDuo/main/MDActivityActView.m
//#import "MDActivityActView.h"
#import "AsyncImageView.h"
#import "YaabUser.h"
#import "MDActivityMessageView.h"


#define PictureRow 0
//=======
//>>>>>>> master:MaiDuo/views/MDActivityMessageView.m

@implementation MDActivityMessageView

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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:;
            NSLog(@"1");
            return [self createTitleCellWith:tableView
                       cellforRowAtIndexPath:indexPath];
        
        case 1:
            NSLog(@"2");
            return [self createCellWithMoreImageTableView:tableView
                                    cellForRowAtIndexPath:indexPath];
            break;
            
        case 2:
            NSLog(@"3");
            return [self createCellWithOneImageTableView:tableView
                                   cellForRowAtIndexPath:indexPath];
            break;
            
        case 3:
            NSLog(@"4");
            return [self createCellWithTextTableView:tableView
                               cellForRowAtIndexPath:indexPath];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:;
            cell =  [self createTitleCellWith:tableView
                        cellforRowAtIndexPath:indexPath];
            break;
        case 1:
            cell = [self createCellWithMoreImageTableView:tableView
                                    cellForRowAtIndexPath:indexPath];
            break;
            
        case 2:
            cell = [self createCellWithOneImageTableView:tableView
                                   cellForRowAtIndexPath:indexPath];
            break;
            
        case 3:
            cell = [self createCellWithTextTableView:tableView
                               cellForRowAtIndexPath:indexPath];
            break;
    }
    return cell.frame.size.height;
}

#pragma mark -cell
- (UITableViewCell *)createCellWithOneImageTableView:(UITableView *)tableView
                               cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"image";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: @"image"];
        cell.indentationWidth = 15;
        cell.indentationLevel = 1;
        
        float pictureWidth = self.bounds.size.width - 150.0;
        float pictureHeight = 120;
        float gapHeight = 10;
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 10.0, self.bounds.size.width - 10,50.0)];
        title.text = @"18小时前";
        title.font = [UIFont boldSystemFontOfSize:14];
        title.textColor = [UIColor grayColor];
        
        CGSize titleSize = [title.text sizeWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width, MAXFLOAT)];
        title.frame = (CGRect){10.0,10.0,titleSize};
        [cell addSubview:title];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(10.0, pictureHeight + 60 +10, self.bounds.size.width - 20.0,80.0)];
        content.lineBreakMode = UILineBreakModeCharacterWrap;
        content.numberOfLines = 0;
        content.text = @"活动标题jfdiejfiejififijieji就覅阿胶覅efi金额飞机efi将诶就付费陪我跑起评分为机器无法全文";
        CGSize contentSize = [content.text sizeWithFont:content.font constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT)];
        content.frame = (CGRect){10,titleSize.height + 10.0 + gapHeight,contentSize};
        [cell addSubview:content];
        
        
        AsyncImageView* imageView;
        imageView = [[AsyncImageView alloc]
                     initWithFrame: CGRectMake(15.0f, titleSize.height + contentSize.height + 10 + gapHeight * 2, pictureWidth, pictureHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.tag = 1;
        
        [cell addSubview: imageView];
        imageView = (AsyncImageView *)[cell viewWithTag: 1];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        
        static NSString* image_url;
        image_url = @"http://a.img.youboy.com/20106/9/g3_3481169s.jpg";
        imageView.imageURL = [NSURL URLWithString:
                              [NSString stringWithFormat:image_url,
                               @"test"]];
        
        cell.frame = (CGRect){self.frame.origin,self.frame.size.width,titleSize.height + contentSize.height + pictureHeight + 10 + gapHeight * 5};
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    
    return cell;
    
}

- (UITableViewCell *)createCellWithMoreImageTableView:(UITableView *)tableView
                                cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d",indexPath.row];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: [NSString stringWithFormat:@"%d",indexPath.row]];
        cell.indentationWidth = 10;
        cell.indentationLevel = 1;
        
        float pictureWidth = (self.bounds.size.width - 30.0 -5.0*3)/4;
        float gapWidth = 5;
        float gapHeight = 15;
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 10.0, self.bounds.size.width,50.0)];
        title.text = @"一小时前";
        title.font = [UIFont boldSystemFontOfSize:14];
        title.textColor = [UIColor grayColor];
        
        CGSize titleSize = [title.text sizeWithFont:title.font
                                  constrainedToSize:CGSizeMake(title.frame.size.width, MAXFLOAT)];
        title.frame = (CGRect){10.0, 10.0,titleSize};
        [cell addSubview:title];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 140.0, self.bounds.size.width - 20.0,80.0)];
        content.lineBreakMode = UILineBreakModeCharacterWrap;
        content.numberOfLines = 0;
        content.text = @"活动标题1fffffffffffffffffffffffffffffffffff第几第几覅分几点几分地觉得覅噢放假啊；覅时代哦度附近的萨芬骄傲；桑德菲杰";
        CGSize contentSize = [content.text sizeWithFont:content.font
                                      constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT)];
        content.frame = (CGRect){10.0, titleSize.height + 10 + gapHeight, contentSize};
        
        [cell addSubview:content];
        
        AsyncImageView* imageView2;
        imageView2 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(15.0f, titleSize.height + contentSize.height + 10 + gapHeight * 2, pictureWidth, 60.0f)];
        imageView2.contentMode = UIViewContentModeScaleAspectFill;
        imageView2.clipsToBounds = YES;
        imageView2.tag = 2;
        
        [cell addSubview: imageView2];
        imageView2 = (AsyncImageView *)[cell viewWithTag: 2];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView2];
        
        static NSString* image_url;
        image_url = @"http://file.youboy.com/a/57/28/49/3/6665323s.jpg";
        imageView2.imageURL = [NSURL URLWithString:
                               [NSString stringWithFormat:image_url,
                                @"test"]];
        
        
        AsyncImageView* imageView3;
        imageView3 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(pictureWidth + 15.0 + gapWidth, titleSize.height + contentSize.height + 10 + gapHeight * 2, (self.bounds.size.width - 30.0 -5.0*3)/4, 60.0f)];
        imageView3.contentMode = UIViewContentModeScaleAspectFill;
        imageView3.clipsToBounds = YES;
        imageView3.tag = 3;
        
        [cell addSubview: imageView3];
        imageView3 = (AsyncImageView *)[cell viewWithTag: 3];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView3];
        
        image_url = @"http://pic.yoostrip.com/1000/396/396_3_140_120.jpg";
        imageView3.imageURL = [NSURL URLWithString:
                               [NSString stringWithFormat:image_url,
                                @"test"]];
        
        AsyncImageView* imageView4;
        imageView4 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(15 + 2 * pictureWidth + 2 * gapWidth, titleSize.height + contentSize.height + 10 + gapHeight * 2, (self.bounds.size.width - 30.0 -5.0*3)/4, 60.0f)];
        imageView4.contentMode = UIViewContentModeScaleAspectFill;
        imageView4.clipsToBounds = YES;
        imageView4.tag = 4;
        
        [cell addSubview: imageView4];
        imageView4 = (AsyncImageView *)[cell viewWithTag: 4];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView4];
        
        image_url = @"http://v1.qzone.cc/avatar/201303/18/15/02/5146bc12cee67696.jpg!200x200.jpg";
        imageView4.imageURL = [NSURL URLWithString:
                               [NSString stringWithFormat:image_url,
                                @"test"]];
        
        AsyncImageView* imageView5;
        imageView5 = [[AsyncImageView alloc]
                      initWithFrame: CGRectMake(15 + gapWidth * 3 + pictureWidth * 3, titleSize.height + contentSize.height + 10 + gapHeight * 2, (self.bounds.size.width - 30.0 -5.0*3)/4, 60.0f)];
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
        
        
        cell.frame = (CGRect){self.frame.origin,self.frame.size.width, titleSize.height + contentSize.height + 60 + 10 + gapHeight * 5};
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (UITableViewCell *)createCellWithTextTableView:(UITableView *)tableView
                           cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text"];
	if (cell == nil)
	{
        float gapHeight = 15;
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"text"];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 10.0, self.bounds.size.width,50.0)];
        title.text = @"一天前";
        title.font = [UIFont boldSystemFontOfSize:14];
        title.textColor = [UIColor grayColor];
        
        CGSize titleSize = [title.text sizeWithFont:title.font
                                  constrainedToSize:CGSizeMake(title.frame.size.width, MAXFLOAT)];
        title.frame = (CGRect){10.0, gapHeight,titleSize};
        [cell addSubview:title];
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 140.0, self.bounds.size.width - 20.0,80.0)];
        content.lineBreakMode = UILineBreakModeCharacterWrap;
        content.numberOfLines = 0;
        content.text = @"是的hi分类是伐啦合法；士大夫撒；福利哈市；李海峰；阿斯顿立法会；算了地方还是短发；收到了发货速度将按时开房间啊；是伐是伐；啊沙发；的司法；sa";
        CGSize contentSize = [content.text sizeWithFont:content.font
                                      constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT)];
        content.frame = (CGRect){10.0, titleSize.height + 2 * gapHeight , contentSize};
        [cell addSubview:content];
        
        cell.frame = (CGRect){self.frame.origin,self.frame.size.width, titleSize.height + contentSize.height + 3 * gapHeight};
	}
	return cell;
}


-(UITableViewCell*) createTitleCellWith:(UITableView*)tableView
                  cellforRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
    if (cell == nil) {
        float gapHeight = 20;
        float pictureWidth = 50;
        float pictureHeight = 50;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel * title = [[UILabel alloc]initWithFrame:(CGRect){10.0,20.0,(self.bounds.size.width - pictureWidth - 10),
            10}];
        title.textColor = [UIColor blueColor];
        title.font = [UIFont boldSystemFontOfSize:20];
        title.numberOfLines = 0;
        title.lineBreakMode = UILineBreakModeCharacterWrap;
        title.text = self.activity.subject;
        
        CGSize titleSize = [title.text sizeWithFont:title.font
                                  constrainedToSize:CGSizeMake(title.frame.size.width, MAXFLOAT)];
        title.frame = (CGRect){10.0,20.0,titleSize};
        [cell addSubview:title];
        
        AsyncImageView* imageView;
        imageView = [[AsyncImageView alloc]
                     initWithFrame: CGRectMake(self.bounds.size.width - pictureWidth - 10, 20.0, pictureWidth, pictureHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
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
        
        float cellHeight = ((titleSize.height > pictureHeight)? titleSize.height:pictureHeight) + gapHeight *2;
        cell.frame = (CGRect){CGPointZero,self.bounds.size.width,cellHeight};
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    return cell;
    
}

@end
