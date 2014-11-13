//
//  SystemViewController.m
//  MAIAControl
//
//  Created by Mac on 14-11-13.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "SystemViewController.h"

@interface SystemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
- (IBAction)selectImg1:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
- (IBAction)selectImg2:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backBtnImgView;
//- (IBAction)selectImg3:(id)sender;
//@property (weak, nonatomic) IBOutlet UIImageView *refreshImgView;
- (IBAction)selectImg4:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *state1ImgView;
- (IBAction)selectImg5:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *state2ImgView;
- (IBAction)selectImg6:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *state3ImgView;
- (IBAction)selectImg7:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *state4ImgView;
- (IBAction)DoneConfigurate:(id)sender;
- (IBAction)setUserDone:(id)sender;
- (IBAction)setPasswordDone:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *showInfoTime;
- (IBAction)setShowInfoTimeDone:(id)sender;


@end

@implementation SystemViewController
@synthesize popoverController;
@synthesize imgIndex=_imgIndex;
@synthesize systemInfo=_systemInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _systemInfo=[NSMutableDictionary dictionary];
    [_systemInfo setObject:@"" forKey:@"UserName"];
    [_systemInfo setObject:@"" forKey:@"Password"];
    [_systemInfo setObject:@"" forKey:@"RightImgPath"];
    [_systemInfo setObject:@"" forKey:@"BackImgPath"];
//    [_systemInfo setObject:@"" forKey:@"RefreshImgPath"];
    [_systemInfo setObject:@"" forKey:@"State1ImgPath"];
    [_systemInfo setObject:@"" forKey:@"State2ImgPath"];
    [_systemInfo setObject:@"" forKey:@"State3ImgPath"];
    [_systemInfo setObject:@"" forKey:@"State4ImgPath"];
    [_systemInfo setObject:@"" forKey:@"ShowInfoTime"];
    // Do any additional setup after loading the view from its nib.
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"systemConfiguration.xml"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self loadSetting];
    }
    //设置左上角的返回按钮和右上角的完成操作
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneConfigurate:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToSetting)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadSetting{
    NSDictionary *info=[XMLManipulate getSystemConfiguration];
    self.UserName.text=[info objectForKey:@"UserName"];
    self.Password.text=[info objectForKey:@"Password"];
    self.rightImgView.image=[UIImage imageWithContentsOfFile:[info objectForKey:@"RightImgPath"]];
    self.backBtnImgView.image=[UIImage imageWithContentsOfFile:[info objectForKey:@"BackImgPath"]];
//    self.refreshImgView.image=[UIImage imageWithContentsOfFile:[info objectForKey:@"RefreshImgPath"]];
    self.state1ImgView.image=[UIImage imageWithContentsOfFile:[info objectForKey:@"State1ImgPath"]];
    self.state2ImgView.image=[UIImage imageWithContentsOfFile:[info objectForKey:@"State2ImgPath"]];
    self.state3ImgView.image=[UIImage imageWithContentsOfFile:[info objectForKey:@"State3ImgPath"]];
    self.state4ImgView.image=[UIImage imageWithContentsOfFile:[info objectForKey:@"State4ImgPath"]];
    self.showInfoTime.text=[info objectForKey:@"ShowInfoTime"];
    
    @try {
        [_systemInfo setObject:[info objectForKey:@"UserName"] forKey:@"UserName"];
        [_systemInfo setObject:[info objectForKey:@"Password"] forKey:@"Password"];
        [_systemInfo setObject:[info objectForKey:@"RightImgPath"] forKey:@"RightImgPath"];
        [_systemInfo setObject:[info objectForKey:@"BackImgPath"] forKey:@"BackImgPath"];
//        [_systemInfo setObject:[info objectForKey:@"RefreshImgPath"] forKey:@"RefreshImgPath"];
        [_systemInfo setObject:[info objectForKey:@"State1ImgPath"] forKey:@"State1ImgPath"];
        [_systemInfo setObject:[info objectForKey:@"State2ImgPath"] forKey:@"State2ImgPath"];
        [_systemInfo setObject:[info objectForKey:@"State3ImgPath"] forKey:@"State3ImgPath"];
        [_systemInfo setObject:[info objectForKey:@"State4ImgPath"] forKey:@"State4ImgPath"];
        [_systemInfo setObject:[info objectForKey:@"ShowInfoTime"] forKey:@"ShowInfoTime"];

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        
    }
}
-(void) selectImg:(NSInteger)clickImageIndex{
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
    _imgIndex=clickImageIndex;
}
- (IBAction)selectImg1:(id)sender {
    [self selectImg:1];
}
- (IBAction)selectImg2:(id)sender {
    [self selectImg:2];
}
//- (IBAction)selectImg3:(id)sender {
//    [self selectImg:3];
//}
- (IBAction)selectImg4:(id)sender {
    [self selectImg:4];
}
- (IBAction)selectImg5:(id)sender {
    [self selectImg:5];
}
- (IBAction)selectImg6:(id)sender {
    [self selectImg:6];
}
- (IBAction)selectImg7:(id)sender {
    [self selectImg:7];
}
- (IBAction)DoneConfigurate:(id)sender {
    [XMLManipulate setSystemConfiguration:_systemInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)setUserDone:(id)sender {
    [_systemInfo setObject:_UserName.text forKey:@"UserName"];
}

- (IBAction)setPasswordDone:(id)sender {
    [_systemInfo setObject:_Password.text forKey:@"Password"];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *selectedImg=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *systeminfo=[XMLManipulate getSystemConfiguration];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSString *query=[imageURL query];
    NSArray *tmps=[query componentsSeparatedByString:@"="];
    NSArray *tmps2=[[tmps objectAtIndex:1] componentsSeparatedByString:@"&"];
    NSString *imageName=[[tmps2 objectAtIndex:0] stringByAppendingFormat:@".%@", [tmps objectAtIndex:2]];
    NSLog(@"%@",imageName);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *newImgPath=[documentsPath stringByAppendingFormat:@"/%@",imageName];
    NSString *oldImgPath;
    switch (_imgIndex) {
        case 1:
            self.rightImgView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
            oldImgPath=[systeminfo objectForKey:@"RightImgPath"];
            [_systemInfo setObject:newImgPath forKey:@"RightImgPath"];
            break;
        case 2:
            self.backBtnImgView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
            oldImgPath=[systeminfo objectForKey:@"BackImgPath"];
            [_systemInfo setObject:newImgPath forKey:@"BackImgPath"];
            break;
//        case 3:
//            self.refreshImgView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
//            oldImgPath=[systeminfo objectForKey:@"RefreshImgPath"];
//            [_systemInfo setObject:newImgPath forKey:@"RefreshImgPath"];
//            break;
        case 4:
            self.state1ImgView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
            oldImgPath=[systeminfo objectForKey:@"State1ImgPath"];
            [_systemInfo setObject:newImgPath forKey:@"State1ImgPath"];
            break;
        case 5:
            self.state2ImgView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
            oldImgPath=[systeminfo objectForKey:@"State2ImgPath"];
            [_systemInfo setObject:newImgPath forKey:@"State2ImgPath"];
            break;
        case 6:
            self.state3ImgView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
            oldImgPath=[systeminfo objectForKey:@"State3ImgPath"];
            [_systemInfo setObject:newImgPath forKey:@"State3ImgPath"];
            break;
        case 7:
            self.state4ImgView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
            oldImgPath=[systeminfo objectForKey:@"State4ImgPath"];
            [_systemInfo setObject:newImgPath forKey:@"State4ImgPath"];
            break;
            
        default:
            break;
    }
    [imageManager saveImgToFileSystem:selectedImg ImageName:imageName OldImgPath:oldImgPath];
    [self.popoverController dismissPopoverAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)setShowInfoTimeDone:(id)sender {
    [_systemInfo setObject:_showInfoTime.text forKey:@"ShowInfoTime"];
}
-(void)backToSetting{
    [self.navigationController popViewControllerAnimated:true];
}
@end