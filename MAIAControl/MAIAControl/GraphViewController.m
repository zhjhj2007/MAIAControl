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
@synthesize curPagePath=_curPagePath;
@synthesize scrollView=_scrollView;
@synthesize refreshHeaderView=_refreshHeaderView;
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
    //加载顶部刷新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -250, [self.view bounds].size.height, 250)];
        view.delegate =self;
        [self.scrollView addSubview:view];
        _refreshHeaderView = view;
    }
    [self loadAllGroupView];	
    
    //注册通知中心
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBtnStatus:) name:@"changeBtnStatus" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化函数
-(id)init:(NSString *)curPagePath{
    if (self=[super init]) {
        self.curPagePath=curPagePath;
    }
    return self;
}

#pragma mark getview function
//设置scrollView
-(void)setScrollView{
    NSArray *groupsInfo=[XMLManipulate getGroupInfoByPath:_curPagePath];
    NSArray *cmdBtnsInfo = [XMLManipulate getCmdBtnInfoByPath:_curPagePath];
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

//获取命令按钮的视图，不包含下面的标签
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
    //为了在下拉刷新时判断按钮是组视图还是命令按钮视图
    [newButton setTag:1101];
    [newButton addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
    //为命令按钮添加默认加载状态图标，即link.png
    UIView *stateImg=[[UIView alloc] initWithFrame:CGRectMake([[groupInfo objectForKey:@"Width"] floatValue]-24, [[groupInfo objectForKey:@"Height"] floatValue]-24, 24, 24)];
    [stateImg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"link.png"]]];
    //为了在刷新状态时找到该视图
    [stateImg setTag:1102];
    [newButton addSubview:stateImg];
    //刷新按钮的状态
    [self sendMsg:newButton];
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
    NSArray *groupsInfo=[XMLManipulate getGroupInfoByPath:_curPagePath];
    for(NSMutableDictionary *tmpDict in groupsInfo){
        [self.scrollView addSubview:[self getGroupView:tmpDict]];
        [self.scrollView addSubview:[self getLabelView:tmpDict]];
    }
    
    NSArray *cmdBtnsInfo = [XMLManipulate getCmdBtnInfoByPath:_curPagePath];
    for(NSMutableDictionary *tmpDict in cmdBtnsInfo){
        [self.scrollView addSubview:[self getBtnView:tmpDict]];
        [self.scrollView addSubview:[self getLabelView:tmpDict]];
        
    }
    
    if (![_curPagePath isEqualToString:@"/"]) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
        backButton.titleLabel.text = @"back";
        backButton.backgroundColor = [UIColor redColor];
        [backButton addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:backButton];
    }
}

//刷新按钮状态
-(void) refresh:(NSString *)cmdBtnName BtnState:(NSInteger) btnState{
    NSArray *allViews=[self.scrollView subviews];
    for(UIView *subView in allViews){
        if([subView isKindOfClass:[UIButton class]]){
            UIButton *tmpBtn=(UIButton *)subView;
            if ([tmpBtn.titleLabel.text isEqualToString:cmdBtnName]) {
                NSArray *subViews = [tmpBtn subviews];
                UIView *stateView = nil;
                for (UIView *stateViewTemp in subViews) {
                    if(stateViewTemp.tag == 1102){
                        stateView = stateViewTemp;
                        break;
                    }
                }
                switch (btnState) {
                        //warn
                    case 1:
                        [stateView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"warn.png"]]];
                        break;
                        //normal
                    case 2:
                        [stateView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"normal.png"]]];
                        break;
                        //error
                    case 3:
                        [stateView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"error.png"]]];
                        break;
                        //link
                    case 4:
                        [stateView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"link.png"]]];
                        break;
                    default:
                        [stateView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"link.png"]]];
                        break;
                }
                break;
            }
        }
    }
}
#pragma mark - response function
-(void)jump:(UIButton *)sender{
    NSLog(@"You Clicked the Button!");
    NSLog(@"%@",sender.titleLabel.text);
    GraphViewController *next = [[GraphViewController alloc]init:[_curPagePath stringByAppendingFormat:@"/%@",sender.titleLabel.text]];
    [self presentViewController:next animated:YES completion:nil];
}

-(void)backToPre:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendMsg:(UIButton *)sender{
    CmdSocket *cmdSocket = [[CmdSocket alloc] initWithButtonName:sender.titleLabel.text];
    NSString *cmdBtnPath = [_curPagePath stringByAppendingFormat:@"%@/",sender.titleLabel.text ];
    NSMutableDictionary *md=[XMLManipulate getCmdBtnInfo:cmdBtnPath];
    [cmdSocket sendCmd:[md objectForKey:@"ServerIP"] ServerPort:[md objectForKey:@"ServerPort"] CmdText:[cmdBtnPath stringByAppendingFormat:@":%@",[md objectForKey:@"Cmd"]]];
}

-(void)changeBtnStatus:(NSNotification *)notification{
    NSDictionary *nd=[notification userInfo];
    [nd objectForKey:@"CmdBtnName"] ;
    NSString *btnName=[nd objectForKey:@"CmdBtnName"];
    NSInteger btnState=[[nd objectForKey:@"CmdBtnState"] integerValue];
    [self refresh:btnName BtnState:btnState];
}
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //NSLog(@"ContentOffset  x is  %f,yis %f",self.scrollView.contentOffset.x,self.scrollView.contentOffset.y);
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
//	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [self egoRefreshScrollViewDidScroll:scrollView];
	
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
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{

}

-(void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *subViews=[self.scrollView subviews];
    int count = 0;
    for (UIView *subview in subViews) {
        if ([subview isKindOfClass:[UIButton class]] && subview.tag == 1101) {
            [self sendMsg:(UIButton *)subview];
            count ++;
        }
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return true; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
@end
