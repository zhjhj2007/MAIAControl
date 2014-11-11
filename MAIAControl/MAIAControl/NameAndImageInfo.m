//
//  NameAndImageInfo.m
//  IpadCenterControl
//
//  Created by mac on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NameAndImageInfo.h"

@implementation NameAndImageInfo
@synthesize name=_name;
@synthesize imgURL=_imgURL;
@synthesize type=_type;

-(id) init:(NSString *)nameValue ImgURL:(NSString *)imgURLVale ButtonTypeValue:(ButtonType)buttonTypeValue{
    if((self=[super init])){
        _name=nameValue;
        _imgURL=imgURLVale;
        _type=buttonTypeValue;
    }
    return self;
}
@end
