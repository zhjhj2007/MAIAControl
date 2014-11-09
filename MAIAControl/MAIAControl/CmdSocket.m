//
//  CmdSocket.m
//  MAIAControl
//
//  Created by Mac on 14-11-2.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//

#import "CmdSocket.h"

@implementation CmdSocket
@synthesize udpclient;
@synthesize state;

//保存所有者的信息
-(id)initWithButtonName:(NSString *)btnName{
    if (self = [super init]) {
        self.btnName = btnName;
    }
    return self;
}
//按钮命令发送
-(void)sendCmd:(NSString *)ServerIP ServerPort:(NSString *)ServerPort CmdText:(NSString *)cmdText{
    NSData *data = [cmdText dataUsingEncoding:NSUnicodeStringEncoding];
    if (udpclient == nil) {
        udpclient=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *error;
        if (![udpclient bindToPort:0 error:&error]) {
            NSLog(@"绑定接口出错!");
            return;
        }
        if (![udpclient beginReceiving:&error]) {
            NSLog(@"开始接收出错！\n");
        }
        NSLog(@"socket is ready");
    }
    [udpclient sendData:data toHost:ServerIP port:[ServerPort intValue] withTimeout:-1 tag:1];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	// You could add checks here
    NSLog(@"msg has sent!");
    [self setState:1];
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	// You could add checks here
    NSLog(@"msg sends failed");
    [self setState:3];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address withFilterContext:(id)filterContext{
	NSString *msgs = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"RECV: %@", msgs);
    NSArray *replyInfo = [msgs componentsSeparatedByString:@"^"];
    NSString *msg = [replyInfo objectAtIndex:0];
    
    if([msg isEqualToString:@"exception"])//其他
        [self setState:1];
	else if ([msg isEqualToString:@"normal"])//正常
        [self setState:2];
    else if([msg isEqualToString:@"wrong"])//故障
        [self setState:3];
    else if([msg isEqualToString:@"link"])//连接加载
        [self setState:4];
    NSString *notificationInfo=@"";
    if ([replyInfo count] ==2) {
        notificationInfo=[replyInfo objectAtIndex:1];
    }

    NSDictionary *stateInfo=[NSDictionary dictionaryWithObjectsAndKeys:self.btnName, @"CmdBtnName",[NSString stringWithFormat:@"%d",self.state],@"CmdBtnState",notificationInfo,@"NotificationInfo",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBtnStatus" object:nil userInfo:stateInfo];
}

@end
