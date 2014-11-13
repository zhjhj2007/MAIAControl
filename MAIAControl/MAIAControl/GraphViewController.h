//
//  GraphViewController.h
//  MAIAControl
//  该应用有两种显示模式，图形模式和文本模式。该类是控制图形模式的视图类。
//  1. 可以设置背景图片。 2. 加载图形按钮。 功能和一代系统版本类似，优化了代码结构并解决了内存泄露问题。
//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLManipulate.h"
#import "CmdSocket.h"
#import "EGORefreshTableHeaderView.h"
#import "FPPopoverController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
#import "ILBarButtonItem.h"

@interface GraphViewController : UIViewController<UIScrollViewDelegate,EGORefreshTableHeaderDelegate,FPPopoverControllerDelegate, UIAlertViewDelegate>
@property(nonatomic, copy) NSString *curPagePath;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic, assign) BOOL reloading;
@property(nonatomic,retain) EGORefreshTableHeaderView *refreshHeaderView;
//定义IP、按钮名字、按钮路径、端口和命令，用于存储提示操作之前的数据
@property(nonatomic, copy)NSString *storageIP, *storagePort, *storageCmd, *storageCmdBtnPath, *storageCmdBtnName;
-(id)init:(NSString *)curPagePath;
@end
