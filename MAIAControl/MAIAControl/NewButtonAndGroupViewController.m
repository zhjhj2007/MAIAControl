//
//  NewButtonAndGoupViewController.m
//  SettingViewDemo
//
//  Created by mac on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewButtonAndGroupViewController.h"

@implementation NewButtonAndGroupViewController
@synthesize menuList,myTableView,pathValue;

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
    self.menuList=[[NSMutableArray alloc] init];
    [self loadSetting:self.pathValue];
    [self.myTableView reloadData];
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
    NSArray *groups=[tempNode elementsForName:@"Group"];
   
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
        nameAndImage=[[NameAndImageInfo alloc] init:GroupName ImgURL:ImgUrl ButtonTypeValue:NSGroupType];
        [self.menuList addObject:nameAndImage];
    }
    nameAndImage=[[NameAndImageInfo alloc] init:@"添加命令按钮" ImgURL:@"url" ButtonTypeValue:NSButtonType];
    [self.menuList addObject:nameAndImage];
    nameAndImage=[[NameAndImageInfo alloc] init:@"添加分组" ImgURL:@"url" ButtonTypeValue:NSButtonType];
    [self.menuList addObject:nameAndImage];
    nameAndImage=[[NameAndImageInfo alloc] init:@"添加弹出按钮" ImgURL:@"url" ButtonTypeValue:NSButtonType];
    [self.menuList addObject:nameAndImage];
    
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.pathValue;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    // get the view controller's info dictionary based on the indexPath's row
    NameAndImageInfo *nameAndImage = [self.menuList objectAtIndex: [indexPath row]];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
        
		if (nameAndImage.type==NSButtonType) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(nameAndImage.type==NSGroupType)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.opaque = NO;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    
    
    NSLog(@"add:%@",nameAndImage.name);
    UIImage *image = nil;
    if(nameAndImage.type==NSButtonType)
    {
        image = [UIImage imageNamed:@"add.png"];
    }
    else if(nameAndImage.type==NSGroupType)
    {
        NSString *ImgPath=nameAndImage.imgURL;
        if ([[NSFileManager defaultManager] fileExistsAtPath:ImgPath])
        {
            image=[UIImage imageWithContentsOfFile:ImgPath];
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
    if([rowData.name isEqualToString:@"添加命令按钮"])
    {
        AddNewButtonController *newButton = [[AddNewButtonController alloc]initWithNibName:@"AddNewButton" CurPath:pathValue isNew:YES];
 
        newButton.title = rowData.name;
        [self.navigationController pushViewController:newButton animated:YES];
    }
    else if([rowData.name isEqualToString:@"添加分组"])
    {
        NewGroupViewVontroller *newGroup=[[NewGroupViewVontroller alloc] initWithNibName:@"NewGroupView" CurPath:pathValue isNew:true];
        newGroup.title = rowData.name;
        [self.navigationController pushViewController:newGroup animated:YES];
    }
    else if ([rowData.name isEqualToString:@"添加弹出按钮"]){
        NewPopButtonViewController *next=[[NewPopButtonViewController alloc] initWithNibName:@"NewPopButtonViewController" CurPath:pathValue isNew:true];
        next.title=rowData.name;
        [self.navigationController pushViewController:next animated:YES];
    }
	else
    {
        NewButtonAndGroupViewController *nextLevelView = [[NewButtonAndGroupViewController alloc]initWithNibName:@"NewButtonAndGroupView" bundle:nil Path:[self.pathValue stringByAppendingFormat:@"%@/",rowData.name]];
        
        nextLevelView.title = rowData.name;
        [self.navigationController pushViewController:nextLevelView animated:YES];
    }
}
@end
