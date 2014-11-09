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
@synthesize buttonAndGroup,pathValue;
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
        self.navController=[[UINavigationController alloc] init];
        [self.view addSubview:self.navController.view];
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
    //跳转到新增界面
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewButtnAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backBtnClick)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"主界面" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteButtonInfo)];
    
    UIBarButtonItem *backGround = [[UIBarButtonItem alloc]initWithTitle:@"背景" style:UIBarButtonItemStyleDone target:self action:@selector(setViewBackground:)];
    
    //UISwitch *switchHelp=[[UISwitch alloc] initWithFrame:CGRectMake(100, 0, 90, 90)];
    
    int flag=[imageManager getHelpFlag];
    NSString *temp;
    if (flag==1) {
        temp=@"帮助不可见";
    }
    else
        temp=@"帮助可见";
    onHelp = [[UIBarButtonItem alloc]initWithTitle:temp style:UIBarButtonItemStyleDone target:self action:@selector(changeHelp)];
    //
    //    NSMutableArray *tbItems = [NSMutableArray array];
    //
    UIBarButtonItem *ss=[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:self action:nil];
    ss.width = self.view.frame.size.width-200.0;
    //
    //    UIBarButtonItem *dd=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    //    dd.title = @"背景";
    //    dd.width = 20.0f;
    //    [tbItems addObject:ss];
    //    [tbItems addObject:dd];
    //
    //   [self setToolbarItems:[NSArray arrayWithObjects:edit,backGround,nil]];
    
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - toolBar.frame.size.height-44.0, self.view.frame.size.width,44.0)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [toolBar setItems:[NSArray arrayWithObjects:edit,onHelp,ss,backGround,nil] animated:YES];
    
    //toolBar.items = tbItems;
    [self.view addSubview:toolBar];
    
    // [self.toolBar setAlpha:0.4f];
    
    self.menuList = [[NSMutableArray alloc] init];
    if(self.pathValue == nil)
    {
        self.pathValue = @"/";
    }
    
    //每次加载前，清空menulist
    [menuList removeAllObjects];
    [self loadSetting:self.pathValue];
    // [self.myTableView setEditing:YES animated:YES];
    
    // Do any additional setup after loading the view from its nib.
}
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
    //  [self presentModalViewController:picker animated:YES];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setTag:120];
    
    //    for (UIView *subview in self.view.subviews) {
    //        if ([subview tag]==120) {
    //            [subview removeFromSuperview];
    //            [subview release];
    //        }
    //    }
    // [self.view setBackgroundColor:[UIColor colorWithPatternImage:imageView.image]];
    [imageManager saveBackGroundImg:image];
    
    [self.view insertSubview:imageView atIndex:0];
    [self.popoverController dismissPopoverAnimated:YES];
    //[imageView release];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   // [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadSetting:(NSString *)groupPath{
    NSLog(@"初始化");
    NSArray *groups=[XMLManipulate getGroupInfoByPath:groupPath];
    NSArray *btns=[XMLManipulate getCmdBtnInfoByPath:groupPath];
    
    //添加组
    NameAndImageInfo *nameAndImage = nil;
    
    for (NSDictionary *group in groups) {
        NSString *GroupName=[group objectForKey:@"GroupName"];
        NSString *ImgUrl=[group objectForKey:@"ImgUrl"];
        nameAndImage=[[NameAndImageInfo alloc] init:GroupName ImgURL:ImgUrl isButton:false];
        [self.menuList addObject:nameAndImage];
    }
    
    //添加按钮
    for (NSDictionary *Button in btns) {
        NSString *GroupName=[Button objectForKey:@"CmdBtnName"];
        NSString *ImgUrl=[Button objectForKey:@"ImgUrl"];
        nameAndImage=[[NameAndImageInfo alloc] init:GroupName ImgURL:ImgUrl isButton:false];
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
    //这里为什么传递过去的路径是空？
    self.buttonAndGroup = [[NewButtonAndGroupViewController alloc]initWithNibName:@"NewButtonAndGroupView" bundle:nil Path:@""];
    self.buttonAndGroup.title = @"添加界面";
    [self.navigationController pushViewController:self.buttonAndGroup animated:YES];
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    //[self.menuList release];
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
        if (nameAndImage.isButton) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
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
    
    NSLog(@"按钮首页面：%@",nameAndImage.name);
    UIImage *image = nil;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *ImgPath=[documentsPath stringByAppendingFormat:@"/%@",nameAndImage.ImgURL];
    image=[UIImage imageWithContentsOfFile:ImgPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ImgPath])
    {
        image=[UIImage imageWithContentsOfFile:ImgPath];
    }
    else
    {
        if(nameAndImage.isButton)
        {
            image = [UIImage imageNamed:@"Bug.png"];
        }
        else
        {
            image = [UIImage imageNamed:@"iDisk.png"];
        }
    }
    cell.textLabel.text = nameAndImage.name;
    cell.imageView.image = image;
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameAndImageInfo *rowData = [self.menuList objectAtIndex:indexPath.row];
    if(!rowData.isButton)
    {
        NewGroupViewVontroller *nextLevelView = [[NewGroupViewVontroller alloc] initWithNibName:@"NewGroupView" Path:[self.pathValue stringByAppendingFormat:@"%@",rowData.name] isNew:false];
        [self.navigationController pushViewController:nextLevelView animated:YES];
    }
    else
    {
        AddNewButtonController *nextLevelView = [[AddNewButtonController alloc] initWithNibName:@"AddNewButton" Path:[self.pathValue stringByAppendingFormat:@"%@",rowData.name] isNew:false];
        [self.navigationController pushViewController:nextLevelView animated:YES];
    }
    
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NameAndImageInfo *rowData = [self.menuList objectAtIndex:indexPath.row];
    ShowNextLevelViewController *nextLevelView = [[ShowNextLevelViewController alloc] initWithNibName:@"ShowNextLevelView" bundle:nil Path:[self.pathValue stringByAppendingFormat:@"%@",rowData.name]];
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
        if(rowData.isButton)
        {
            [XMLManipulate deleteCmdBtnByPath:[self.pathValue stringByAppendingFormat:@"/%@",rowData.name]];
        }
        else
        {
            [XMLManipulate deleteGroupByPath:[self.pathValue stringByAppendingFormat:@"/%@",rowData.name]];
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
