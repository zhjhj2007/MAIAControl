//
//  CmdSocket.h
//  MAIAControl
//
//  Created by Mac on 14-11-2.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
@interface CmdSocket : NSObject<GCDAsyncUdpSocketDelegate>
@property (strong,nonatomic) GCDAsyncUdpSocket *udpclient;
@property int state;
@property (nonatomic,copy) NSString *btnName;
//向服务器发送命令
-(void)sendCmd:(NSString *)ServerIP ServerPort:(NSString *)ServerPort CmdText:(NSString *)cmdText;
//初始化本类的所有者信息
-(id)initWithButtonName:(NSString *)btnName;
@end
