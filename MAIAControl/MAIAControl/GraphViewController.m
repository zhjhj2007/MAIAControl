//
//  GraphViewController.m
//  MAIAControl

//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

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
    // Do any additional setup after loading the view.

    
    //*******************************************************************************
    //在上一个Demo中我们学习了 如何创建ViewController
    //这里我们学习下如何添加
    // UIView UIImageView UILabel
    //*******************************************************************************
    
    //首先我们先分别添加 UIView   UIImageView   UILabel 3个控件到self.view 上
    //*******************************************************************************
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 200, 100)];
    view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 200, 100)];
    imageView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 200, 100)];
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
    [self.view addSubview:label];
    [XMLManipulate wirteTestData];
    [XMLManipulate getGroupInfo:@"/G1/"];
    [XMLManipulate getCmdBtnInfo:@"/Computer/"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
