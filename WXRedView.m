//
//  WXRedView.m
//  WXReactiveCocoaDemo
//
//  Created by WX on 2017/3/14.
//  Copyright © 2017年 WXmozhuxuanke. All rights reserved.
//

#import "WXRedView.h"

@implementation WXRedView
SINGLE_M(WXRedView)
static id instance;
//// 1. 解决.h文件
//#define singletonInterface(className)          + (instancetype)shared##className;
//
//// 2. 解决.m文件
//// 判断 是否是 ARC
//#if __has_feature(objc_arc)
//#define singletonImplementation(className) \
//static id instance; \
//+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
//static dispatch_once_t onceToken; \
//dispatch_once(&onceToken, ^{ \
//instance = [super allocWithZone:zone]; \
//}); \
//return instance; \
//} \

//+ (instancetype)shared##className { \
//    static dispatch_once_t onceToken; \
//    dispatch_once(&onceToken, ^{ \
//        instance = [[self alloc] init]; \
//    }); \
//    return instance; \
//} \
//- (id)copyWithZone:(NSZone *)zone { \
//    return instance; \
//}
//#else
//// MRC 部分
//#define singletonImplementation(className) \
//static id instance; \
//+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
//static dispatch_once_t onceToken; \
//dispatch_once(&onceToken, ^{ \
//instance = [super allocWithZone:zone]; \
//}); \
//return instance; \
//} \
//+ (instancetype)shared##className { \
//static dispatch_once_t onceToken; \
//dispatch_once(&onceToken, ^{ \
//instance = [[self alloc] init]; \
//}); \
//return instance; \
//} \
//- (id)copyWithZone:(NSZone *)zone { \
//return instance; \
//} \
//- (oneway void)release {} \
//- (instancetype)retain {return instance;} \
//- (instancetype)autorelease {return instance;} \
//- (NSUInteger)retainCount {return ULONG_MAX;}
//
//#endif

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self loadView];
    return self;
}
-(void)loadView{
    self.backgroundColor=[UIColor redColor];
    self.btn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame=CGRectMake(30, 100, 100, 40);
    [self.btn setTitle:@"你好" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btn.backgroundColor=[UIColor yellowColor];
    self.btn.tag=120;
    [self.btn addTarget:self action:@selector(goB) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn];
    
    [[self rac_signalForSelector:@selector(goB)] subscribeNext:^(id x) {
        NSLog(@"红色按钮被点击了");
    }];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(200, 100, 100, 40)];
    label.text=@"轻轻的,你走了";
    label.backgroundColor=[UIColor blueColor];
    label.textColor=[UIColor greenColor];
    label.userInteractionEnabled=YES;
    [self addSubview:label];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]init];
    
    [[tap rac_gestureSignal ]subscribeNext:^(id x) {
        NSLog(@"点击了我刚刚创建的 label 厉害吧");
    }];
    [label addGestureRecognizer:tap];

}
-(void)goB{
    
    
}
@end
