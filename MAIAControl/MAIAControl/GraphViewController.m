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
@synthesize curPagePath;
@synthesize scrollView;

#pragma mark init
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
    
    [XMLManipulate wirteTestData];
   // GroupClass *newGroup=[[GroupClass alloc] init:@"/G1/"];
    //设置scrollView
    [self setScrollView];
   // [self.view addSubview:[newGroup getGroupView]];
    [self loadAllGroupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化函数
-(id)init:(NSString *)_curPagePath{
    if (self=[super init]) {
        self.curPagePath=_curPagePath;
    }
    return self;
}

#pragma mark getview function
//设置scrollView
-(void)setScrollView{
    NSArray *groupsInfo=[XMLManipulate getGroupInfoByPath:curPagePath];
    NSArray *cmdBtnsInfo = [XMLManipulate getCmdBtnInfoByPath:curPagePath];
    float maxHeight = -1 ;
    for (NSMutableDictionary *temp in groupsInfo) {
        float tmpHeight = [[temp objectForKey:@"Location_y"] floatValue] +[[temp objectForKey:@"Height"] floatValue] ;
        if (maxHeight < tmpHeight) {
            maxHeight = tmpHeight;
        }
    }
    for (NSMutableDictionary *temp in cmdBtnsInfo) {
        float tmpHeight = [[temp objectForKey:@"Location_y"] floatValue] +[[temp objectForKey:@"Height"] floatValue] ;
        if (maxHeight < tmpHeight) {
            maxHeight = tmpHeight;
        }
    }
    float width,height;
    if ([self.view bounds].size.width > [self.view bounds].size.height) {
        width =[self.view bounds].size.width;
        height = [self.view bounds].size.height;
    }else{
        width = [self.view bounds].size.height;
        height = [self.view bounds].size.width;
    }
    
    if (maxHeight < height) {
        maxHeight = height;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.scrollView.contentSize = CGSizeMake(width,maxHeight);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

//获取组按钮的视图，不包含下面的标签
-(id)getGroupView:(NSMutableDictionary *)groupInfo{
   UIButton *newButton=[[UIButton alloc] initWithFrame:CGRectMake([[groupInfo objectForKey:@"Location_x"] floatValue], [[groupInfo objectForKey:@"Location_y"] floatValue], [[groupInfo objectForKey:@"Width"] floatValue], [[groupInfo objectForKey:@"Height"] floatValue])];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *ImgPath=[documentsPath stringByAppendingFormat:@"/%@",[groupInfo objectForKey:@"ImgUrl"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ImgPath]) {
        [newButton setBackgroundImage:[UIImage imageNamed:@"iDisk.png"] forState:UIControlStateNormal];
    }else{
        [newButton setBackgroundImage:[UIImage imageNamed:ImgPath] forState:UIControlStateNormal];
    }
    
    newButton.showsTouchWhenHighlighted=true;
    newButton.titleLabel.text = [groupInfo objectForKey:@"GroupName"];
    newButton.titleLabel.enabled = false;
    [newButton addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    return newButton;
}

//获取组按钮的视图，不包含下面的标签
-(id)getBtnView:(NSMutableDictionary *)groupInfo{
    UIButton *newButton=[[UIButton alloc] initWithFrame:CGRectMake([[groupInfo objectForKey:@"Location_x"] floatValue], [[groupInfo objectForKey:@"Location_y"] floatValue], [[groupInfo objectForKey:@"Width"] floatValue], [[groupInfo objectForKey:@"Height"] floatValue])];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *ImgPath=[documentsPath stringByAppendingFormat:@"/%@",[groupInfo objectForKey:@"ImgUrl"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ImgPath]) {
        [newButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    }else{
        [newButton setBackgroundImage:[UIImage imageNamed:ImgPath] forState:UIControlStateNormal];
    }
    newButton.showsTouchWhenHighlighted=true;
    newButton.titleLabel.text = [groupInfo objectForKey:@"CmdBtnName"];
    [newButton addTarget:self action:@selector(sendMsgIP:) forControlEvents:UIControlEventTouchUpInside];
    return newButton;
}

//获取组按钮下面的标签视图
-(id)getLabelView:(NSMutableDictionary *)groupInfo{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake([[groupInfo objectForKey:@"Location_x"] floatValue], [[groupInfo objectForKey:@"Location_y"] floatValue]+[[groupInfo objectForKey:@"Height"] floatValue]+5, [[groupInfo objectForKey:@"Width"] floatValue], 40)];
    [newLabel setNumberOfLines:0];
    NSString *text = [groupInfo objectForKey:@"GroupName"];
    newLabel.textAlignment=NSTextAlignmentCenter;
    newLabel.text=text;
    return newLabel;
}

//加载所有视图
-(void)loadAllGroupView{
    NSArray *groupsInfo=[XMLManipulate getGroupInfoByPath:curPagePath];
    for(NSMutableDictionary *tmpDict in groupsInfo){
        [self.scrollView addSubview:[self getGroupView:tmpDict]];
        [self.scrollView addSubview:[self getLabelView:tmpDict]];
    }
    
    NSArray *cmdBtnsInfo = [XMLManipulate getCmdBtnInfoByPath:curPagePath];
    for(NSMutableDictionary *tmpDict in cmdBtnsInfo){
        [self.scrollView addSubview:[self getBtnView:tmpDict]];
        [self.scrollView addSubview:[self getLabelView:tmpDict]];
        
    }
    
    if (![curPagePath isEqualToString:@"/"]) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
        backButton.titleLabel.text = @"back";
        backButton.backgroundColor = [UIColor redColor];
        [backButton addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:backButton];
    }
}

#pragma mark - response function
-(void)jump:(UIButton *)sender{
    NSLog(@"You Clicked the Button!");
    NSLog(@"%@",sender.titleLabel.text);
    GraphViewController *next = [[GraphViewController alloc]init:[curPagePath stringByAppendingFormat:@"/%@",sender.titleLabel.text]];
    [self presentViewController:next animated:YES completion:nil];
}

-(void)backToPre:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendMsgIP:(UIButton *)sender{
    CmdSocket *cmdSocket = [[CmdSocket alloc]init];
    NSString *cmdBtnPath = [curPagePath stringByAppendingFormat:@"/%@/",sender.titleLabel.text ];
    NSMutableDictionary *md=[XMLManipulate getCmdBtnInfo:cmdBtnPath];
    [cmdSocket sendCmd:[md objectForKey:@"ServerIP"] ServerPort:[md objectForKey:@"ServerPort"] CmdText:[cmdBtnPath stringByAppendingFormat:@":%@",[md objectForKey:@"Cmd"]]];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //NSLog(@"ContentOffset  x is  %f,yis %f",self.scrollView.contentOffset.x,self.scrollView.contentOffset.y);
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
