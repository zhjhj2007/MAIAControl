//
//  SystemViewController.h
//  MAIAControl
//
//  Created by Mac on 14-11-13.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLManipulate.h"
#import "imageManager.h"

@interface SystemViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (retain) UIPopoverController *popoverController;
@property (nonatomic,assign)NSInteger imgIndex;
@property (nonatomic,retain)NSMutableDictionary *systemInfo;

@end
