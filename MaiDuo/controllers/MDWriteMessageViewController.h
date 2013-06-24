//
//  SendMessageTableViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GMGridView/GMGridView.h>
#import <QBImagePickerController/QBImagePickerController.h>

@interface MDWriteMessageViewController : UIViewController<GMGridViewDataSource,
GMGridViewActionDelegate, GMGridViewSortingDelegate,
GMGridViewTransformationDelegate, QBImagePickerControllerDelegate,UITextViewDelegate> {
    CGSize _cellSize;
    ALAssetsLibrary *_library;
}
@property (strong) GMGridView *gridView;
@property (strong) NSMutableArray *assets;
@end
