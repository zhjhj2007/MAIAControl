//
//  XMLManipulate.h
//  MAIAControl
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//  为组和按钮提供读、写、修改操作

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface XMLManipulate : NSObject
//读操作
+(NSMutableDictionary *)getGroupInfo:(NSString *)groupPath;
+(NSMutableDictionary *)getCmdBtnInfo:(NSString *)cmdBtnPath;
//写操作
+(BOOL)writeGroupInfoToFile:(NSMutableDictionary *)groupInfo;
+(BOOL)writeCmdBtnInfoToFile:(NSMutableDictionary *)cmdBtnInfo;
//修改操作
//首次加载添加测试数据
+(void)wirteTestData;
//根据组的地址，获取该组的XML元素
+(GDataXMLElement *)getGroupElement:(NSString *)groupPath;
@end
