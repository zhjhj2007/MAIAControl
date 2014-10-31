//
//  GroupClass.h
//  MAIAControl
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//  1.对外提供生成组类别的视图控件并返回；
//

#import <Foundation/Foundation.h>

@interface GroupClass : NSObject
//groupPath：组在XML书中的位置，用于寻找组的配置信息
@property(nonatomic, copy) NSString *groupPath;
//获取组的视图，包括一个UIButton和一个UILabel
-(UIView *)getGroupView:(NSString *)_groupPath;
@end
