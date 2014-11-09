//
//  ShowNextLevelViewController.m
//  SettingViewDemo
//
//  Created by mac on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShowNextLevelViewController.h"

@implementation ShowNextLevelViewController
@synthesize myTableView,menuList,pathValue;
@synthesize toolBar;

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.menuList=[[NSMutableArray alloc] init];
    [self loadSetting:self.pathValue];
    [self.myTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.pathValue;
    NSArray *names=[self.pathValue componentsSeparatedByString:@"/"];
    NSString *GroupNameTemp=(NSString *)[names objectAtIndex:[names count]-1];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc]initWithTitle:GroupNameTemp style:UIBarButtonItemStyleDone target:self action:@selector(backBtnClick)];
    [[self navigationItem] setLeftBarButtonItem:backBtn];
    //添加返回主界面按钮
    UIBarButtonItem *backToRootBtn=[[UIBarButtonItem alloc]initWithTitle:@"主界面" style:UIBarButtonItemStyleDone target:self action:@selector(backToRootBtnClick)];
    [[self navigationItem] setRightBarButtonItem:backToRootBtn];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteButtonInfo)];

    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - toolBar.frame.size.height-44.0, self.view.frame.size.width,44.0)];
    [toolBar setBarStyle:UIBarStyleDefault];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [toolBar setItems:[NSArray arrayWithObject:edit]];
    [self.view addSubview:toolBar];
    
  //  [self setToolbarItems:[NSArray arrayWithObject:edit]];
    // Do any additional setup after loading the view from its nib.
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToRootBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadSetting:(NSString *)groupPath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径
    NSArray *groupNames=[groupPath componentsSeparatedByString:@"/"];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) return;
    NSData *xmlData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    int deep=0;
    int Deep=[Names count];
    GDataXMLElement *tempNode=[doc rootElement];
    for (NSString *tempStr in Names) {
        if ([tempStr isEqualToString:@""]) {
            Deep--;
            continue;
        }
        BOOL flag=false;
        NSArray *groups2=[tempNode elementsForName:@"Group"];
        for (GDataXMLElement *tempElement in groups2) {
            NSArray *gName=[tempElement elementsForName:@"GroupName"];
            if ([gName count]>0) {
                GDataXMLElement *GName=(GDataXMLElement *)[gName objectAtIndex:0];
                if ([[GName stringValue] isEqualToString:tempStr]) {
                    deep++;
                    flag=true;
                    tempNode=tempElement;
                    break;
                }
            }
        }
        if(!flag){
            NSLog(@"找不到路径!\n");
            return;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return;
    }
    //    NSArray *groups=[[doc rootElement] nodesForXPath:[groupPath stringByAppendingFormat:path] error:nil];
    //    NSArray *btns=[[doc rootElement] nodesForXPath:[groupPath stringByAppendingFormat:path] error:nil];
    NSArray *groups=[tempNode elementsForName:@"Group"];
    NSArray *btns=[tempNode elementsForName:@"Button"];
    
    
    //添加组
    NameAndImageInfo *nameAndImage = nil;
    
    for (GDataXMLElement *group in groups) {
        NSString *GroupName,*ImgUrl;
        NSArray *temp=[group elementsForName:@"GroupName"];
        if ([temp count]>0) {
            GroupName=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
        }
        else continue;
        temp=[group elementsForName:@"ImgUrl"];
        if ([temp count]>0) {
            ImgUrl=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
        }
        else continue;
        nameAndImage=[[NameAndImageInfo alloc] init:GroupName ImgURL:ImgUrl isButton:false];
        [self.menuList addObject:nameAndImage];
    }
    
    //添加按钮
    for (GDataXMLElement *Button in btns) {
        NSString *ImgUrl,*Description;
        NSArray *temp = [Button elementsForName:@"ImgUrl"];
        if ([temp count]>0) {
            ImgUrl=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
        }
        else continue;
        
        temp=[Button elementsForName:@"Description"];
        if ([temp count]>0) {
            Description=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
        }
        else continue;
        nameAndImage=[[NameAndImageInfo alloc] init:Description ImgURL:ImgUrl isButton:true];
        [self.menuList addObject:nameAndImage];
        //[newButton release];
        
    }
    
}
bool tag = false;
-(void)deleteButtonInfo
{
    if(tag == false)
    {
        [self.myTableView setEditing:YES animated:YES];
        tag = true;
    }
    else
    {
        [self.myTableView setEditing:NO animated:YES];
        tag = false;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
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
    static NSString *kCellIdentifier = @"cellID";
	NameAndImageInfo *nameAndImage = [self.menuList objectAtIndex: [indexPath row]];
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
        
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
    
	// get the view controller's info dictionary based on the indexPath's row
    NSLog(@"按钮子页面：%@",nameAndImage.name);
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
        NewGroupViewVontroller *nextLevelView = [[NewGroupViewVontroller alloc] initWithNibName:@"NewGroupView" Path:[self.pathValue stringByAppendingFormat:@"/%@",rowData.name] isNew:false];
        [self.navigationController pushViewController:nextLevelView animated:YES];
    }
    else
    {
        AddNewButtonController *nextLevelView = [[AddNewButtonController alloc] initWithNibName:@"AddNewButton" Path:[self.pathValue stringByAppendingFormat:@"/%@",rowData.name] isNew:false];
        [self.navigationController pushViewController:nextLevelView animated:YES];
    }
    
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NameAndImageInfo *rowData = [self.menuList objectAtIndex:indexPath.row];
    ShowNextLevelViewController *nextLevelView = [[ShowNextLevelViewController alloc] initWithNibName:@"ShowNextLevelView" bundle:nil Path:[self.pathValue stringByAppendingFormat:@"/%@",rowData.name]];
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
           //? [cmdBtnClass DEL:[self.pathValue stringByAppendingFormat:@"/%@",rowData.name]];
            [XMLManipulate deleteCmdBtnByPath:[self.pathValue stringByAppendingFormat:@"%@/",rowData.name]];
            
        }
        else
        {
           //? [newGroupClass DEL:[self.pathValue stringByAppendingFormat:@"/%@",rowData.name]];
            [XMLManipulate deleteGroupByPath:[self.pathValue stringByAppendingFormat:@"%@/",rowData.name]];
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
