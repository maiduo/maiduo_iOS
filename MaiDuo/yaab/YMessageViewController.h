//
//  YMessageViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-27.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TITokenField/TITokenField.h>
#import <MaiDuo.h>
#import <AddressBookUI/AddressBookUI.h>
#import <YMessage.h>
#import <YPlainContact.h>
#import "PhotoStackView.h"
@interface YMessageViewController : UIViewController <TITokenFieldDelegate, UITextViewDelegate, ABPeoplePickerNavigationControllerDelegate,PhotoStackViewDataSource, PhotoStackViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    TITokenFieldView * tokenFieldView;
    UITextView * messageView;
    MaiDuo *user;
    YMessage *msg;
    RHAddressBook *addressBook;
    ABAddressBookRef addressBookRef;
    NSMutableArray *names;
    CGFloat keyboardHeight;
}
@end
