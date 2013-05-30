//
//  MDAddonViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-29.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GMGridView/GMGridView.h>
#import <QBImagePickerController/QBImagePickerController.h>

#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

@interface MDAddonViewController : UIViewController<GMGridViewDataSource,
GMGridViewActionDelegate, GMGridViewSortingDelegate,
GMGridViewTransformationDelegate, QBImagePickerControllerDelegate> {
    CGSize _cellSize;
    ALAssetsLibrary *_library;
}

@property (strong) GMGridView *gridView;
@property (strong) NSMutableArray *assets;

@end
