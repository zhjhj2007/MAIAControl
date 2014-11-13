//
//  AboutViewController.m
//  MAIAControl
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *IntroduceInfo;

@end

@implementation AboutViewController

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
    [self setTitle:@"苏州名雅科技有限责任公司"];
    
    // 字符串
    NSString *str = [XMLManipulate getAboutInfo];
    self.IntroduceInfo.text=str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
