//
//  ShowNextLevelViewController.h
//  SettingViewDemo
//
//  Created by mac on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
#import "GDataXMLNode.h"
#import "AddNewButtonController.h"
#import "NewGroupViewVontroller.h"
#import "NameAndImageInfo.h"

@interface ShowNextLevelViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate,
UITableViewDataSource>
{
    UITableView	*myTableView;
	NSMutableArray *menuList;
    NSString *pathValue;
    UIToolbar *toolBar;
}
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) NSString *pathValue;
@property (nonatomic, retain) UIToolbar *toolBar;

-(void)loadSetting:(NSString *)groupPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Path:(NSString *)Path;
@end
