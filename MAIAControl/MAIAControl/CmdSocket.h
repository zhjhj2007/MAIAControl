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
-(void)sendCmd:(NSString *)ServerIP ServerPort:(NSString *)ServerPort CmdText:(NSString *)cmdText;
@end
