//
//  LoginViewController.m
//  MAIAControl
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Passward;
- (IBAction)doneEdit:(id)sender;
- (IBAction)Login:(id)sender;

@end

@implementation LoginViewController
@synthesize UserName=_UserName;
@synthesize Passward=_Passward;

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
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *nextBtn=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(BackToMainFrrame)];
    [[self navigationItem] setLeftBarButtonItem:nextBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackToMainFrrame{
    GraphViewController *next=[[GraphViewController alloc] init:@"/"];
    [self.navigationController pushViewController:next animated:YES];
}

- (IBAction)doneEdit:(id)sender {
    [_UserName resignFirstResponder];
    [_Passward resignFirstResponder];
//    [sender resignFirstResponder];
}

- (IBAction)Login:(id)sender {
    //判断语句
    if ([_UserName.text compare:@"maia" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        if([_Passward.text compare:@"2013" options:NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            //submit转向下一界面MainFrame
            SettingViewController *next = [[SettingViewController alloc]  initWithNibName:@"SettingView" bundle:nil];
            [self.navigationController pushViewController:next animated:YES];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"登录失败！" message:@"密码错误！请重新输入！" delegate:self cancelButtonTitle:@"确定"otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"登录失败！" message:@"用户名或者密码错误！请重新输入！" delegate:self cancelButtonTitle:@"确定"otherButtonTitles: nil];
        [alert show];
        
    }
    
    _UserName.text=@"";
    _Passward.text=@"";
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
