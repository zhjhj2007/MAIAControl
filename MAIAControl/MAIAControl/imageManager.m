//
//  imageManager.m
//  IpadCenterControl
//
//  Created by mac on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "imageManager.h"

@implementation imageManager
+(void) saveBackGroundImg:(UIImage *)image{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"/backimg.jpg"];
    //删除原来的图片
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSLog(@"%@已经删除\n",filePath);
    }
    NSData *initData=UIImageJPEGRepresentation(image, 1.0);
    [initData writeToFile:filePath atomically:YES];
}
+(UIImage *) getBackGroundImg{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"/backimg.jpg"];
    UIImage *img=[UIImage imageWithContentsOfFile:filePath];
    return img;
}
+ (NSString *)writeImage:(UIImage*)image OldImgName:(NSString *)OldImgName
{
    //删除原来的图片
    @try {
        [[NSFileManager defaultManager] removeItemAtPath:OldImgName error:nil];
        NSLog(@"%@已经删除\n",OldImgName);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"count.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *count=@"1";
        NSData *initData=[count dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
    }
    NSData *data=[[NSData alloc] initWithContentsOfFile:filePath];
    NSString *countName=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    int temp=[countName intValue];
    temp++;
    NSString *tempStr=[[NSString alloc] initWithFormat:@"%d",temp];
    data=[tempStr dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:YES];
    countName=[countName stringByAppendingFormat:@".png"];
    //NSLog(@"测试图片：%@\n",countName);
    NSString *ImgName=countName;

    countName=[documentsPath stringByAppendingFormat:@"/%@",countName];
    //NSLog(@"测试图片：%@\n",documentsPath);
    if ((image == nil) || (countName == nil) || ([countName isEqualToString:@""]))
        return @"";
    
    @try
    {
        NSData *imageData = nil;
        NSString *ext = [countName pathExtension];
        if ([ext isEqualToString:@"png"])
            
        {
            imageData = UIImagePNGRepresentation(image);
            
            
        }
        else
            
        {
            // the rest, we write to jpeg
            // 0. best, 1. lost. about compress.
            imageData = UIImageJPEGRepresentation(image,0);    
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            return @"";
        
        [imageData writeToFile:countName atomically:YES];      
        NSLog(@"保存图片：%@\n",ImgName);
        return ImgName;
    }
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    
    return @"";
}
+(int) helpFlag{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"help.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *count=@"0";
        NSData *initData=[count dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
    }
    NSData *data=[[NSData alloc] initWithContentsOfFile:filePath];
    NSString *countName=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    int temp=[countName intValue];
    if (temp==1) {
        temp=0;
    }
    else
        temp=1;
    NSString *tempStr=[[NSString alloc] initWithFormat:@"%d",temp];
    data=[tempStr dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:YES];
    
    return [countName intValue];
    
}
+(int) getHelpFlag{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath=[paths objectAtIndex:0];
    NSString *filePath=[documentsPath stringByAppendingPathComponent:@"help.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *count=@"0";
        NSData *initData=[count dataUsingEncoding:NSUTF8StringEncoding];
        [initData writeToFile:filePath atomically:YES];
    }
    NSData *data=[[NSData alloc] initWithContentsOfFile:filePath];
    NSString *countName=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    int temp=[countName intValue];
    return temp;
}
@end
