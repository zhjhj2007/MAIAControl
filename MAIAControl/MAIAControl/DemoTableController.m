//
//  DemoTableControllerViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "DemoTableController.h"
#import "XMLManipulate.h"
#import "CmdSocket.h"
@interface DemoTableController ()
@property (nonatomic,retain) NSMutableDictionary *popBtnInfo;
@end

@implementation DemoTableController

@synthesize popBtnPath = _popBtnPath;
@synthesize popBtnInfo = _popBtnInfo;
- (void)viewDidLoad
{
    [super viewDidLoad];
    _popBtnInfo = [XMLManipulate getPopBtnInfo:_popBtnPath];
    self.title = [_popBtnInfo objectForKey:@"PopBtnName"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - get popbtninfos
-(NSArray *)getDeviceAndCmd{
    //NSString *devices = [_popBtnInfo objectForKey:@"Devices"];
    NSMutableArray *deviceAndCmdname = [[NSMutableArray alloc] init];
    NSArray *devices = [[_popBtnInfo objectForKey:@"Devices"] componentsSeparatedByString:@"^"];
    NSArray *cmds = [[_popBtnInfo objectForKey:@"Cmds"] componentsSeparatedByString:@"^"];
    NSArray *cmdNames = [[_popBtnInfo objectForKey:@"CmdNames"] componentsSeparatedByString:@"^"];
    
    if ([devices count] != [cmds count]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"XML文件设置出错" message:@"弹出框设置出错" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
    
    for (int i = 0 ; i < [cmds count]; i++) {
        NSArray *cmdsTemp = [[cmds objectAtIndex:i] componentsSeparatedByString:@"|"];
        for (int j = 0 ; j < [cmdsTemp count]; j++) {
            [deviceAndCmdname addObject:[NSString stringWithFormat:@"%@\t\t%@",[devices objectAtIndex:i],[cmdNames objectAtIndex:i+j]]];
        }
    }
    return deviceAndCmdname;
}

-(NSArray *)getCmds{
    NSArray *cmds=[[_popBtnInfo objectForKey:@"Cmds"] componentsSeparatedByString:@"^"];
    return cmds;
}

-(NSArray *)getDevices{
    NSArray *devices=[[_popBtnInfo objectForKey:@"Devices"] componentsSeparatedByString:@"^"];
    return devices;
}


-(NSArray *)getCmdNames{
    NSArray *CmdNames=[[_popBtnInfo objectForKey:@"CmdNames"] componentsSeparatedByString:@"^"];
    return CmdNames;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self getDevices] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *cmdStrings = [_popBtnInfo objectForKey:@"Cmds"];
    NSArray *cmdArray = [cmdStrings componentsSeparatedByString:@"^"];
    return [[[cmdArray objectAtIndex:section] componentsSeparatedByString:@"|"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSInteger count=0;
    for (int i=0; i<indexPath.section; i++) {
        count+=[self tableView:tableView numberOfRowsInSection:i];
    }
    cell.textLabel.text = [[self getCmdNames] objectAtIndex:(indexPath.row+count)];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self getDevices] objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger count=0;
//    for (int i=0; i<indexPath.section; i++) {
//        count+=[self tableView:tableView numberOfRowsInSection:i];
//    }
    NSString *cmd=[[[[self getCmds] objectAtIndex:indexPath.section] componentsSeparatedByString:@"|"] objectAtIndex:indexPath.row];
    
    CmdSocket *cmdSocket = [[CmdSocket alloc] initWithButtonName:[[self getDevices] objectAtIndex:indexPath.section]];
    [cmdSocket sendCmd:[_popBtnInfo objectForKey:@"ServerIP"] ServerPort:[_popBtnInfo objectForKey:@"ServerPort"] CmdText:cmd];
}

@end
