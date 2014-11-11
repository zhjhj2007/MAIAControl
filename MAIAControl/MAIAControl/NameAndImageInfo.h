//
//  NameAndImageInfo.h
//  IpadCenterControl
//
//  Created by mac on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    NSGroupType,
    NSButtonType,
    NSPopBtnType
}ButtonType;
@interface NameAndImageInfo : NSObject
@property (copy, nonatomic) NSString *name,*imgURL;
@property ButtonType type;
-(id) init:(NSString *)nameValue ImgURL:(NSString *)imgURLVale ButtonTypeValue:(ButtonType)buttonTypeValue;
@end
