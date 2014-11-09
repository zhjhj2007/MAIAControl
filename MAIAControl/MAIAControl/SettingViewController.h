//
//  SettingViewController.h
//  SettingViewDemo/Users/mac/Desktop/IpadCenterControl/IpadCenterControl/SettingViewController.m
//
//  Created by mac on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowNextLevelViewController.h"
#import "NewButtonAndGroupViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "GDataXMLNode.h"
#import "NameAndImageInfo.h"
#import "NewGroupViewVontroller.h"

#import "XMLManipulate.h"

@interface SettingViewController : UIViewController<UINavigationBarDelegate, UITableViewDelegate,
UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView	*myTableView;
	NSMutableArray *menuList;
    NSString *pathValue;
    UIToolbar *toolBar;
    UIBarButtonItem *onHelp;
    
}

@property (strong, nonatomic) NewButtonAndGroupViewController *buttonAndGroup;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) NSString *pathValue;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (retain) UIPopoverController *popoverController;
@property (strong, nonatomic) UIBarButtonItem *onHelp;
@property (strong, nonatomic) UINavigationController *navController;

-(void)loadSetting:(NSString *)groupPath;
-(void)changeHelp;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Path:(NSString *)Path;
@end
