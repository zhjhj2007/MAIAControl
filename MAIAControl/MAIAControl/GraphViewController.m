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
@synthesize reloading=_reloading;
#pragma mark init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _reloading=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //程序初次运行的时候，如果不存在用户配置，自动加载默认配置
    [XMLManipulate wirteTestData];
    //设置scrollView
    [self setScrollView];
    //加载顶部刷新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-[self.view bounds].size.width, [self.view bounds].size.height, [self.view bounds].size.width)];
        view.delegate =self;
        [self.scrollView addSubview:view];
        _refreshHeaderView = view;
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    //加载所有视图，包括组视图与按钮视图
    [self loadAllViews];
    //[XMLManipulate setPageBackImgPath:@"/G1/" PageBackImgPath:@"/Users/Mac/Library/Application Support/iPhone Simulator/7.1/Applications/54A55042-FC5E-48D6-8171-161711EA33D5/Documents/child.jpg"];
    //注册通知中心，用于获取按钮状态更新信息
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
#pragma mark selfish function
//向服务器发送刷新信息
-(void) sendRefreshMsg:(UIButton *)sender{
    CmdSocket *cmdSocket = [[CmdSocket alloc] initWithButtonName:sender.titleLabel.text];
    NSString *cmdBtnPath = [_curPagePath stringByAppendingFormat:@"%@",sender.titleLabel.text ];
    NSMutableDictionary *md=[XMLManipulate getCmdBtnInfo:cmdBtnPath];
    [cmdSocket sendCmd:[md objectForKey:@"ServerIP"] ServerPort:[md objectForKey:@"ServerPort"] CmdText:[cmdBtnPath stringByAppendingFormat:@":Refresh"]];
    
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
    
    if (maxHeight +20< height) {
        maxHeight = height;
        //这里设置加1，是因为如果scrollView和界面一样大小，下拉刷新将失效
        maxHeight+=1;
    }
    else{
        
        maxHeight+=50;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.scrollView.contentSize = CGSizeMake(width,maxHeight);
    self.scrollView.delegate = self;
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.scrollView];
}

//获取组按钮的视图，不包含下面的标签，被loadAllViews调用
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

//获取命令按钮的视图，不包含下面的标签，被loadAllViews调用
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
    [newButton addTarget:self action:@selector(sendCmdMsg:) forControlEvents:UIControlEventTouchUpInside];
    //为命令按钮添加默认加载状态图标，即link.png
    UIView *stateImg=[[UIView alloc] initWithFrame:CGRectMake([[groupInfo objectForKey:@"Width"] floatValue]-24, [[groupInfo objectForKey:@"Height"] floatValue]-24, 24, 24)];
    [stateImg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"link.png"]]];
    //为了在刷新状态时找到该视图
    [stateImg setTag:1102];
    [newButton addSubview:stateImg];
    //刷新按钮的状态
    [self sendRefreshMsg:newButton];
    return newButton;
}

//获取按钮下面的标签视图（包括组按钮与命令按钮），被loadAllViews调用
-(id)getLabelView:(NSMutableDictionary *)groupInfo BtnTypeName:(NSString *)btnTypeName{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake([[groupInfo objectForKey:@"Location_x"] floatValue], [[groupInfo objectForKey:@"Location_y"] floatValue]+[[groupInfo objectForKey:@"Height"] floatValue], [[groupInfo objectForKey:@"Width"] floatValue], 20)];
    [newLabel setNumberOfLines:0];
    NSString *text = [groupInfo objectForKey:btnTypeName];
    newLabel.textAlignment=NSTextAlignmentCenter;
    newLabel.text=text;
    return newLabel;
}

//设置背景图片
-(void) setBackGroudImg{
    NSString *pageBackImgPath=[XMLManipulate getPageBackImgPath:_curPagePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pageBackImgPath]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"GOMON.jpg"]]];
    }else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:pageBackImgPath]]];
    }
    //  [self.view setBackgroundColor:[UIColor blueColor]];
}
//加载所有视图
-(void)loadAllViews{
    NSArray *groupsInfo=[XMLManipulate getGroupInfoByPath:_curPagePath];
    for(NSMutableDictionary *tmpDict in groupsInfo){
        [self.scrollView addSubview:[self getGroupView:tmpDict]];
        [self.scrollView addSubview:[self getLabelView:tmpDict BtnTypeName:@"GroupName"]];
    }
    
    NSArray *cmdBtnsInfo = [XMLManipulate getCmdBtnInfoByPath:_curPagePath];
    for(NSMutableDictionary *tmpDict in cmdBtnsInfo){
        [self.scrollView addSubview:[self getBtnView:tmpDict]];
        [self.scrollView addSubview:[self getLabelView:tmpDict BtnTypeName:@"CmdBtnName"]];
        
    }
    //判断是否为第一个页面，如果不是，加载一个返回按钮
    if (![_curPagePath isEqualToString:@"/"]) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
        backButton.titleLabel.text = @"back";
        backButton.backgroundColor = [UIColor redColor];
        [backButton addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:backButton];
    }
    
    [self setBackGroudImg];
}

//根据服务器返回的信息，刷新按钮状态
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
    NSLog(@"%@",sender.titleLabel.text);
    GraphViewController *next = [[GraphViewController alloc] init:[_curPagePath stringByAppendingFormat:@"%@/",sender.titleLabel.text]];
    [self presentViewController:next animated:YES completion:nil];
}

-(void)backToPre:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//向服务器发送按钮配置的命令
-(void)sendCmdMsg:(UIButton *)sender{
    CmdSocket *cmdSocket = [[CmdSocket alloc] initWithButtonName:sender.titleLabel.text];
    NSString *cmdBtnPath = [_curPagePath stringByAppendingFormat:@"%@",sender.titleLabel.text ];
    NSMutableDictionary *md=[XMLManipulate getCmdBtnInfo:cmdBtnPath];
    [cmdSocket sendCmd:[md objectForKey:@"ServerIP"] ServerPort:[md objectForKey:@"ServerPort"] CmdText:[cmdBtnPath stringByAppendingFormat:@":%@",[md objectForKey:@"Cmd"]]];
}

//注册中心对应的回调函数，当按钮的状态改变是，会调用该函数，设置按钮的状态
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
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    NSArray *subViews=[self.scrollView subviews];
    int count = 0;
    for (UIView *subview in subViews) {
        if ([subview isKindOfClass:[UIButton class]] && subview.tag == 1101) {
            [self sendRefreshMsg:(UIButton *)subview];
            count ++;
        }
    }
}

-(void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
    
}
@end
