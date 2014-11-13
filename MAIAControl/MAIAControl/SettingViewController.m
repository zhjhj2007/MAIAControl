//
//  SettingViewController.m
//  SettingViewDemo
//
//  Created by mac on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"

@implementation SettingViewController
@synthesize menuList,myTableView;
@synthesize pathValue;
@synthesize toolBar;
@synthesize popoverController;
@synthesize onHelp;

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
        self.menuList=[[NSMutableArray alloc] init];
        [self loadSetting:Path];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [menuList removeAllObjects];
    [self loadSetting:self.pathValue];
    [self.myTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) changeHelp{
    [imageManager helpFlag];
    int flag=[imageManager getHelpFlag];
    if (flag==1) {
        onHelp.title=@"帮助不可见";
    }
    else{
        onHelp.title=@"帮助可见";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //左边是默认的返回上一层按钮，右边是新增按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButtnAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteButtonInfo)];
    UIBarButtonItem *systemSetting = [[UIBarButtonItem alloc]initWithTitle:@"系统设置" style:UIBarButtonItemStyleDone target:self action:@selector(jumpToSystemSetting)];
    UIBarButtonItem *backGround = [[UIBarButtonItem alloc]initWithTitle:@"背景" style:UIBarButtonItemStyleDone target:self action:@selector(setViewBackground:)];
    
    int flag=[imageManager getHelpFlag];
    NSString *temp;
    if (flag==1) {
        temp=@"帮助不可见";
    }
    else
        temp=@"帮助可见";
    onHelp = [[UIBarButtonItem alloc]initWithTitle:temp style:UIBarButtonItemStyleDone target:self action:@selector(changeHelp)];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - toolBar.frame.size.height-44.0, self.view.frame.size.width,44.0)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    //空白按钮，用于将四个按钮隔开
    UIBarButtonItem *itemButtonEmpty = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:edit,itemButtonEmpty,onHelp,itemButtonEmpty,systemSetting,itemButtonEmpty,backGround,nil] animated:YES];
    //以下两句可以将toolBar设置为透明
//    [toolBar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [toolBar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
    
    [self.view addSubview:toolBar];
    
    self.menuList = [[NSMutableArray alloc] init];
    if(self.pathValue == nil)
    {
        self.pathValue = @"/";
    }
    
    //每次加载前，清空menulist
    [menuList removeAllObjects];
    [self loadSetting:self.pathValue];
}
//按背景按钮，触发时间，弹出选择照片窗口
- (IBAction)setViewBackground:(id)sender
{
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
}
-(void)jumpToSystemSetting{
    SystemViewController *next=[[SystemViewController alloc] initWithNibName:@"SystemViewController" bundle:nil];
    [self.navigationController pushViewController:next animated:YES];
}
//代理方法，设置背景图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSString *query=[imageURL query];
    NSArray *tmps=[query componentsSeparatedByString:@"="];
    NSArray *tmps2=[[tmps objectAtIndex:1] componentsSeparatedByString:@"&"];
    NSString *imageName=[[tmps2 objectAtIndex:0] stringByAppendingFormat:@".%@", [tmps objectAtIndex:2]];
    NSLog(@"%@",imageName);
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *oldImgPath=[XMLManipulate getPageBackImgPath:pathValue];
    [imageManager saveImgToFileSystem:image ImageName:imageName OldImgPath:oldImgPath];
    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath=[paths objectAtIndex:0];
//    NSString *newImgPath=[documentsPath stringByAppendingFormat:@"/%@",imageName];
    [XMLManipulate setPageBackImgPath:pathValue PageBackImgPath:imageName];
    [self.popoverController dismissPopoverAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadSetting:(NSString *)groupPath{
    NSLog(@"初始化");
    NSArray *groups=[XMLManipulate getGroupInfoByPath:groupPath];
    NSArray *btns=[XMLManipulate getCmdBtnInfoByPath:groupPath];
    NSArray *popBtns=[XMLManipulate getPopBtnInfoByPath:groupPath];
    
    //添加组
    NameAndImageInfo *nameAndImage = nil;
    for (NSDictionary *group in groups) {
        NSString *GroupName=[group objectForKey:@"GroupName"];
        NSString *documentPath=[XMLManipulate getDocumentPath];
        NSString *ImgUrl=[documentPath stringByAppendingFormat:@"/%@", [group objectForKeyedSubscript:@"ImgUrl"] ];
        nameAndImage=[[NameAndImageInfo alloc] init:GroupName ImgURL:ImgUrl ButtonTypeValue:NSGroupType];
        [self.menuList addObject:nameAndImage];
    }
    //添加命令按钮
    for (NSDictionary *Button in btns) {
        NSString *GroupName=[Button objectForKey:@"CmdBtnName"];
        NSString *documentPath=[XMLManipulate getDocumentPath];
        NSString *ImgUrl=[documentPath stringByAppendingFormat:@"/%@", [Button objectForKeyedSubscript:@"ImgUrl"] ];
        nameAndImage=[[NameAndImageInfo alloc] init:GroupName ImgURL:ImgUrl ButtonTypeValue:NSButtonType];
        [self.menuList addObject:nameAndImage];
    }
    //添加弹出按钮
    for (NSDictionary *PopBtn in popBtns) {
        NSString *PopBtnName=[PopBtn objectForKey:@"PopBtnName"];
        NSString *documentPath=[XMLManipulate getDocumentPath];
        NSString *ImgUrl=[documentPath stringByAppendingFormat:@"/%@", [PopBtn objectForKeyedSubscript:@"ImgUrl"] ];
        nameAndImage=[[NameAndImageInfo alloc] init:PopBtnName ImgURL:ImgUrl ButtonTypeValue:NSPopBtnType];
        [self.menuList addObject:nameAndImage];
    }
}

bool flag = false;
-(void)deleteButtonInfo
{
    if(flag == false)
    {
        [self.myTableView setEditing:YES animated:YES];
        flag = true;
    }
    else
    {
        [self.myTableView setEditing:NO animated:YES];
        flag = false;
    }
    
}
- (IBAction)addNewButtnAction:(id)sender
{
    NewButtonAndGroupViewController *next=[[NewButtonAndGroupViewController alloc] initWithNibName:@"NewButtonAndGroupView" bundle:nil Path:pathValue];
    next.title=@"添加界面";
    [self.navigationController pushViewController:next animated:YES];
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *kCellIdentifier = [[NSString alloc]initWithFormat:@"Cell %d",[indexPath indexAtPosition:1]];
	NameAndImageInfo *nameAndImage = [self.menuList objectAtIndex: [indexPath row]];
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        if (nameAndImage.type==NSButtonType) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(nameAndImage.type==NSGroupType)
        {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
		
        cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.opaque = NO;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.highlightedTextColor = [UIColor whiteColor];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
	// get the view controller's info dictionary based on the indexPath's row
    UIImage *image;
    if ([[NSFileManager defaultManager] fileExistsAtPath:nameAndImage.imgURL])
    {
        image=[UIImage imageWithContentsOfFile:nameAndImage.imgURL];
    }
    else
    {
        if(nameAndImage.type==NSButtonType){
            image = [UIImage imageNamed:@"Bug.png"];
        }
        else if(nameAndImage.type==NSGroupType){
            image = [UIImage imageNamed:@"iDisk.png"];
        }
        else if(nameAndImage.type==NSPopBtnType){
            image=[UIImage imageNamed:@"popBtn.png"];
        }
    }
    cell.textLabel.text = nameAndImage.name;
    cell.imageView.image = image;
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameAndImageInfo *rowData = [self.menuList objectAtIndex:indexPath.row];
    if(rowData.type==NSGroupType){
        NewGroupViewVontroller *nextLevelView = [[NewGroupViewVontroller alloc] initWithNibName:@"NewGroupView" CurPath:pathValue isNew:false GroupName:rowData.name];
        [self.navigationController pushViewController:nextLevelView animated:YES];
    }
    else if(rowData.type==NSButtonType){
        AddNewButtonController *nextLevelView=[[AddNewButtonController alloc] initWithNibName:@"AddNewButton" CurPath:pathValue isNew:false CmdBtnName:rowData.name];
        [self.navigationController pushViewController:nextLevelView animated:YES];
    }
    else if(rowData.type==NSPopBtnType){
        NewPopButtonViewController *nextLevelView=[[NewPopButtonViewController alloc] initWithNibName:@"NewPopButtonViewController" CurPath:pathValue isNew:false CmdBtnName:rowData.name];
        [self.navigationController pushViewController:nextLevelView animated:YES];
    }
    
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NameAndImageInfo *rowData = [self.menuList objectAtIndex:indexPath.row];
    SettingViewController *nextLevelView=[[SettingViewController alloc] initWithNibName:@"SettingView" bundle:nil Path:[self.pathValue stringByAppendingFormat:@"%@/",rowData.name]];
    [self.navigationController pushViewController:nextLevelView animated:YES];
}
-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == self.menuList.count)
    {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger fromRow = [sourceIndexPath row];
    [self.menuList removeObjectAtIndex:fromRow];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NameAndImageInfo *rowData = [self.menuList objectAtIndex:indexPath.row];
        if(rowData.type==NSButtonType)
        {
            [XMLManipulate deleteCmdBtnByPath:[self.pathValue stringByAppendingFormat:@"%@/",rowData.name]];
        }
        else if(rowData.type==NSGroupType)
        {
            [XMLManipulate deleteGroupByPath:[self.pathValue stringByAppendingFormat:@"%@/",rowData.name]];
        }
        else if(rowData.type==NSPopBtnType){
            [XMLManipulate deletePopBtnByPath:[self.pathValue stringByAppendingFormat:@"%@/",rowData.name]];
        }
        [self.menuList removeObjectAtIndex:indexPath.row];
        [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
