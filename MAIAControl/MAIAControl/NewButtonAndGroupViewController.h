//
//  NewButtonAndGoupViewController.h
//  SettingViewDemo
//
//  Created by mac on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewButtonController.h"
#import "NewGroupViewVontroller.h"
#import "NameAndImageInfo.h"
#import "NewPopButtonViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "GDataXMLNode.h"

@interface NewButtonAndGroupViewController : UIViewController
{
    UITableView	*myTableView;
	NSMutableArray *menuList;
    NSString *pathValue;
}
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) NSString *pathValue;
-(void)loadSetting:(NSString *)groupPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Path:(NSString *)Path;
@end
