//
//  NameAndImageInfo.m
//  IpadCenterControl
//
//  Created by mac on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NameAndImageInfo.h"

@implementation NameAndImageInfo
@synthesize name,ImgURL,isButton;

-(id) init:(NSString *)nameValue ImgURL:(NSString *)ImgURLVale isButton:(bool)isButtonValue
{
    if((self=[super init])){
        self.ImgURL=ImgURLVale;
        self.name = nameValue;
        self.isButton = isButtonValue;
    }
    return self;
}
@end
