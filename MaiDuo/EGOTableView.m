//
//  EGOTableView.m
//  MeetingCloud
//
//  Created by 高 欣 on 12-11-8.
//  Copyright (c) 2012年 Ideal. All rights reserved.
//

#import "EGOTableView.h"

@interface EGOTableView(){
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@end
@implementation EGOTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addEGORefreshTableHeader];
         
    }
    return self;
}

-(void) awakeFromNib
{
    [self addEGORefreshTableHeader];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
// 刷新开始时调用
- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    _reloading = YES;
    if([self.delegate respondsToSelector:@selector(startLoadData:)]){
        [self.delegate performSelector:@selector(startLoadData:) withObject:self];
    }
}

// 刷新结束时调用
- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
    
	_reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

- (void)doneLoadingTableViewDataForHeader
{
	//  model should call this when its done loading
	_reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

-(void) egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void) egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

//#pragma mark -
//#pragma mark UIScrollViewDelegate Methods
//// 页面滚动时回调
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //NSLog(@"scrollViewDidScroll");
//    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}
//
//// 滚动结束时回调
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    //NSLog(@"scrollViewDidEndDragging");
//    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
// 开始刷新时回调
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"egoRefreshTableHeaderDidTriggerRefresh");
    if(view==_refreshHeaderView) {
        [self reloadTableViewDataSource];
    }
}

// 下拉时回调
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"egoRefreshTableHeaderDataSourceIsLoading");
	return _reloading; // should return if data source model is reloading
}

// 请求上次更新时间时调用
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"egoRefreshTableHeaderDataSourceLastUpdated");
	return [NSDate date]; // should return date data source was last changed
}


#pragma mark -
#pragma mark Private methods


-(void) hideBlankLine:(BOOL) hideBlankLine
{
    if(hideBlankLine){
        UIView *view=[[UIView alloc] init];
        self.tableFooterView=view;
    }
}

-(void) addEGORefreshTableHeader
{
    //添加EGORefreshTableHeaderView
    if (_refreshHeaderView==nil) {
        _refreshHeaderView =[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
		_refreshHeaderView.delegate = self;
        //_refreshHeaderView.hintString=@"下拉即可更新...";
		[self addSubview:_refreshHeaderView];
	}
    if(_refreshHeaderView!=nil&&[_refreshHeaderView respondsToSelector:@selector(refreshLastUpdatedDate)]) {
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}

-(void) autoLoadData
{
    //[self reloadTableViewDataSource];
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [self setContentOffset:CGPointMake(0, -65)];
    [UIView commitAnimations];
}

-(void) refreshTableView
{
    [self reloadData];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
}
 
-(void) animationFinished: (id) sender
{
//    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];
}



-(void) finishedAnimationForLoad:(id)sender
{
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    _reloading = NO;
    [self reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
