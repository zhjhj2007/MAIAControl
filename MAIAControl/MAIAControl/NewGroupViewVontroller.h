//
//  NewGroupViewVontroller.h
//  SettingViewDemo
//
//  Created by mac on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowNextLevelViewController.h"
#import "imageManager.h"

@interface NewGroupViewVontroller : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *pathValue,*imgPath;
    bool isNew;
}
- (IBAction)pickGroupImage:(id)sender;
@property (strong, nonatomic) NSString *imgPath;
@property (nonatomic, retain) IBOutlet UITextField *textFieldX;
@property (nonatomic, retain) IBOutlet UITextField *textFieldY;
@property (nonatomic, retain) IBOutlet UITextField *textFieldWidth;
@property (nonatomic, retain) IBOutlet UITextField *textFieldHeight;
@property (nonatomic, retain) IBOutlet UITextField *textFieldName;
@property (retain) UIPopoverController *popoverController;
@property (retain) IBOutlet UIImage *groupImage;
@property (retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSString *pathValue;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic,retain) IBOutlet UISegmentedControl *isDisplay;
@property bool isNew;
@property bool newImg;
@property (nonatomic,retain) NSString *labelWillDisplay;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)changeDisplay:(id)sender;

//- (IBAction)pickButtonImage:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Path:(NSString *)Path;
- (id)initWithNibName:(NSString *)nibNameOrNil Path:(NSString *)Path isNew:(BOOL)New;
-(void) loadSetting;
@end
