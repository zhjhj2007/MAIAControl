//
//  GroupClass.h
//  MAIAControl
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//  1.对外提供生成组类别的视图控件并返回；
//

#import <Foundation/Foundation.h>
#import "XMLManipulate.h"

@interface GroupClass : NSObject
//groupPath：组在XML树中的位置，用于寻找组的配置信息
@property(nonatomic, retain) NSMutableDictionary *groupInfo;
@property(nonatomic, copy) NSString *groupPath;
//初始化函数，根据groupInfo初始化
-(id)init:(NSString *)groupPath;
//获取组的视图，包括一个UIButton和一个UILabel
-(id)getGroupView;
@end
