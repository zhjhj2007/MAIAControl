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
@synthesize textFieldX,textFieldY,textFieldIp,textFieldPort,textFieldWidth,textFieldHeight,textFieldCommand,textFieldDiscription,labelDelay,timeDelay,isDisplay;
@synthesize buttonImage,imageView,popoverController;
@synthesize pathValue=_pathValue,labelTitle,isNew;
@synthesize imgPath;
@synthesize newImg;
@synthesize labelWillDisplay;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Path:(NSString *)Path{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pathValue=Path;
    }
    return self;
}
-(id) initWithNibName:(NSString *)nibNameOrNil Path:(NSString *)Path isNew:(BOOL)New{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.pathValue=Path;
        self.isNew = New;
    }
    return self;
}




-(void) loadSetting{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *xmldata=@"<?xml version=\"1.0\" encoding=\"utf-8\"?><setting></setting>";
        NSData *initData=[xmldata dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
    }
    
    NSData *xmlData=[[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if(doc==nil) return;
    NSArray *path=[self.pathValue componentsSeparatedByString:@"/"];
    int Deep=[path count];
    NSString *tempStr;
    GDataXMLElement *tempNode=[doc rootElement];
    //先找到按钮所属的分组
    for (int i=0;i<Deep-1;i++) {
        tempStr=(NSString *)[path objectAtIndex:i];
        if ([tempStr isEqualToString:@""]) {
            continue;
        }
        BOOL flag=false;
        NSArray *groups=[tempNode elementsForName:@"Group"];
        for (GDataXMLElement *tempElement in groups) {
            NSArray *gName=[tempElement elementsForName:@"GroupName"];
            if ([gName count]>0) {
                GDataXMLElement *GName=(GDataXMLElement *)[gName objectAtIndex:0];
                if ([[GName stringValue] isEqualToString:tempStr]) {
                    flag=true;
                    tempNode=tempElement;
                    break;
                }
            }
        }
        if(!flag){
            NSLog(@"找不到路径!\n");
            return;
        }
    }
    //寻找该节点的Button
    tempStr=(NSString *)[path objectAtIndex:(Deep-1)];
    NSArray *btns=[tempNode elementsForName:@"Button"];
    for (GDataXMLElement *tempElement in btns) {
        NSArray *bName=[tempElement elementsForName:@"Description"];
        if ([bName count]>0) {
            GDataXMLElement *BName=(GDataXMLElement *)[bName objectAtIndex:0];
            if ([[BName stringValue] isEqualToString:tempStr]) {
                //获取按钮的信息
                NSArray *temp=[tempElement elementsForName:@"Description"];
                if ([temp count]>0) {
                    textFieldDiscription.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                temp=[tempElement elementsForName:@"Location_x"];
                if ([temp count]>0) {
                    textFieldX.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                temp=[tempElement elementsForName:@"Location_y"];
                if ([temp count]>0) {
                    textFieldY.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                temp=[tempElement elementsForName:@"Width"];
                if ([temp count]>0) {
                    textFieldWidth.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                temp=[tempElement elementsForName:@"Height"];
                if ([temp count]>0) {
                    textFieldHeight.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                temp=[tempElement elementsForName:@"ServerIP"];
                if ([temp count]>0) {
                    textFieldIp.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                
                temp=[tempElement elementsForName:@"ServerPort"];
                if ([temp count]>0) {
                    textFieldPort.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                temp=[tempElement elementsForName:@"Cmd"];
                if ([temp count]>0) {
                    textFieldCommand.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                temp=[tempElement elementsForName:@"TimeDelay"];
                if ([temp count]>0) {
                    timeDelay.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                    NSLog(@"Delay:%@",timeDelay.text);
                }
                
                temp=[tempElement elementsForName:@"labelWillDisplay"];
                if ([temp count]>0) {
                    NSString *tmp=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                    isDisplay.selectedSegmentIndex=[tmp isEqualToString:@"YES"]?1:0;
                }
                
                temp=[tempElement elementsForName:@"ImgUrl"];
                if ([temp count]>0) {
                    NSString *url=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                    NSLog(@"修改按钮信息:%@!\n",textFieldDiscription.text);
                    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath=[paths objectAtIndex:0];
                    NSString *Imgsrc=[documentsPath stringByAppendingFormat:@"/%@",url];
                    self.imgPath=url;
                    if ([[NSFileManager defaultManager] fileExistsAtPath:Imgsrc]) 
                    {
                        UIImage *img=[UIImage imageWithContentsOfFile:Imgsrc];
                        self.imageView.image=img;
                    }
                    else
                    {
                        UIImage *img=[UIImage imageNamed:@"Bug.png"];
                        self.imageView.image=img;
                    }
                    
                }
                break;
            }
        }
    }
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
    self.newImg=NO;
    //self.labelWillDisplay = @"NO";
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditButtnAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToAdd)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if(!self.isNew)
    {
        self.labelTitle.text = @"修改按钮信息";
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    }
     [self loadSetting];
    
    // Do any additional setup after loading the view from its nib.
}

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
    NSString *tempPath=self.pathValue;
    NSString *valueDelay = self.timeDelay.text;
    
    if (!isNew) {
        NSArray *tempPaths=[self.pathValue componentsSeparatedByString:@"/"];
        tempPath=@"";
        for (int i=0; i<[tempPaths count]-1; i++) {
            NSString *temp=(NSString *)[tempPaths objectAtIndex:i];
                tempPath=[tempPath stringByAppendingFormat:@"/%@",temp];
        }
    }
    if (!isNew) {
        //?[cmdBtnClass DEL:self.pathValue];
        [XMLManipulate deleteCmdBtnByPath:self.pathValue];
    }
    NSString *imgUrl;
    if(newImg)
    {
        imgUrl=[imageManager writeImage:self.buttonImage OldImgName:self.imgPath];
    }
    else
    {
        imgUrl=self.imgPath;
    }
    NSLog(@"=====%@",imgUrl);
    //?
//    cmdBtnClass *newButton = [[cmdBtnClass alloc]init:valueIp ServerPort:valuePort ImgURL:imgUrl CmdText:valueCommand GroupName:tempPath Location_X:valueX Location_Y:valueY Width:valueWidth Height:valueHeight Description:valueDescription Delay:valueDelay LabelDisplay:self.labelWillDisplay];
//    [newButton saveSetting];
   // ShowNextLevelViewController *nextLevelView = [[ShowNextLevelViewController alloc]initWithNibName:@"ShowNextLevelView" bundle:nil Path:self.pathValue];
    //[self.navigationController pushViewController:nextLevelView animated:YES];
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
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{   
    self.newImg=YES;
    imageView.image = image;
    self.buttonImage=image;
    
    self.textFieldHeight.text = [NSString stringWithFormat:@"%.0f", image.size.height];
    self.textFieldWidth.text = [NSString stringWithFormat:@"%.0f",image.size.width];

    //[self.popoverController 
    [self.popoverController dismissPopoverAnimated:YES];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
- (IBAction)textFielfReturn:(id)sender {
    [self.textFieldX resignFirstResponder];
    [self.textFieldY resignFirstResponder];
    [self.textFieldIp resignFirstResponder];
    [self.textFieldPort resignFirstResponder];
    [self.textFieldDiscription resignFirstResponder];
    [self.textFieldWidth resignFirstResponder];
    [self.textFieldHeight resignFirstResponder];
    [self.textFieldCommand resignFirstResponder];
    [self.timeDelay resignFirstResponder];
    
}

- (IBAction)displayChanged:(id)sender {
    if (0 == [sender selectedSegmentIndex]) {
        self.labelWillDisplay = @"NO";
    }else{
        self.labelWillDisplay = @"YES";
    }
}

@end
