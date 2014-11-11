//
//  NewGroupViewVontroller.h
//  SettingViewDemo
//
//  Created by mac on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "imageManager.h"
#import "XMLManipulate.h"

@interface NewGroupViewVontroller : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)pickGroupImage:(id)sender;
@property (nonatomic, retain) IBOutlet UITextField *textFieldX;
@property (nonatomic, retain) IBOutlet UITextField *textFieldY;
@property (nonatomic, retain) IBOutlet UITextField *textFieldWidth;
@property (nonatomic, retain) IBOutlet UITextField *textFieldHeight;
@property (nonatomic, retain) IBOutlet UITextField *textFieldName;
@property (retain) UIPopoverController *popoverController;
@property (retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSString *pathValue;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic,retain) IBOutlet UISegmentedControl *isDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//如果是新增组，则该路径中不包含按组的名字，否则包含
@property (nonatomic, copy) NSString *curPath;
@property (nonatomic,copy) NSString *groupName;
//用于存储选择图片之后的新路径
@property (nonatomic, copy) NSString *selectedImgPath;
//用于判断按钮是新增还是更新
@property(nonatomic, assign) BOOL isNew;
@property (nonatomic,copy) NSString *labelWillDisplay;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)changeDisplay:(id)sender;

//新增按钮调用该初始化函数
- (id)initWithNibName:(NSString *)nibNameOrNil CurPath:(NSString *)curPath isNew:(BOOL)New;
//更新按钮调用该初始化函数
- (id)initWithNibName:(NSString *)nibNameOrNil CurPath:(NSString *)curPath isNew:(BOOL)New GroupName:(NSString *)groupName;
-(void) loadSetting;
@end
