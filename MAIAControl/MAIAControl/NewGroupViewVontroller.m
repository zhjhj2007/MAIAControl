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
@synthesize textFieldX,textFieldY,textFieldName,textFieldWidth,textFieldHeight;
@synthesize popoverController;
@synthesize imageView,pathValue,labelTitle;
@synthesize curPath=_curPath;
@synthesize groupName=_groupName;
@synthesize selectedImgPath=_selectedImgPath;
@synthesize isNew=_isNew;
@synthesize labelWillDisplay=_labelWillDisplay;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil CurPath:(NSString *)curPath isNew:(BOOL)New{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _labelWillDisplay=@"NO";
        _isNew=New;
        _selectedImgPath=@"?";
        _curPath=curPath;
        _groupName=@"?";
    }
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil CurPath:(NSString *)curPath isNew:(BOOL)New GroupName:(NSString *)groupName{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _labelWillDisplay=@"NO";
        _isNew=New;
        _selectedImgPath=@"?";
        _curPath=curPath;
        _groupName=groupName;
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
        self.labelTitle.text = @"新增组按钮信息页面";
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica" size:30.0];
    }
    else{
        self.labelTitle.text = @"更新组按钮信息页面";
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica" size:30.0];
        [self loadSetting];
    }
   
    // Do any additional setup after loading the view from its nib.
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

#pragma mark response function
-(void)backToAdd{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneEditButtnAction
{
    NSString* valueX = self.textFieldX .text;
    NSString* valueY = self.textFieldY.text;
    NSString* valueWidth = self.textFieldWidth.text;
    NSString* valueHeight = self.textFieldHeight.text;
    NSString* valueName = self.textFieldName.text;
    
    NSMutableDictionary *md=[NSMutableDictionary dictionary];
    [md setObject:_curPath forKey:@"GroupPath"];
    [md setObject:valueName forKey:@"GroupName"];
    [md setObject:_selectedImgPath forKey:@"ImgUrl"];
    [md setObject:valueX forKey:@"Location_x"];
    [md setObject:valueY forKey:@"Location_y"];
    [md setObject:valueWidth forKey:@"Width"];
    [md setObject:valueHeight forKey:@"Height"];
    [md setObject:_labelWillDisplay forKey:@"LabelWillDisplay"];
    if (_isNew){
        [XMLManipulate writeGroupInfoToFile:md];
    }
    else{
        NSString *groupPath=[_curPath stringByAppendingFormat:@"%@/", _groupName];
        [XMLManipulate updateGroupInfo:groupPath GroupInfo:md];
    }
    
    [md removeAllObjects];    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) loadSetting{
    NSDictionary *groupInfo=[XMLManipulate getGroupInfo:[_curPath stringByAppendingFormat:@"%@/",_groupName]];
    textFieldName.text=[groupInfo objectForKey:@"GroupName"];
    textFieldX.text=[groupInfo objectForKey:@"Location_x"];
    textFieldY.text=[groupInfo objectForKey:@"Location_y"];
    textFieldWidth.text=[groupInfo objectForKey:@"Width"];
    textFieldHeight.text=[groupInfo objectForKey:@"Height"];
    isDisplay.selectedSegmentIndex=[[groupInfo objectForKey:@"LabelWillDisplay"] isEqualToString:@"YES"]?1:0;
    _labelWillDisplay=[groupInfo objectForKey:@"LabelWillDisplay"];
    NSString *imgPath=[groupInfo objectForKey:@"ImgUrl"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath])
    {
        UIImage *img=[UIImage imageWithContentsOfFile:imgPath];
        self.imageView.image=img;
        _selectedImgPath=imgPath;
    }
    else
    {
        UIImage *img=[UIImage imageNamed:@"1.png"];
        self.imageView.image=img;
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
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *selectedImg=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
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
