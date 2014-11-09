//
//  NewGroupViewVontroller.m
//  SettingViewDemo
//
//  Created by mac on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewGroupViewVontroller.h"

@implementation NewGroupViewVontroller
@synthesize isDisplay;
@synthesize textFieldX,textFieldY,textFieldName,textFieldWidth,textFieldHeight,labelWillDisplay;
@synthesize popoverController;
@synthesize groupImage,imageView,pathValue,isNew,labelTitle;
@synthesize imgPath;
@synthesize newImg;


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
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    NSArray *groups=[tempNode elementsForName:@"Group"];
   
    for (GDataXMLElement *tempElement in groups) {
        NSArray *bName=[tempElement elementsForName:@"GroupName"];
        if ([bName count]>0) {
            GDataXMLElement *BName=(GDataXMLElement *)[bName objectAtIndex:0];
            if ([[BName stringValue] isEqualToString:tempStr]) {
                //获取按钮的信息
                NSArray *temp=[tempElement elementsForName:@"GroupName"];
                
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
                temp=[tempElement elementsForName:@"GroupName"];
                if ([temp count]>0) {
                    textFieldName.text=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                }
                
                temp=[tempElement elementsForName:@"labelWillDisplay"];
                if ([temp count]>0) {
                    NSString *tmp=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                    isDisplay.selectedSegmentIndex=[tmp isEqualToString:@"YES"]?1:0;
                }
                
                temp=[tempElement elementsForName:@"ImgUrl"];
                if ([temp count]>0) {
                    NSString *url=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
                    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath=[paths objectAtIndex:0];
                    NSString *Imgsrc=[documentsPath stringByAppendingFormat:@"/%@",url];
                    NSLog(@"修改分组信息:%@",textFieldName.text);
                    self.imgPath=url;
                    if ([[NSFileManager defaultManager] fileExistsAtPath:Imgsrc]) 
                    {
                        UIImage *img=[UIImage imageWithContentsOfFile:Imgsrc];
                        self.imageView.image=img;
                    }
                    else
                    {
                        UIImage *img=[UIImage imageNamed:@"iDisk.png"];
                        self.imageView.image=img;
                    }
                }
                break;
            }
        }
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.newImg=NO;
    //self.labelWillDisplay = @"NO";
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditButtnAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    if(!self.isNew)
    {
        self.labelTitle.text = @"修改分组信息";
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica" size:30.0];
        [self loadSetting];
    }
   
    // Do any additional setup after loading the view from its nib.
}
-(void)doneEditButtnAction
{
    NSString* valueX = self.textFieldX .text;
    NSString* valueY = self.textFieldY.text;
    NSString* valueWidth = self.textFieldWidth.text;
    NSString* valueHeight = self.textFieldHeight.text;
    NSString* valueName = self.textFieldName.text;
    NSString *tempPath=self.pathValue;
    
    //NSString *imgUrl=[imageManager writeImage:self.groupImage OldImgName:self.imgPath];
    NSString *imgUrl;
    if(newImg)
    {imgUrl=[imageManager writeImage:self.groupImage OldImgName:self.imgPath];}
    else
    {imgUrl=self.imgPath;}
    
    if (!isNew) {
        NSArray *tempPaths=[self.pathValue componentsSeparatedByString:@"/"];
        tempPath=@"";
        for (int i=0; i<[tempPaths count]-1; i++) {
            NSString *temp=(NSString *)[tempPaths objectAtIndex:i];
            tempPath=[tempPath stringByAppendingFormat:@"/%@",temp];
        }
    }
    if (!isNew) {
         //?[newGroupClass update:self.pathValue GroupName:valueName ImgURL:imgUrl Location_x:valueX Location_y:valueY Width:valueWidth Height:valueHeight Display:self.labelWillDisplay];
    }
    else
    {
        //?
//        newGroupClass *newGroup = [[newGroupClass alloc]init:valueName ImgURL:imgUrl Location_x:valueX Location_y:valueY Width:valueWidth Height:valueHeight Path:self.pathValue display:self.labelWillDisplay];
//        [newGroup savesetting];
    }
    
    //[self.parentViewController loadSetting:self.pathValue];
    //[self.parentViewController viewWillAppear:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:self.parentViewController animated:YES];  
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

- (IBAction)pickGroupImage:(id)sender {
    UIImagePickerController *picker =[[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [picker setAllowsEditing:NO];
        UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
        self.popoverController = popover;
        [popoverController presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library" delegate:nil cancelButtonTitle:@"close" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.newImg=YES;
    imageView.image = image;
    self.groupImage = image;
    
    self.textFieldHeight.text = [NSString stringWithFormat:@"%.0f", image.size.height];
    self.textFieldWidth.text = [NSString stringWithFormat:@"%.0f",image.size.width];
    
    [self.popoverController dismissPopoverAnimated:YES];
}
- (IBAction)textFieldReturn:(id)sender {
    [self.textFieldX resignFirstResponder];
    [self.textFieldY resignFirstResponder];
    [self.textFieldWidth resignFirstResponder];
    [self.textFieldHeight resignFirstResponder];
    [self.textFieldName resignFirstResponder];
}

- (IBAction)changeDisplay:(id)sender {
    if (0 == [sender selectedSegmentIndex]) {
        self.labelWillDisplay = @"NO";
    }else{
        self.labelWillDisplay = @"YES";
    }
}
- (void)dealloc {
}
@end
