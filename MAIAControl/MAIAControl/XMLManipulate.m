//
//  XMLManipulate.m
//  MAIAControl
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "XMLManipulate.h"

@implementation XMLManipulate
#pragma mark Get Operation
//组的读操作，返回词典
+(NSMutableDictionary *)getGroupInfo:(NSString *)groupPath{
    NSMutableDictionary *groupInfo=[NSMutableDictionary dictionary];
    
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/组3/，注意最后以'/'结尾
    NSArray *groupNames=[groupPath componentsSeparatedByString:@"/"];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        return groupInfo;
    }
    NSData *xmlData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    //用于检测根路径的情况
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
            return groupInfo;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return groupInfo;
    }
    
    NSArray *temp=[tempNode elementsForName:@"GroupName"];
    if ([temp count]>0) {
        [groupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"GroupName"];
    }
    temp=[tempNode elementsForName:@"ImgUrl"];
    if ([temp count]>0) {
        [groupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ImgUrl"];
    }
    temp=[tempNode elementsForName:@"Location_x"];
    if ([temp count]>0) {
        [groupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_x"];
    }
    temp=[tempNode elementsForName:@"Location_y"];
    if ([temp count]>0) {
        [groupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue]forKey:@"Location_y"];
    }
    temp=[tempNode elementsForName:@"Width"];
    if ([temp count]>0) {
        [groupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Width"];
    }
    temp=[tempNode elementsForName:@"Height"];
    if ([temp count]>0) {
        [groupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue]forKey:@"Height"];
    }
    temp=[tempNode elementsForName:@"LabelWillDisplay"];
    if ([temp count]>0) {
        [groupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"LabelWillDisplay"];
    }
    return groupInfo;
}
//按钮的读操作，返回词典
+(NSMutableDictionary *)getCmdBtnInfo:(NSString *)cmdBtnPath{
    NSMutableDictionary *cmdBtnInfo=[NSMutableDictionary dictionary];
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/按钮3/，注意最后以'/'结尾，并且最后一个是按钮名
    //以下是为了处理掉按钮的名字
    NSArray *fakegroupNames=[cmdBtnPath componentsSeparatedByString:@"/"];
    NSString *CmdBtnName=[fakegroupNames objectAtIndex:[fakegroupNames count]-2];
    NSMutableArray *groupNames=[[NSMutableArray alloc] init];
    for (int i=0; i<[fakegroupNames count]-2; i++) {
        [groupNames addObject:[fakegroupNames objectAtIndex:i]];
    }
    [groupNames addObject:@""];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) return cmdBtnInfo;
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
            return cmdBtnInfo;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return cmdBtnInfo;
    }
    NSArray *temp=[tempNode elementsForName:@"Button"];
    GDataXMLElement *cmdBtnElement;
    BOOL flag=false;
    for (cmdBtnElement in temp){
        NSArray *bName=[cmdBtnElement elementsForName:@"CmdBtnName"];
        if ([bName count]>0) {
            GDataXMLElement *BName=(GDataXMLElement *)[bName objectAtIndex:0];
            if ([[BName stringValue] isEqualToString:CmdBtnName]) {
                flag=true;
                break;
            }
        }
    }
    //flag为true是，表示找到了该按钮
    if (flag) {
        NSArray *temp=[cmdBtnElement elementsForName:@"ServerIP"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ServerIP"];
        }
        
        temp=[cmdBtnElement elementsForName:@"ServerPort"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ServerPort"];
        }
        
        temp=[cmdBtnElement elementsForName:@"ImgUrl"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ImgUrl"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Location_x"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_x"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Location_y"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_y"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Width"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Width"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Height"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Height"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Cmd"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Cmd"];
        }
        
        temp=[cmdBtnElement elementsForName:@"CmdBtnName"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"CmdBtnName"];
        }
        
        temp=[cmdBtnElement elementsForName:@"TimeDelay"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"TimeDelay"];
        }
        
        temp = [cmdBtnElement elementsForName:@"LabelWillDisplay"];
        if ([temp count]>0) {
            [cmdBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"LabelWillDisplay"];
        }
    }
    return cmdBtnInfo;
}

+(NSMutableDictionary *)getPopBtnInfo:(NSString *)popBtnPath{
    NSMutableDictionary *cmdPopBtnInfo=[NSMutableDictionary dictionary];
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/按钮3/，注意最后以'/'结尾，并且最后一个是按钮名
    //以下是为了处理掉按钮的名字
    NSArray *fakegroupNames=[popBtnPath componentsSeparatedByString:@"/"];
    NSString *CmdBtnName=[fakegroupNames objectAtIndex:[fakegroupNames count]-2];
    NSMutableArray *groupNames=[[NSMutableArray alloc] init];
    for (int i=0; i<[fakegroupNames count]-2; i++) {
        [groupNames addObject:[fakegroupNames objectAtIndex:i]];
    }
    [groupNames addObject:@""];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) return cmdPopBtnInfo;
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
            return cmdPopBtnInfo;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return cmdPopBtnInfo;
    }
    NSArray *temp=[tempNode elementsForName:@"PopBtn"];
    GDataXMLElement *cmdBtnElement;
    BOOL flag=false;
    for (cmdBtnElement in temp){
        NSArray *bName=[cmdBtnElement elementsForName:@"PopBtnName"];
        if ([bName count]>0) {
            GDataXMLElement *BName=(GDataXMLElement *)[bName objectAtIndex:0];
            if ([[BName stringValue] isEqualToString:CmdBtnName]) {
                flag=true;
                break;
            }
        }
    }
    //flag为true是，表示找到了该按钮
    if (flag) {
        NSArray *temp=[cmdBtnElement elementsForName:@"ImgUrl"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ImgUrl"];
        }
        
        temp=[cmdBtnElement elementsForName:@"PopBtnName"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"PopBtnName"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Location_x"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_x"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Location_y"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_y"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Width"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Width"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Height"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Height"];
        }
        
        temp=[cmdBtnElement elementsForName:@"LabelWillDisplay"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"LabelWillDisplay"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Devices"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Devices"];
        }
        
        temp=[cmdBtnElement elementsForName:@"Cmds"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Cmds"];
        }
        
        temp=[cmdBtnElement elementsForName:@"CmdNames"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"CmdNames"];
        }
        
        temp=[cmdBtnElement elementsForName:@"ServerIP"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ServerIP"];
        }
        
        temp=[cmdBtnElement elementsForName:@"ServerPort"];
        if ([temp count]>0) {
            [cmdPopBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ServerPort"];
        }
    }
    return cmdPopBtnInfo;
}

#pragma mark write operation
//组的写操作，返回是否操作成功
//注意这里的groupInfo中应该多一个GroupPaht,在调用这个函数的时候注意到这一点
+(BOOL)writeGroupInfoToFile:(NSMutableDictionary *)groupInfo{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *xmldata=@"<?xml version=\"1.0\" encoding=\"utf-8\"?><setting></setting>";
        NSData *initData=[xmldata dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
    }
    
    NSData *xmlData=[[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if(doc==nil) return false;
    NSArray *pathNames=[[groupInfo objectForKey:@"GroupPath"] componentsSeparatedByString:@"/"];
    int deep=0;
    int Deep=[pathNames count];
    GDataXMLElement *tempNode=[doc rootElement];
    for (NSString *tempStr in pathNames) {
        if ([tempStr isEqualToString:@""]) {
            Deep--;
            continue;
        }
        BOOL flag=false;
        NSArray *groups=[tempNode elementsForName:@"Group"];
        for (GDataXMLElement *tempElement in groups) {
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
            return false;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return false;
    }
    NSArray *checkGroup=[tempNode elementsForName:@"Group"];
    for (GDataXMLElement *tempElement in checkGroup) {
        NSArray *gName=[tempElement elementsForName:@"GroupName"];
        if ([gName count]>0) {
            GDataXMLElement *GName=(GDataXMLElement *)[gName objectAtIndex:0];
            if ([[GName stringValue] isEqualToString:[groupInfo objectForKey:@"GroupName"]]) {
                NSLog(@"存在相同文件夹，创建失败！");
                return false;
            }
        }
    }
    
    GDataXMLElement *newGroup=[GDataXMLNode elementWithName:@"Group"];
    GDataXMLElement *gName=[GDataXMLNode elementWithName:@"GroupName" stringValue:[groupInfo objectForKey:@"GroupName"]];
    GDataXMLElement *gImgUrl=[GDataXMLNode elementWithName:@"ImgUrl" stringValue:[groupInfo objectForKey:@"ImgUrl"]];
    GDataXMLElement *locationX=[GDataXMLNode elementWithName:@"Location_x" stringValue:[groupInfo objectForKey:@"Location_x"]];
    GDataXMLElement *locationY=[GDataXMLNode elementWithName:@"Location_y" stringValue:[groupInfo objectForKey:@"Location_y"]];
    GDataXMLElement *gwidth=[GDataXMLNode elementWithName:@"Width" stringValue:[groupInfo objectForKey:@"Width"]];
    GDataXMLElement *gheidht=[GDataXMLNode elementWithName:@"Height" stringValue:[groupInfo objectForKey:@"Height"]];
    GDataXMLElement *glabelDisplay = [GDataXMLNode elementWithName:@"LabelWillDisplay" stringValue:[groupInfo objectForKey:@"LabelWillDisplay"]];
    GDataXMLElement *pageBackImgPath = [GDataXMLNode elementWithName:@"PageBackImgPath" stringValue:[groupInfo objectForKey:@"PageBackImgPath"]];
    [newGroup addChild:gName];
    [newGroup addChild:gImgUrl];
    [newGroup addChild:locationX];
    [newGroup addChild:locationY];
    [newGroup addChild:gwidth];
    [newGroup addChild:gheidht];
    [newGroup addChild:glabelDisplay];
    [newGroup addChild:pageBackImgPath];
    
    [tempNode addChild:newGroup];
    NSData *data=doc.XMLData;
    [data writeToFile:filePath atomically:YES];
    NSLog(@"create new group sucessfully");
    return true;
}
//按钮的写操作，返回是否操作成功
//注意这里的cmdBtnInfo中的CmdBtnPath不包含按钮的名字，例如：/组1/。表示这个按钮在组1中；
+(BOOL)writeCmdBtnInfoToFile:(NSMutableDictionary *)cmdBtnInfo{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *xmldata=@"<?xml version=\"1.0\" encoding=\"utf-8\"?><setting></setting>";
        NSData *initData=[xmldata dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
    }
    
    NSData *xmlData=[[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if(doc==nil) return false;
    NSArray *pathNames=[[cmdBtnInfo objectForKey:@"CmdBtnPath"] componentsSeparatedByString:@"/"];
    int deep=0;
    int Deep=[pathNames count];
    GDataXMLElement *tempNode=[doc rootElement];
    for (NSString *tempStr in pathNames) {
        if ([tempStr isEqualToString:@""]) {
            Deep--;
            continue;
        }
        BOOL flag=false;
        NSArray *groups=[tempNode elementsForName:@"Group"];
        for (GDataXMLElement *tempElement in groups) {
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
            return false;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return false;
    }
    //这里没有考虑按钮重名的问题，不允许按钮重名，这里要求用户自觉遵守了，有时间再修改。
    GDataXMLElement *Button=[GDataXMLNode elementWithName:@"Button"];
    GDataXMLElement *IP=[GDataXMLNode elementWithName:@"ServerIP" stringValue:[cmdBtnInfo objectForKey:@"ServerIP"]];
    GDataXMLElement *Port=[GDataXMLNode elementWithName:@"ServerPort" stringValue:[cmdBtnInfo objectForKey:@"ServerPort"]];
    GDataXMLElement *Img=[GDataXMLNode elementWithName:@"ImgUrl" stringValue:[cmdBtnInfo objectForKey:@"ImgUrl"]];
    GDataXMLElement *LocationX=[GDataXMLNode elementWithName:@"Location_x" stringValue:[cmdBtnInfo objectForKey:@"Location_x"]];
    GDataXMLElement *LocationY=[GDataXMLNode elementWithName:@"Location_y" stringValue:[cmdBtnInfo objectForKey:@"Location_y"]];
    GDataXMLElement *bwidth=[GDataXMLNode elementWithName:@"Width" stringValue:[cmdBtnInfo objectForKey:@"Width"]];
    GDataXMLElement *bheidht=[GDataXMLNode elementWithName:@"Height" stringValue:[cmdBtnInfo objectForKey:@"Height"]];
    GDataXMLElement *cmd=[GDataXMLNode elementWithName:@"Cmd" stringValue:[cmdBtnInfo objectForKey:@"Cmd"]];
    GDataXMLElement *descript=[GDataXMLNode elementWithName:@"CmdBtnName" stringValue:[cmdBtnInfo objectForKey:@"CmdBtnName"]];
    GDataXMLElement *delay=[GDataXMLNode elementWithName:@"TimeDelay" stringValue:[cmdBtnInfo objectForKey:@"TimeDelay"]];
    GDataXMLElement *labelDisplay = [GDataXMLNode elementWithName:@"LabelWillDisplay" stringValue:[cmdBtnInfo objectForKey:@"LabelWillDisplay"]];
    [Button addChild:IP];
    [Button addChild:Port];
    [Button addChild:Img];
    [Button addChild:LocationX];
    [Button addChild:LocationY];
    [Button addChild:cmd];
    [Button addChild:bwidth];
    [Button addChild:bheidht];
    [Button addChild:descript];
    [Button addChild:delay];
    [Button addChild:labelDisplay];
    
    [tempNode addChild:Button];
    NSData *data=doc.XMLData;
    [data writeToFile:filePath atomically:YES];
    NSLog(@"create new cmdBtn sucessfully");
    return true;
}
//小窗口按钮的写操作
+(BOOL)writePopBtnInfoToFile:(NSMutableDictionary *)popBtnInfo{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *xmldata=@"<?xml version=\"1.0\" encoding=\"utf-8\"?><setting></setting>";
        NSData *initData=[xmldata dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
    }
    
    NSData *xmlData=[[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if(doc==nil) return false;
    NSArray *pathNames=[[popBtnInfo objectForKey:@"PopBtnPath"] componentsSeparatedByString:@"/"];
    int deep=0;
    int Deep=[pathNames count];
    GDataXMLElement *tempNode=[doc rootElement];
    for (NSString *tempStr in pathNames) {
        if ([tempStr isEqualToString:@""]) {
            Deep--;
            continue;
        }
        BOOL flag=false;
        NSArray *groups=[tempNode elementsForName:@"Group"];
        for (GDataXMLElement *tempElement in groups) {
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
            return false;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return false;
    }
    GDataXMLElement *PopButton=[GDataXMLNode elementWithName:@"PopBtn"];
    GDataXMLElement *PopBtnName=[GDataXMLNode elementWithName:@"PopBtnName" stringValue:[popBtnInfo objectForKey:@"PopBtnName"]];
    GDataXMLElement *ImgUrl=[GDataXMLNode elementWithName:@"ImgUrl" stringValue:[popBtnInfo objectForKey:@"ImgUrl"]];
    GDataXMLElement *LocationX=[GDataXMLNode elementWithName:@"Location_x" stringValue:[popBtnInfo objectForKey:@"Location_x"]];
    GDataXMLElement *LocationY=[GDataXMLNode elementWithName:@"Location_y" stringValue:[popBtnInfo objectForKey:@"Location_y"]];
    GDataXMLElement *bwidth=[GDataXMLNode elementWithName:@"Width" stringValue:[popBtnInfo objectForKey:@"Width"]];
    GDataXMLElement *bheidht=[GDataXMLNode elementWithName:@"Height" stringValue:[popBtnInfo objectForKey:@"Height"]];
    GDataXMLElement *labelDisplay = [GDataXMLNode elementWithName:@"LabelWillDisplay" stringValue:[popBtnInfo objectForKey:@"LabelWillDisplay"]];
    GDataXMLElement *Devices = [GDataXMLNode elementWithName:@"Devices" stringValue:[popBtnInfo objectForKey:@"Devices"]];
    GDataXMLElement *Cmds = [GDataXMLNode elementWithName:@"Cmds" stringValue:[popBtnInfo objectForKey:@"Cmds"]];
    GDataXMLElement *CmdNames = [GDataXMLNode elementWithName:@"CmdNames" stringValue:[popBtnInfo objectForKey:@"CmdNames"]];
    GDataXMLElement *ServerIP = [GDataXMLNode elementWithName:@"ServerIP" stringValue:[popBtnInfo objectForKey:@"ServerIP"]];
    GDataXMLElement *ServerPort = [GDataXMLNode elementWithName:@"ServerPort" stringValue:[popBtnInfo objectForKey:@"ServerPort"]];
    [PopButton addChild:PopBtnName];
    [PopButton addChild:ImgUrl];
    [PopButton addChild:LocationX];
    [PopButton addChild:LocationY];
    [PopButton addChild:bwidth];
    [PopButton addChild:bheidht];
    [PopButton addChild:labelDisplay];
    [PopButton addChild:Devices];
    [PopButton addChild:Cmds];
    [PopButton addChild:CmdNames];
    [PopButton addChild:ServerIP];
    [PopButton addChild:ServerPort];
    [tempNode addChild:PopButton];
    NSData *data=doc.XMLData;
    [data writeToFile:filePath atomically:YES];
    NSLog(@"create new PopcmdBtn sucessfully");
    return true;
}
//添加测试数据
+(void)wirteTestData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *xmldata=@"<?xml version=\"1.0\" encoding=\"utf-8\"?><setting></setting>";
        NSData *initData=[xmldata dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
        [self setPageBackImgPath:@"/" PageBackImgPath:@"GOMON.jpg"];
        NSMutableDictionary *md=[NSMutableDictionary dictionary];
        [md setObject:@"/" forKey:@"GroupPath"];
        [md setObject:@"G1" forKey:@"GroupName"];
        [md setObject:@"1.png" forKey:@"ImgUrl"];
        [md setObject:@"200" forKey:@"Location_x"];
        [md setObject:@"100" forKey:@"Location_y"];
        [md setObject:@"111" forKey:@"Width"];
        [md setObject:@"53" forKey:@"Height"];
        [md setObject:@"YES" forKey:@"LabelWillDisplay"];
        [md setObject:@"GOMON.jpg" forKey:@"PageBackImgPath"];
        [self writeGroupInfoToFile:md];
        [md removeAllObjects];
        
        
        [md setObject:@"/G1/" forKey:@"GroupPath"];
        [md setObject:@"G11" forKey:@"GroupName"];
        [md setObject:@"1.png" forKey:@"ImgUrl"];
        [md setObject:@"200" forKey:@"Location_x"];
        [md setObject:@"300" forKey:@"Location_y"];
        [md setObject:@"111" forKey:@"Width"];
        [md setObject:@"53" forKey:@"Height"];
        [md setObject:@"YES" forKey:@"LabelWillDisplay"];
        [md setObject:@"GOMON.jpg" forKey:@"PageBackImgPath"];
        [self writeGroupInfoToFile:md];
        [md removeAllObjects];

        [md setObject:@"/" forKey:@"CmdBtnPath"];
        [md setObject:@"192.168.43.100" forKey:@"ServerIP"];
        [md setObject:@"8600" forKey:@"ServerPort"];
        [md setObject:@"1.png" forKey:@"ImgUrl"];
        [md setObject:@"200" forKey:@"Location_x"];
        [md setObject:@"400" forKey:@"Location_y"];
        [md setObject:@"87" forKey:@"Width"];
        [md setObject:@"69" forKey:@"Height"];
        [md setObject:@"Open all the computer" forKey:@"Cmd"];
        [md setObject:@"Computer" forKey:@"CmdBtnName"];
        [md setObject:@"3" forKey:@"TimeDelay"];
        [md setObject:@"YES" forKey:@"LabelWillDisplay"];
        [self writeCmdBtnInfoToFile:md];
        [md removeAllObjects];
        
        [md setObject:@"/" forKey:@"CmdBtnPath"];
        [md setObject:@"192.168.43.100" forKey:@"ServerIP"];
        [md setObject:@"8600" forKey:@"ServerPort"];
        [md setObject:@"1.png" forKey:@"ImgUrl"];
        [md setObject:@"200" forKey:@"Location_x"];
        [md setObject:@"1000" forKey:@"Location_y"];
        [md setObject:@"87" forKey:@"Width"];
        [md setObject:@"69" forKey:@"Height"];
        [md setObject:@"Open all the computer" forKey:@"Cmd"];
        [md setObject:@"Computer1" forKey:@"CmdBtnName"];
        [md setObject:@"3" forKey:@"TimeDelay"];
        [md setObject:@"YES" forKey:@"LabelWillDisplay"];
        [md setObject:@"GOMON.jpg" forKey:@"PageBackImgPath"];
        [self writeCmdBtnInfoToFile:md];
        [md removeAllObjects];
        
        [md setObject:@"/G1/" forKey:@"CmdBtnPath"];
        [md setObject:@"192.168.43.100" forKey:@"ServerIP"];
        [md setObject:@"8600" forKey:@"ServerPort"];
        [md setObject:@"1.png" forKey:@"ImgUrl"];
        [md setObject:@"300" forKey:@"Location_x"];
        [md setObject:@"400" forKey:@"Location_y"];
        [md setObject:@"87" forKey:@"Width"];
        [md setObject:@"69" forKey:@"Height"];
        [md setObject:@"Open all the computer" forKey:@"Cmd"];
        [md setObject:@"Computer4" forKey:@"CmdBtnName"];
        [md setObject:@"3" forKey:@"TimeDelay"];
        [md setObject:@"YES" forKey:@"LabelWillDisplay"];
        [md setObject:@"GOMON.jpg" forKey:@"PageBackImgPath"];
        [self writeCmdBtnInfoToFile:md];
        [md removeAllObjects];
        
        [md setObject:@"/" forKey:@"PopBtnPath"];
        [md setObject:@"?" forKey:@"PopBtnName"];
        [md setObject:@"1.png" forKey:@"ImgUrl"];
        [md setObject:@"300" forKey:@"Location_x"];
        [md setObject:@"300" forKey:@"Location_y"];
        [md setObject:@"111" forKey:@"Width"];
        [md setObject:@"53" forKey:@"Height"];
        [md setObject:@"YES" forKey:@"LabelWillDisplay"];
        [md setObject:@"c1^c2^c3" forKey:@"Devices"];
        [md setObject:@"a1|a2^b^c" forKey:@"Cmds"];
        [md setObject:@"n1^n2^n3^n4" forKey:@"CmdNames"];
        [md setObject:@"192.168.43.100" forKey:@"ServerIP"];
        [md setObject:@"8600" forKey:@"ServerPort"];
        [self writePopBtnInfoToFile:md];
        [md removeAllObjects];        
        
    }
}
#pragma mark delete operation
+(BOOL)deleteGroupByPath:(NSString *)groupPath{
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/组3/，注意最后以'/'结尾
    NSArray *groupNames=[groupPath componentsSeparatedByString:@"/"];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        return false;
    }
    NSData *xmlData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    //用于检测根路径的情况
    int deep=0;
    int Deep=[Names count];
    GDataXMLElement *tempNode=[doc rootElement];
    GDataXMLElement *tempChildNode;
    for (NSString *tempStr in Names) {
        if ([tempStr isEqualToString:@""]) {
            Deep--;
            continue;
        }
        BOOL flag=false;
        NSArray *groups2=[tempNode elementsForName:@"Group"];
        for (tempChildNode in groups2) {
            NSArray *gName=[tempChildNode elementsForName:@"GroupName"];
            if ([gName count]>0) {
                GDataXMLElement *GName=(GDataXMLElement *)[gName objectAtIndex:0];
                if ([[GName stringValue] isEqualToString:tempStr]) {
                    deep++;
                    flag=true;
                    tempNode=tempChildNode;
                    break;
                }
            }
        }
        if(!flag){
            NSLog(@"找不到路径!\n");
            return false;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return false;
    }
    [tempNode removeChild:tempChildNode];
    xmlData=doc.XMLData;
    [xmlData writeToFile:filePath atomically:YES];
    NSLog(@"%@删除成功\n",[Names objectAtIndex:[Names count]-1]);
    return true;
}
+(BOOL)deleteCmdBtnByPath:(NSString *)cmdBtnPath{
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/按钮3/，注意最后以'/'结尾，并且最后一个是按钮名
    //以下是为了处理掉按钮的名字
    NSArray *fakegroupNames=[cmdBtnPath componentsSeparatedByString:@"/"];
    NSString *CmdBtnName=[fakegroupNames objectAtIndex:[fakegroupNames count]-2];
    NSMutableArray *groupNames=[[NSMutableArray alloc] init];
    for (int i=0; i<[fakegroupNames count]-2; i++) {
        [groupNames addObject:[fakegroupNames objectAtIndex:i]];
    }
    [groupNames addObject:@""];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) return false;
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
            return false;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return false;
    }
    NSArray *temp=[tempNode elementsForName:@"Button"];
    GDataXMLElement *tempChildNode;
    BOOL flag=false;
    for (tempChildNode in temp){
        NSArray *bName=[tempChildNode elementsForName:@"CmdBtnName"];
        if ([bName count]>0) {
            GDataXMLElement *BName=(GDataXMLElement *)[bName objectAtIndex:0];
            if ([[BName stringValue] isEqualToString:CmdBtnName]) {
                flag=true;
                break;
            }
        }
    }
    //flag为true是，表示找到了该按钮
    if (flag) {
        [tempNode removeChild:tempChildNode];
        xmlData=doc.XMLData;
        [xmlData writeToFile:filePath atomically:YES];
        NSLog(@"%@删除成功\n",[Names objectAtIndex:[Names count]-1]);
        return true;
    }
    return false;
}
//根据路径，获取该路径下所有的组信息
+(NSMutableArray *)getGroupInfoByPath:(NSString *)curPath{
    NSMutableArray *infoSet=[[NSMutableArray alloc] init];
    
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/组3/，注意最后以'/'结尾
    NSArray *groupNames=[curPath componentsSeparatedByString:@"/"];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return infoSet;
    }
    NSData *xmlData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    //用于检测根路径的情况
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
            return infoSet;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return infoSet;
    }
    NSArray *groups=[tempNode elementsForName:@"Group"];
    for (GDataXMLElement *group in groups) {
        //将singleGroupInfo放在循环中，是因为防止数据覆盖。如果放在循环外，则所有数据是一样的。
        NSMutableDictionary *singleGroupInfo=[NSMutableDictionary dictionary];
        NSArray *temp=[group elementsForName:@"GroupName"];
        if ([temp count]>0) {
            [singleGroupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"GroupName"];
        }
        else continue;
        temp=[group elementsForName:@"ImgUrl"];
        if ([temp count]>0) {
            [singleGroupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ImgUrl"];
        }
        else continue;
        temp=[group elementsForName:@"Location_x"];
        if ([temp count]>0) {
            [singleGroupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_x"];
        }
        else continue;
        temp=[group elementsForName:@"Location_y"];
        if ([temp count]>0) {
            [singleGroupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_y"];
        }
        else continue;
        temp=[group elementsForName:@"Width"];
        if ([temp count]>0) {
            [singleGroupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Width"];
        }
        else continue;
        temp=[group elementsForName:@"Height"];
        if ([temp count]>0) {
            [singleGroupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Height"];
        }
        else continue;
        
        temp=[group elementsForName:@"LabelWillDisplay"];
        if ([temp count]>0) {
            [singleGroupInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"LabelWillDisplay"];
        }
        else continue;
        
        [infoSet addObject:singleGroupInfo];
        //[singleGroupInfo removeAllObjects];
    }

    return infoSet;
}
//根据路径，获取该路径下所有命令按钮的信息
+(NSMutableArray *)getCmdBtnInfoByPath:(NSString *)curPath{
    NSMutableArray *infoSet=[[NSMutableArray alloc] init];
    
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/组3/，注意最后以'/'结尾
    NSArray *groupNames=[curPath componentsSeparatedByString:@"/"];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return infoSet;
    }
    NSData *xmlData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    //用于检测根路径的情况
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
            return infoSet;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return infoSet;
    }
    NSArray *cmdBtns=[tempNode elementsForName:@"Button"];
    for (GDataXMLElement *cmdBtn in cmdBtns) {
        //将singleGroupInfo放在循环中，是因为防止数据覆盖。如果放在循环外，则所有数据是一样的。
        NSMutableDictionary *singleBtnInfo=[NSMutableDictionary dictionary];
        NSArray *temp=[cmdBtn elementsForName:@"ServerIP"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ServerIP"];
        }
        else continue;
        temp=[cmdBtn elementsForName:@"ServerPort"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ServerPort"];
        }
        else continue;
        temp=[cmdBtn elementsForName:@"Location_x"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_x"];
        }
        else continue;
        temp=[cmdBtn elementsForName:@"Location_y"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_y"];
        }
        else continue;
        temp=[cmdBtn elementsForName:@"Width"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Width"];
        }
        else continue;
        temp=[cmdBtn elementsForName:@"Height"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Height"];
        }
        else continue;
        
        temp=[cmdBtn elementsForName:@"Cmd"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Cmd"];
        }
        else continue;
        
        temp=[cmdBtn elementsForName:@"CmdBtnName"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"CmdBtnName"];
        }
        else continue;
        
        temp=[cmdBtn elementsForName:@"TimeDelay"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"TimeDelay"];
        }
        else continue;
        
        temp=[cmdBtn elementsForName:@"LabelWillDisplay"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"LabelWillDisplay"];
        }
        
        [infoSet addObject:singleBtnInfo];
        //[singleGroupInfo removeAllObjects];
    }
    
    return infoSet;

}
//根据路径，获取该路径下所有弹出按钮的信息
+(NSMutableArray *)getPopBtnInfoByPath:(NSString *)curPath{
    NSMutableArray *infoSet=[[NSMutableArray alloc] init];
    
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/组3/，注意最后以'/'结尾
    NSArray *groupNames=[curPath componentsSeparatedByString:@"/"];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return infoSet;
    }
    NSData *xmlData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    //用于检测根路径的情况
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
            return infoSet;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return infoSet;
    }
    NSArray *popBtns=[tempNode elementsForName:@"PopBtn"];
    for (GDataXMLElement *popBtn in popBtns) {
        //将singleGroupInfo放在循环中，是因为防止数据覆盖。如果放在循环外，则所有数据是一样的。
        NSMutableDictionary *singleBtnInfo=[NSMutableDictionary dictionary];
        NSArray *temp=[popBtn elementsForName:@"PopBtnName"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"PopBtnName"];
        }
        else continue;
        temp=[popBtn elementsForName:@"ImgUrl"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ImgUrl"];
        }
        else continue;
        temp=[popBtn elementsForName:@"Location_x"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_x"];
        }
        else continue;
        temp=[popBtn elementsForName:@"Location_y"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Location_y"];
        }
        else continue;
        temp=[popBtn elementsForName:@"Width"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Width"];
        }
        else continue;
        temp=[popBtn elementsForName:@"Height"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Height"];
        }
        else continue;
        
        temp=[popBtn elementsForName:@"Cmds"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Cmds"];
        }
        else continue;
        
        temp=[popBtn elementsForName:@"LabelWillDisplay"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"LabelWillDisplay"];
        }
        else continue;
        
        temp=[popBtn elementsForName:@"Devices"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"Devices"];
        }
        else continue;
        
        temp=[popBtn elementsForName:@"CmdNames"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"CmdNames"];
        }
        else continue;
        
        temp=[popBtn elementsForName:@"ServerIP"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ServerIP"];
        }
        else continue;
        
        temp=[popBtn elementsForName:@"ServerPort"];
        if ([temp count]>0) {
            [singleBtnInfo setObject:[(GDataXMLElement *)[temp objectAtIndex:0] stringValue] forKey:@"ServerPort"];
        }
        else continue;
        
        [infoSet addObject:singleBtnInfo];
        //[singleGroupInfo removeAllObjects];
    }
    
    return infoSet;
}
//根据路径，获取该路径下页面的背景图片路径
+(NSString *)getPageBackImgPath:(NSString *)curPath{
    NSString *pageBackImgPath=nil;
    
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/组3/，注意最后以'/'结尾
    NSArray *groupNames=[curPath componentsSeparatedByString:@"/"];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return pageBackImgPath;
    }
    NSData *xmlData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    //用于检测根路径的情况
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
            return pageBackImgPath;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return pageBackImgPath;
    }
    NSArray *temp=[tempNode elementsForName:@"PageBackImgPath"];
    if ([temp count]>0) {
        pageBackImgPath=[(GDataXMLElement *)[temp objectAtIndex:0] stringValue];
    }
    return pageBackImgPath;
}
//根据路径，设置该路径下页面的背景图片路径
+(BOOL)setPageBackImgPath:(NSString *)curPath PageBackImgPath:(NSString *)pageBackImgPath{
    //filePath为配置文件的路径，其放在程序中默认的某个位置
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    //处理路径，路径按照每个文件名+‘/’相连,例如：/组1/组2/组3/，注意最后以'/'结尾
    NSArray *groupNames=[curPath componentsSeparatedByString:@"/"];
    NSMutableArray *Names=[[NSMutableArray alloc] init];
    for (NSString *temp in groupNames) {
        if (![temp isEqualToString:@""]) {
            [Names addObject:temp];
        }
    }
    //不存在配置文件，则返回空
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return false;
    }
    NSData *xmlData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    //用于检测根路径的情况
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
            return false;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return false;
    }
    NSArray *temp=[tempNode elementsForName:@"PageBackImgPath"];
    if ([temp count]>0) {
        [(GDataXMLElement *)[temp objectAtIndex:0] setStringValue:pageBackImgPath];
    }
    else{
        GDataXMLElement *tmp=[GDataXMLNode elementWithName:@"PageBackImgPath" stringValue:pageBackImgPath];
        [tempNode addChild:tmp];
    }
    NSData *tmpxmlData=doc.XMLData;
    [tmpxmlData writeToFile:filePath atomically:YES];
    NSLog(@"%@页面背景更新成功\n",curPath);
    return true;
}
@end
