//
//  MDWriteMessageView.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-28.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GMGridView/GMGridView.h>
#import "MDUITextView.h"

#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

@interface MDWriteMessageView : UIScrollView<GMGridViewDataSource,
GMGridViewActionDelegate, GMGridViewSortingDelegate,
GMGridViewTransformationDelegate> {
    CGSize _cellSize;
}

@property (strong) MDUITextView *textField;
@property (strong) GMGridView *gridView;
@property (strong) NSMutableArray *assets;
@property (strong, setter = setText:) NSString *text;
@end
