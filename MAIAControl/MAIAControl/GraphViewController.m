//
//  GraphViewController.m
//  MAIAControl

//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "GraphViewController.h"
#import "DemoTableController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController
@synthesize curPagePath=_curPagePath;
@synthesize scrollView=_scrollView;
@synthesize refreshHeaderView=_refreshHeaderView;
@synthesize storageCmd=_storageCmd;
@synthesize storageIP=_storageIP;
@synthesize storagePort=_storagePort;
@synthesize storageCmdBtnPath=_storageCmdBtnPath;
@synthesize storageCmdBtnName=_storageCmdBtnName;

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

-(void) viewWillAppear:(BOOL)animated{
//    for(UIView *view in [self.view subviews]){
//        [view removeFromSuperview];
//    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //加载所有视图，包括组视图与按钮视图
//    [self loadAllViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //程序初次运行的时候，如果不存在用户配置，自动加载默认配置
    [XMLManipulate wirteTestData];
    [self loadAllViews];
    //注册通知中心，用于获取按钮状态更新信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBtnStatus:) name:@"changeBtnStatus" object:nil];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [self.view addGestureRecognizer:tapGesture];
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
    NSString *cmdBtnPath = [_curPagePath stringByAppendingFormat:@"%@/",sender.titleLabel.text ];
    NSMutableDictionary *md=[XMLManipulate getCmdBtnInfo:cmdBtnPath];
    [cmdSocket sendCmd:[md objectForKey:@"ServerIP"] ServerPort:[md objectForKey:@"ServerPort"] CmdText:[cmdBtnPath stringByAppendingFormat:@":Refresh"]];
    
}
#pragma mark getview function
//加载顶部刷新
-(void)setRefreshHeaderView{
    if (_refreshHeaderView == nil) {
        float width= [self.view bounds].size.width;
        float height= [self.view bounds].size.height;
        if (width<height) {
            float tmp=width;
            width=height;
            height=tmp;
        }
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-height, width,height)];
        view.delegate =self;
        [self.scrollView addSubview:view];
        _refreshHeaderView = view;
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}
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
    NSString *ImgPath=[groupInfo objectForKey:@"ImgUrl"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ImgPath]) {
        [newButton setBackgroundImage:[UIImage imageNamed:@"iDisk.png"] forState:UIControlStateNormal];
    }else{
        //[newButton setBackgroundImage:[UIImage imageNamed:ImgPath] forState:UIControlStateNormal];
        //进行图片拉伸
        UIImageView *strechTest = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:ImgPath]];
        CGRect frame = strechTest.frame;
        frame.size.width =[[groupInfo objectForKey:@"Width"] floatValue];
        frame.size.height=[[groupInfo objectForKey:@"Height"] floatValue];
        strechTest.frame = frame;
        //把imageView放入button中，并设置为back
        [newButton addSubview:strechTest];
        [newButton sendSubviewToBack:strechTest];
        [newButton setBackgroundColor:[UIColor clearColor]];
    }
    
    newButton.showsTouchWhenHighlighted=true;
    newButton.titleLabel.text = [groupInfo objectForKey:@"GroupName"];
    newButton.titleLabel.enabled = false;
    [newButton addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    return newButton;
}

//获取命令按钮的视图，不包含下面的标签，被loadAllViews调用
-(id)getBtnView:(NSMutableDictionary *)btnInfo{
    UIButton *newButton=[[UIButton alloc] initWithFrame:CGRectMake([[btnInfo objectForKey:@"Location_x"] floatValue], [[btnInfo objectForKey:@"Location_y"] floatValue], [[btnInfo objectForKey:@"Width"] floatValue], [[btnInfo objectForKey:@"Height"] floatValue])];
    NSString *ImgPath=[btnInfo objectForKey:@"ImgUrl"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ImgPath]) {
        [newButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    }else{
        //[newButton setBackgroundImage:[UIImage imageNamed:ImgPath] forState:UIControlStateNormal];
        //  [btnView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:ImgPath]]];
        // [newButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:ImgPath]]];
        //进行图片拉伸
        UIImageView *strechTest = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:ImgPath]];
        CGRect frame = strechTest.frame;
        frame.size.width =[[btnInfo objectForKey:@"Width"] floatValue];
        frame.size.height=[[btnInfo objectForKey:@"Height"] floatValue];
        strechTest.frame = frame;
        //把imageView放入button中，并设置为back
        [newButton addSubview:strechTest];
        [newButton sendSubviewToBack:strechTest];
        [newButton setBackgroundColor:[UIColor clearColor]];
        
    }
    newButton.showsTouchWhenHighlighted=true;
    newButton.titleLabel.text = [btnInfo objectForKey:@"CmdBtnName"];
    //为了在下拉刷新时判断按钮是组视图还是命令按钮视图
    [newButton setTag:1101];
    [newButton addTarget:self action:@selector(sendCmdMsg:) forControlEvents:UIControlEventTouchUpInside];
    //为命令按钮添加默认加载状态图标，即link.png
    UIView *stateImg=[[UIView alloc] initWithFrame:CGRectMake([[btnInfo objectForKey:@"Width"] floatValue]-24, [[btnInfo objectForKey:@"Height"] floatValue]-24, 24, 24)];
    [stateImg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"link.png"]]];
    //为了在刷新状态时找到该视图
    [stateImg setTag:1102];
    [newButton addSubview:stateImg];
    //刷新按钮的状态
    [self sendRefreshMsg:newButton];
    return newButton;
}

//获取命令按钮的视图，不包含下面的标签，被loadAllViews调用
-(id)getPopBtnView:(NSMutableDictionary *)btnInfo{
    UIButton *newButton=[[UIButton alloc] initWithFrame:CGRectMake([[btnInfo objectForKey:@"Location_x"] floatValue], [[btnInfo objectForKey:@"Location_y"] floatValue], [[btnInfo objectForKey:@"Width"] floatValue], [[btnInfo objectForKey:@"Height"] floatValue])];
    NSString *ImgPath=[btnInfo objectForKey:@"ImgUrl"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ImgPath]) {
        [newButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    }else{
        //[newButton setBackgroundImage:[UIImage imageNamed:ImgPath] forState:UIControlStateNormal];
        //进行图片拉伸
        UIImageView *strechTest = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:ImgPath]];
        CGRect frame = strechTest.frame;
        frame.size.width =[[btnInfo objectForKey:@"Width"] floatValue];
        frame.size.height=[[btnInfo objectForKey:@"Height"] floatValue];
        strechTest.frame = frame;
        //把imageView放入button中，并设置为back
        [newButton addSubview:strechTest];
        [newButton sendSubviewToBack:strechTest];
        [newButton setBackgroundColor:[UIColor clearColor]];
    }
    newButton.showsTouchWhenHighlighted=true;
    newButton.titleLabel.text = [btnInfo objectForKey:@"PopBtnName"];
    //为了在下拉刷新时判断按钮是组视图还是命令按钮视图
    [newButton setTag:1103];
    [newButton addTarget:self action:@selector(popMiniView:) forControlEvents:UIControlEventTouchUpInside];
    return newButton;
}
//获取按钮下面的标签视图（包括组按钮与命令按钮），被loadAllViews调用
-(id)getLabelView:(NSMutableDictionary *)groupInfo BtnTypeName:(NSString *)btnTypeName{
    if (![[groupInfo objectForKey:@"LabelWillDisplay"] isEqualToString:@"YES"]) {
        return nil;
    }
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
        //进行图片拉伸
        UIImageView *strechTest = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pageBackImgPath]];
        CGRect frame = strechTest.frame;
        float width= [self.view bounds].size.width;
        float height= [self.view bounds].size.height;
        if (width<height) {
            float tmp=width;
            width=height;
            height=tmp;
        }
        frame.size.width =width;
        frame.size.height=height;
        strechTest.frame = frame;
        //把imageView放入view中，并设置为back
        [self.view addSubview:strechTest];
        [self.view  sendSubviewToBack:strechTest];
        //[self.view setBackgroundColor:[UIColor clearColor]];
    }
}
//加载所有视图
-(void)loadAllViews{
    //以下两个个操作一定要放在添加按钮和组等控件之前，因为他们都是放在scrollView中的
    [self setScrollView];
    [self setRefreshHeaderView];
    [self setBackGroudImg];
    
    NSArray *groupsInfo=[XMLManipulate getGroupInfoByPath:_curPagePath];
    for(NSMutableDictionary *tmpDict in groupsInfo){
        [self.scrollView addSubview:[self getGroupView:tmpDict]];
        if ([self getLabelView:tmpDict BtnTypeName:@"GroupName"]!=nil) {
            [self.scrollView addSubview:[self getLabelView:tmpDict BtnTypeName:@"GroupName"]];
        }
    }
    
    NSArray *cmdBtnsInfo = [XMLManipulate getCmdBtnInfoByPath:_curPagePath];
    for(NSMutableDictionary *tmpDict in cmdBtnsInfo){
        [self.scrollView addSubview:[self getBtnView:tmpDict]];
        if ([self getLabelView:tmpDict BtnTypeName:@"CmdBtnName"]!=nil) {
            [self.scrollView addSubview:[self getLabelView:tmpDict BtnTypeName:@"CmdBtnName"]];
        }
    }
    
    NSArray *PopBtnsInfo = [XMLManipulate getPopBtnInfoByPath:_curPagePath];
    for(NSMutableDictionary *tmpDict in PopBtnsInfo){
        [self.scrollView addSubview:[self getPopBtnView:tmpDict]];
        if ([self getLabelView:tmpDict BtnTypeName:@"PopBtnName"]!=nil) {
            [self.scrollView addSubview:[self getLabelView:tmpDict BtnTypeName:@"PopBtnName"]];
        }
    }
    //加载一个按钮，用于控制显示NavigationBar
    UIButton *LoginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.height-40, 10, 30, 30)];
    LoginButton.titleLabel.text = @"Administrator";
    LoginButton.showsTouchWhenHighlighted=true;
    [LoginButton setBackgroundImage:[UIImage imageNamed:@"Lock.png"] forState:UIControlStateNormal];
    [LoginButton addTarget:self action:@selector(showTheNavigationBar) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:LoginButton];
    //判断是否为第一个页面，如果不是，加载一个返回按钮，否则加载登录界面按钮
    if (![_curPagePath isEqualToString:@"/"]) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
        backButton.titleLabel.text = @"back";
        [backButton setBackgroundImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backToPre:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:backButton];
    }
    else{
        UIBarButtonItem *nextBtn=[[UIBarButtonItem alloc]initWithTitle:@"配置" style:UIBarButtonItemStyleDone target:self action:@selector(showTheLoginView)];
        [[self navigationItem] setRightBarButtonItem:nextBtn];
        
        UIButton *modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [modalViewButton addTarget:self action:@selector(modalViewAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *modalBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
        self.navigationItem.leftBarButtonItem = modalBarButtonItem;
    }
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

-(void)disPlayNotification:(NSString *)info{
    UILabel *topView = [[UILabel alloc] initWithFrame: CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 40)];
    topView.backgroundColor = [UIColor clearColor];
    topView.text = info;
    topView.textColor = [UIColor yellowColor];
    topView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topView];
    topView.tag = 1104;
    
    [self performSelector:@selector(removeView) withObject:nil afterDelay:2];
    
}

-(void)removeView{
    [[self.view viewWithTag:1104] removeFromSuperview];
}


#pragma mark - response function
//组按钮的跳转函数
-(void)jump:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    GraphViewController *next = [[GraphViewController alloc] init:[_curPagePath stringByAppendingFormat:@"%@/",sender.titleLabel.text]];
    next.title=[_curPagePath stringByAppendingFormat:@"%@/",sender.titleLabel.text];
    //[[self navigationController] pushViewController:next animated:YES];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.8];
    [animation setType:kCATransitionFade];
    [animation setSubtype: kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController pushViewController:next animated:NO];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}

//小窗口按钮的弹出函数
-(void)popMiniView:(UIButton *)sender{
    //the controller we want to present as a popover
    DemoTableController *controller = [[DemoTableController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.popBtnPath = [_curPagePath stringByAppendingFormat:@"%@/",sender.titleLabel.text];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(300, 500);
    }
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    [popover presentPopoverFromView:sender];

}
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
}

-(void)backToPre:(UIButton *)sender{
//?    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}
-(void)showTheNavigationBar{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
-(void)showTheLoginView{
//    SettingViewController *next = [[SettingViewController alloc]  initWithNibName:@"SettingView" bundle:nil];
//    [self.navigationController pushViewController:next animated:YES];
    LoginViewController *next=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}

//向服务器发送按钮配置的命令
-(void)sendCmdMsg:(UIButton *)sender{
    NSString *cmdBtnPath = [_curPagePath stringByAppendingFormat:@"%@/",sender.titleLabel.text ];
    NSMutableDictionary *md=[XMLManipulate getCmdBtnInfo:cmdBtnPath];
    _storageCmdBtnName=sender.titleLabel.text;
    _storageIP=[md objectForKey:@"ServerIP"];
    _storagePort=[md objectForKey:@"ServerPort"];
    _storageCmdBtnPath=cmdBtnPath;
    _storageCmd=[md objectForKey:@"Cmd"];
    if ([[md objectForKey:@"WarnWillDisplay"] compare:@"YES" options:NSCaseInsensitiveSearch]==NSOrderedSame) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"操作提示" message:@"是否执行该命令" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    else{
        CmdSocket *cmdSocket = [[CmdSocket alloc] initWithButtonName:_storageCmdBtnName];
        [cmdSocket sendCmd:_storageIP ServerPort:_storagePort CmdText:[_storageCmdBtnPath stringByAppendingFormat:@":%@",_storageCmd]];
    }
}

//注册中心对应的回调函数，当按钮的状态改变是，会调用该函数，设置按钮的状态
-(void)changeBtnStatus:(NSNotification *)notification{
    NSDictionary *nd=[notification userInfo];
    [nd objectForKey:@"CmdBtnName"] ;
    NSString *btnName=[nd objectForKey:@"CmdBtnName"];
    NSInteger btnState=[[nd objectForKey:@"CmdBtnState"] integerValue];
    NSString *info = [nd objectForKey:@"NotificationInfo"];
    [self disPlayNotification:info];
    [self refresh:btnName BtnState:btnState];
}

//手势操作，取消navigation的显示
-(void)Actiondo:(id)sender{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //NSLog(@"ContentOffset  x is  %f,yis %f",self.scrollView.contentOffset.x,self.scrollView.contentOffset.y);
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)modalViewAction:(id)sender
{
    int flag=[imageManager getHelpFlag];
    if (flag==1) {
        AboutViewController *target=[[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:target animated:YES];
    }
    
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
#pragma  mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        CmdSocket *cmdSocket = [[CmdSocket alloc] initWithButtonName:_storageCmdBtnName];
        [cmdSocket sendCmd:_storageIP ServerPort:_storagePort CmdText:[_storageCmdBtnPath stringByAppendingFormat:@":%@",_storageCmd]];
    }
}
@end
