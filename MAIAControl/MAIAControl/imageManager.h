//
//  imageManager.h
//  IpadCenterControl
//
//  Created by mac on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageManager : NSObject

+ (NSString *)writeImage:(UIImage*)image OldImgName:(NSString *)OldImgName;
+ (void) saveBackGroundImg:(UIImage*)image;
+ (UIImage *) getBackGroundImg;
+ (int) helpFlag;
+(int) getHelpFlag;

//保存选中的图片到程序的文件夹中
+(BOOL)saveImgToFileSystem:(UIImage *)image ImageName:(NSString *)imageName OldImgPath:(NSString *)oldImgPath;
@end
