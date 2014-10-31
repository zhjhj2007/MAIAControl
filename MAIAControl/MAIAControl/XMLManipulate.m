//
//  XMLManipulate.m
//  MAIAControl
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "XMLManipulate.h"

@implementation XMLManipulate

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
    [newGroup addChild:gName];
    [newGroup addChild:gImgUrl];
    [newGroup addChild:locationX];
    [newGroup addChild:locationY];
    [newGroup addChild:gwidth];
    [newGroup addChild:gheidht];
    [newGroup addChild:glabelDisplay];
    
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
//添加测试数据
+(void)wirteTestData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"setting.xml"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *xmldata=@"<?xml version=\"1.0\" encoding=\"utf-8\"?><setting></setting>";
        NSData *initData=[xmldata dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
        NSMutableDictionary *md=[NSMutableDictionary dictionary];
        [md setObject:@"/" forKey:@"GroupPath"];
        [md setObject:@"G1" forKey:@"GroupName"];
        [md setObject:@"1.png" forKey:@"ImgUrl"];
        [md setObject:@"100" forKey:@"Location_x"];
        [md setObject:@"20" forKey:@"Location_y"];
        [md setObject:@"64" forKey:@"Width"];
        [md setObject:@"64" forKey:@"Height"];
        [md setObject:@"YES" forKey:@"LabelWillDisplay"];
        [self writeGroupInfoToFile:md];
        [md removeAllObjects];
        [md setObject:@"/" forKey:@"CmdBtnPath"];
        [md setObject:@"10.0.0.120" forKey:@"ServerIP"];
        [md setObject:@"5000" forKey:@"ServerPort"];
        [md setObject:@"1.png" forKey:@"ImgUrl"];
        [md setObject:@"180" forKey:@"Location_x"];
        [md setObject:@"20" forKey:@"Location_y"];
        [md setObject:@"64" forKey:@"Width"];
        [md setObject:@"64" forKey:@"Height"];
        [md setObject:@"Open all the computer" forKey:@"Cmd"];
        [md setObject:@"Computer" forKey:@"CmdBtnName"];
        [md setObject:@"3" forKey:@"TimeDelay"];
        [md setObject:@"YES" forKey:@"LabelWillDisplay"];
        [self writeCmdBtnInfoToFile:md];
        [md removeAllObjects];
    }
}
//根据组的地址，获取该组的XML元素
+(GDataXMLElement *)getGroupElement:(NSString *)groupPath{
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
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) return nil;
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
            return nil;
        }
    }
    if (deep!=Deep) {
        NSLog(@"找不到路径!\n");
        return nil;
    }
    return tempNode;
}
@end
