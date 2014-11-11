//
//  NewPopButtonViewController.m
//  MAIAControl
//
//  Created by Mac on 14-11-10.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "NewPopButtonViewController.h"
#import "imageManager.h"
#import "XMLManipulate.h"

@interface NewPopButtonViewController ()
@end

@implementation NewPopButtonViewController
@synthesize textFieldX,textFieldY,textFieldIp,textFieldPort,textFieldWidth,textFieldHeight,textFieldCommand,textFieldDiscription,isDisplay;
@synthesize deviceNames,cmdNames,selectNewImg,popoverController;
@synthesize labelTitle;
@synthesize labelWillDisplay=_labelWillDisplay;
@synthesize isNew=_isNew;
@synthesize selectedImgPath=_selectedImgPath;
@synthesize curPath=_curPath;
@synthesize cmdBtnName=_cmdBtnName;
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
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditButtnAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToAdd)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if(self.isNew)
    {
        self.labelTitle.text = @"新增弹出按钮信息页面";
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    }
    else{
        self.labelTitle.text = @"更新弹出按钮信息页面";
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica" size:30.0];
        [self loadSetting];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark loading
-(void) loadSetting{
    NSDictionary *cmdBtnInfo=[XMLManipulate getPopBtnInfo:[_curPath stringByAppendingFormat:@"%@/",_cmdBtnName]];
    textFieldDiscription.text=[cmdBtnInfo objectForKey:@"PopBtnName"];
    textFieldX.text=[cmdBtnInfo objectForKey:@"Location_x"];
    textFieldY.text=[cmdBtnInfo objectForKey:@"Location_y"];
    textFieldWidth.text=[cmdBtnInfo objectForKey:@"Width"];
    textFieldHeight.text=[cmdBtnInfo objectForKey:@"Height"];
    textFieldIp.text=[cmdBtnInfo objectForKey:@"ServerIP"];
    textFieldPort.text=[cmdBtnInfo objectForKey:@"ServerPort"];
    textFieldCommand.text=[cmdBtnInfo objectForKey:@"Cmds"];
    deviceNames.text=[cmdBtnInfo objectForKey:@"Devices"];
    cmdNames.text=[cmdBtnInfo objectForKey:@"CmdNames"];
    isDisplay.selectedSegmentIndex=[[cmdBtnInfo objectForKey:@"LabelWillDisplay"] isEqualToString:@"YES"]?1:0;
    _labelWillDisplay=[cmdBtnInfo objectForKey:@"LabelWillDisplay"];
    NSString *imgPath=[cmdBtnInfo objectForKey:@"ImgUrl"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath])
    {
        UIImage *img=[UIImage imageWithContentsOfFile:imgPath];
        self.selectNewImg.image=img;
        _selectedImgPath=imgPath;
    }
    else
    {
        UIImage *img=[UIImage imageNamed:@"popBtn.png"];
        self.selectNewImg.image=img;
    }
}
#pragma  mark Response Function
-(void)backToAdd{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *devices=self.deviceNames.text;
    NSString *cmdNamesValue=self.cmdNames.text;
    
    NSMutableDictionary *md=[NSMutableDictionary dictionary];
    [md setObject:_curPath forKey:@"PopBtnPath"];
    [md setObject:valueIp forKey:@"ServerIP"];
    [md setObject:valuePort forKey:@"ServerPort"];
    [md setObject:_selectedImgPath forKey:@"ImgUrl"];
    [md setObject:valueX forKey:@"Location_x"];
    [md setObject:valueY forKey:@"Location_y"];
    [md setObject:valueWidth forKey:@"Width"];
    [md setObject:valueHeight forKey:@"Height"];
    [md setObject:valueCommand forKey:@"Cmds"];
    [md setObject:valueDescription forKey:@"PopBtnName"];
    [md setObject:_labelWillDisplay forKey:@"LabelWillDisplay"];
    [md setObject:devices forKey:@"Devices"];
    [md setObject:cmdNamesValue forKey:@"CmdNames"];
    if (_isNew){
        [XMLManipulate writePopBtnInfoToFile:md];
    }
    else{
        NSString *cmdBtnPath=[_curPath stringByAppendingFormat:@"%@/", _cmdBtnName];
        [XMLManipulate updatePopBtnInfo:cmdBtnPath PopBtnInfo:md];
    }
    
    [md removeAllObjects];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    _selectedImgPath=[[XMLManipulate getDocumentPath] stringByAppendingFormat:@"/%@",imageName];
    [self.popoverController dismissPopoverAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark IBAction Function
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


- (IBAction)textFielfReturn:(id)sender {
    [sender resignFirstResponder];
    
}

- (IBAction)displayChanged:(id)sender {
    if (0 == [sender selectedSegmentIndex]) {
        self.labelWillDisplay = @"NO";
    }else{
        self.labelWillDisplay = @"YES";
    }
}

@end
