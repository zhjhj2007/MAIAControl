//
//  NameAndImageInfo.h
//  IpadCenterControl
//
//  Created by mac on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameAndImageInfo : NSObject
{
    NSString *name;
    NSString *ImgURL;
    bool isButton;
}
@property (copy, nonatomic) NSString *name,*ImgURL;
@property bool isButton;
-(id) init:(NSString *)nameValue ImgURL:(NSString *)ImgURLVale isButton:(bool)isButtonValue;
@end
