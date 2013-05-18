//
//  EGOTableView.h
//  MeetingCloud
//
//  Created by 高 欣 on 12-11-8.
//  Copyright (c) 2012年 Ideal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@protocol EGOTableViewDelegate;
@interface EGOTableView : UITableView<EGORefreshTableHeaderDelegate>
@property (nonatomic,unsafe_unretained) id<EGOTableViewDelegate> delegateEGO;
@property (nonatomic,assign,setter = hideBlankLine:) BOOL hideBlankLine;
//自动加载
-(void) autoLoadData;
//结束加载
-(void) refreshTableView;

-(void) loaded;

-(void) egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
-(void) egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
@end

@protocol EGOTableViewDelegate
- (void) startLoadData:(id) sender;
@end
