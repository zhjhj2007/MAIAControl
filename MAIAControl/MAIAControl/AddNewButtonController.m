//
//  AddNewButtonController.m
//  SettingViewDemo
//
//  Created by mac on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddNewButtonController.h"
#import "imageManager.h"

@implementation AddNewButtonController
@synthesize textFieldX,textFieldY,textFieldIp,textFieldPort,textFieldWidth,textFieldHeight,textFieldCommand,textFieldDiscription,timeDelay,isDisplay;
@synthesize selectNewImg,popoverController,isWarn;
@synthesize labelTitle;
@synthesize labelWillDisplay=_labelWillDisplay;
@synthesize isNew=_isNew;
@synthesize selectedImgPath=_selectedImgPath;
@synthesize curPath=_curPath;
@synthesize cmdBtnName=_cmdBtnName;
@synthesize warnWillDisplay=_warnWillDisplay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//新增按钮调用该初始化函数
- (id)initWithNibName:(NSString *)nibNameOrNil CurPath:(NSString *)curPath isNew:(BOOL)New{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _labelWillDisplay=@"NO";
        _isNew=New;
        _selectedImgPath=@"?";
        _curPath=curPath;
        _cmdBtnName=@"?";
        _warnWillDisplay=@"NO";
    }
    return self;
}
//更新按钮调用该初始化函数
- (id)initWithNibName:(NSString *)nibNameOrNil CurPath:(NSString *)curPath isNew:(BOOL)New CmdBtnName:(NSString *)cmdBtnName{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _labelWillDisplay=@"NO";
        _isNew=New;
        _selectedImgPath=@"?";
        _curPath=curPath;
        _cmdBtnName=cmdBtnName;
        _warnWillDisplay=@"NO";
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditButtnAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToAdd)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if(self.isNew)
    {
        self.labelTitle.text = @"新增命令按钮信息页面";
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    }
    else{
        self.labelTitle.text = @"更新命令按钮信息页面";
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica" size:30.0];
        [self loadSetting];
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)backToAdd{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) loadSetting{
    NSDictionary *cmdBtnInfo=[XMLManipulate getCmdBtnInfo:[_curPath stringByAppendingFormat:@"%@/",_cmdBtnName]];
    textFieldDiscription.text=[cmdBtnInfo objectForKey:@"CmdBtnName"];
    textFieldX.text=[cmdBtnInfo objectForKey:@"Location_x"];
    textFieldY.text=[cmdBtnInfo objectForKey:@"Location_y"];
    textFieldWidth.text=[cmdBtnInfo objectForKey:@"Width"];
    textFieldHeight.text=[cmdBtnInfo objectForKey:@"Height"];
    textFieldIp.text=[cmdBtnInfo objectForKey:@"ServerIP"];
    textFieldPort.text=[cmdBtnInfo objectForKey:@"ServerPort"];
    textFieldCommand.text=[cmdBtnInfo objectForKey:@"Cmd"];
    timeDelay.text=[cmdBtnInfo objectForKey:@"TimeDelay"];
    isDisplay.selectedSegmentIndex=[[cmdBtnInfo objectForKey:@"LabelWillDisplay"] isEqualToString:@"YES"]?1:0;
    _labelWillDisplay=[cmdBtnInfo objectForKey:@"LabelWillDisplay"];
    isWarn.selectedSegmentIndex=[[cmdBtnInfo objectForKey:@"WarnWillDisplay"] isEqualToString:@"YES"]?1:0;
    _warnWillDisplay=[cmdBtnInfo objectForKey:@"WarnWillDisplay"];
    NSString *documentPath=[XMLManipulate getDocumentPath];
    NSString *imgPath=[documentPath stringByAppendingFormat:@"/%@", [cmdBtnInfo objectForKeyedSubscript:@"ImgUrl"] ];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath])
    {
        UIImage *img=[UIImage imageWithContentsOfFile:imgPath];
        self.selectNewImg.image=img;
        _selectedImgPath=[cmdBtnInfo objectForKeyedSubscript:@"ImgUrl"];
    }
    else
    {
        UIImage *img=[UIImage imageNamed:@"Bug.png"];
        self.selectNewImg.image=img;
    }
}

//修改或者添加按钮
-(void)doneEditButtnAction
{
    NSString* valueX = self.textFieldX.text;
    NSString* valueY = self.textFieldY.text;
    NSString* valueWidth = self.textFieldWidth.text;
    NSString* valueHeight = self.textFieldHeight.text;
    NSString* valueIp = self.textFieldIp .text;
    NSString* valuePort = self.textFieldPort.text;
    NSString* valueCommand = self.textFieldCommand.text;
    NSString* valueDescription = self.textFieldDiscription.text;
    NSString *valueDelay = self.timeDelay.text;
    
    NSMutableDictionary *md=[NSMutableDictionary dictionary];
    [md setObject:_curPath forKey:@"CmdBtnPath"];
    [md setObject:valueIp forKey:@"ServerIP"];
    [md setObject:valuePort forKey:@"ServerPort"];
    [md setObject:_selectedImgPath forKey:@"ImgUrl"];
    [md setObject:valueX forKey:@"Location_x"];
    [md setObject:valueY forKey:@"Location_y"];
    [md setObject:valueWidth forKey:@"Width"];
    [md setObject:valueHeight forKey:@"Height"];
    [md setObject:valueCommand forKey:@"Cmd"];
    [md setObject:valueDescription forKey:@"CmdBtnName"];
    [md setObject:valueDelay forKey:@"TimeDelay"];
    [md setObject:_labelWillDisplay forKey:@"LabelWillDisplay"];
    [md setObject:_warnWillDisplay forKey:@"WarnWillDisplay"];
    if (_isNew){
        [XMLManipulate writeCmdBtnInfoToFile:md];
    }
    else{
        NSString *cmdBtnPath=[_curPath stringByAppendingFormat:@"%@/", _cmdBtnName];
        [XMLManipulate updateCmdBtnInfo:cmdBtnPath CmdBtnInfo:md];
    }
        
    [md removeAllObjects];

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (IBAction)pickButtonImage:(id)sender 
{
    UIImagePickerController *picker =[[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [picker setAllowsEditing:NO];
        UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
        self.popoverController = popover;
        self.popoverController.popoverContentSize = CGSizeMake(400.0, 500.0); 
        [popoverController presentPopoverFromRect:CGRectMake(0, 0, 400, 500) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library" delegate:nil cancelButtonTitle:@"close" otherButtonTitles: nil];
        [alert show];
    }
  //  [self presentModalViewController:picker animated:YES]; 
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *selectedImg=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.selectNewImg.image=[info objectForKey:UIImagePickerControllerOriginalImage];
//    self.textFieldHeight.text = [NSString stringWithFormat:@"%.0f", selectedImg.size.height];
//    self.textFieldWidth.text = [NSString stringWithFormat:@"%.0f",selectedImg.size.width];
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSString *query=[imageURL query];
    NSArray *tmps=[query componentsSeparatedByString:@"="];
    NSArray *tmps2=[[tmps objectAtIndex:1] componentsSeparatedByString:@"&"];
    NSString *imageName=[[tmps2 objectAtIndex:0] stringByAppendingFormat:@".%@", [tmps objectAtIndex:2]];
    NSLog(@"%@",imageName);
    [imageManager saveImgToFileSystem:selectedImg ImageName:imageName OldImgPath:_selectedImgPath];
//    _selectedImgPath=[[XMLManipulate getDocumentPath] stringByAppendingFormat:@"/%@",imageName];
    _selectedImgPath=imageName;
    [self.popoverController dismissPopoverAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFielfReturn:(id)sender {
//    [self.textFieldX resignFirstResponder];
//    [self.textFieldY resignFirstResponder];
//    [self.textFieldIp resignFirstResponder];
//    [self.textFieldPort resignFirstResponder];
//    [self.textFieldDiscription resignFirstResponder];
//    [self.textFieldWidth resignFirstResponder];
//    [self.textFieldHeight resignFirstResponder];
//    [self.textFieldCommand resignFirstResponder];
//    [self.timeDelay resignFirstResponder];
    [sender resignFirstResponder];
    
}

- (IBAction)displayChanged:(id)sender {
    if (0 == [sender selectedSegmentIndex]) {
        self.labelWillDisplay = @"NO";
    }else{
        self.labelWillDisplay = @"YES";
    }
}

- (IBAction)warnChanged:(id)sender {
    if (0 == [sender selectedSegmentIndex]) {
        _warnWillDisplay = @"NO";
    }else{
        _warnWillDisplay = @"YES";
    }
}

@end
