//
//  GroupClass.m
//  MAIAControl
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 MAIA. All rights reserved.
//  

#import "GroupClass.h"

@implementation GroupClass
@synthesize groupInfo;
@synthesize groupPath;
-(id)init:(NSString *)_groupPath{
    if (self=[super init]) {
        self.groupInfo=[XMLManipulate getGroupInfo:_groupPath];
        self.groupPath=_groupPath;
    }
    return self;
}
-(id)getGroupView{
   /* UIView *groupView=[[UIView alloc] init];
    [groupView setBackgroundColor:[UIColor blueColor]];
   // groupView.userInteractionEnabled=true;
    UIButton *newButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 111, 53)];
    [newButton setBackgroundImage:[UIImage imageNamed:@"iDisk.png"] forState:UIControlStateNormal];
    newButton.showsTouchWhenHighlighted=true;
    SEL sel=@selector(jump);
    if ([self respondsToSelector:sel]) {
        [newButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    [groupView addSubview:newButton];
    
    UILabel *newLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 53, 111, 40)];
    [newLabel setNumberOfLines:0];
    [newLabel setBackgroundColor:[UIColor clearColor]];
    newLabel.text=[groupInfo objectForKey:@"GroupName"];
    newLabel.textAlignment=NSTextAlignmentCenter;
    [groupView addSubview:newLabel];*/
    UIButton *newButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 111, 53)];
    [newButton setBackgroundImage:[UIImage imageNamed:@"iDisk.png"] forState:UIControlStateNormal];
    newButton.showsTouchWhenHighlighted=true;
    [newButton addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];


    return newButton;
}
-(void)jump:(id)sender{
    NSLog(@"You Clicked the Button!");
}
@end
