//
//  AddNewButtonController.h
//  SettingViewDemo
//
//  Created by mac on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowNextLevelViewController.h"
#import "XMLManipulate.h"

@interface AddNewButtonController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *pathValue,*imgPath;
    bool isNew,newImg;
}
@property (strong, nonatomic) NSString *pathValue;
@property (strong, nonatomic) NSString *imgPath;
@property (nonatomic, retain) IBOutlet UITextField *textFieldX;
@property (nonatomic, retain) IBOutlet UITextField *textFieldY;
@property (nonatomic, retain) IBOutlet UITextField *textFieldWidth;
@property (nonatomic, retain) IBOutlet UITextField *textFieldHeight;
@property (nonatomic, retain) IBOutlet UITextField *textFieldIp;
@property (nonatomic, retain) IBOutlet UITextField *textFieldPort;
@property (nonatomic, retain) IBOutlet UITextField *textFieldCommand;
@property (nonatomic, retain) IBOutlet UITextField *textFieldDiscription;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelDelay;
@property (nonatomic, retain) IBOutlet UITextField *timeDelay;
@property (nonatomic,retain) IBOutlet UISegmentedControl *isDisplay;
@property bool isNew;
@property bool newImg;
@property (nonatomic,retain) NSString *labelWillDisplay;

@property (retain) IBOutlet UIImage *buttonImage;
@property (retain) IBOutlet UIImageView *imageView;
@property (retain) UIPopoverController *popoverController;
- (IBAction)pickButtonImage:(id)sender;
- (IBAction)textFielfReturn:(id)sender;
- (IBAction)displayChanged:(id)sender;

-(void) loadSetting;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Path:(NSString *)Path;
- (id)initWithNibName:(NSString *)nibNameOrNil Path:(NSString *)Path isNew:(BOOL)New;
@end
