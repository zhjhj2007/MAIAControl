//
//  AddNewButtonController.h
//  SettingViewDemo
//
//  Created by mac on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLManipulate.h"

@interface AddNewButtonController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selectNewImg;
@property (nonatomic, retain) IBOutlet UITextField *textFieldX;
@property (nonatomic, retain) IBOutlet UITextField *textFieldY;
@property (nonatomic, retain) IBOutlet UITextField *textFieldWidth;
@property (nonatomic, retain) IBOutlet UITextField *textFieldHeight;
@property (nonatomic, retain) IBOutlet UITextField *textFieldIp;
@property (nonatomic, retain) IBOutlet UITextField *textFieldPort;
@property (nonatomic, retain) IBOutlet UITextField *textFieldCommand;
@property (nonatomic, retain) IBOutlet UITextField *textFieldDiscription;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UITextField *timeDelay;
@property (nonatomic,retain) IBOutlet UISegmentedControl *isDisplay;
@property (weak, nonatomic) IBOutlet UISegmentedControl *isWarn;


@property (retain) UIPopoverController *popoverController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//如果是新增按钮，则该路径中不包含按钮的名字，否则包含
@property (nonatomic, copy) NSString *curPath;
@property (nonatomic,copy) NSString *cmdBtnName;
//用于存储选择图片之后的新路径
@property (nonatomic, copy) NSString *selectedImgPath;
//用于判断按钮是新增还是更新
@property(nonatomic, assign) BOOL isNew;
@property (nonatomic,copy) NSString *labelWillDisplay;
@property (nonatomic,copy) NSString *warnWillDisplay;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)pickButtonImage:(id)sender;
- (IBAction)textFielfReturn:(id)sender;
- (IBAction)displayChanged:(id)sender;
- (IBAction)warnChanged:(id)sender;

-(void) loadSetting;
//新增按钮调用该初始化函数
- (id)initWithNibName:(NSString *)nibNameOrNil CurPath:(NSString *)curPath isNew:(BOOL)New;
//更新按钮调用该初始化函数
- (id)initWithNibName:(NSString *)nibNameOrNil CurPath:(NSString *)curPath isNew:(BOOL)New CmdBtnName:(NSString *)cmdBtnName;
@end
