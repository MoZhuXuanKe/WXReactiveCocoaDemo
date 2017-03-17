//
//  WXSingleShared.h
//  WXReactiveCocoaDemo
//
//  Created by WX on 2017/3/14.
//  Copyright © 2017年 WXmozhuxuanke. All rights reserved.
//

#ifndef WXSingleShared_h
#define WXSingleShared_h

//每天写一遍,这是第一遍
//.h 中写的部分
#define WX_SINGLESHARE_H(className)             +(instancetype)shared##className;

//.m
//判断是不是ARC
#if __has_feature(objc_arc)
#define WX_SINGLESHARE_M(className) \
 static id instance; \
+(instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken,^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
+(instancetype)shared##className { \
static dispatch_once_t onceToken ; \
dispatch_once(&onceToken,^ { \
instance =[[self alloc] init]; \
}); \
return instance; \
} \
-(id)copyWithZone:(NSZone* )zone { \
return instance; \
}
#else
//mrc部分
#define WX_SINGLESHARE_M(className) \
static id instance; \
+(instancetype)allocWithZone:(struct _NSZone * )zone { \
static dispatch_once_t  onceToken ; \
dispatch_once(&onceToken ,^ { \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
+(instancetype)shared##className{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken,^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
} \
-(id)copyWithZone:(NSZone*)zone{ \
return instance; \
} \
-(oneway void)release {} \
-(instancetype)retain {return instance;}\
-(instancetype)autorelease {return instance;}\
-(NSUInteger)retainCount {return ULONG_MAX;}
#endif

//每天写一遍,这是第二遍
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

//每天写一遍,这是第三遍

//.h中写的部分
#define Single_H(className)                     +(instancetype)shared##className;


//.m中写的部分

#if __has_feature(objc_arc)
#define Single_M(className)\
static id instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
instance=[super allocWithZone:zone];\
});\
return instance;\
}\
+(instancetype)shared##className{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
instance =[[self alloc]init];\
});\
return instance;\
}\
-(id)copyWithZone:(NSZone*)zone{\
return instance;\
}
#else
#define Single_M(className)\
static id instance;\
+(instancetype)allocWithZone:(struct _NSZone*)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
instance=[super allocWithZone:zone];\
});\
return instance;\
}\
+(instancetype)shared##className{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
instance=[[self alloc ]init];\
});\
return instance;\
}\
-(id)copyWithZone:(NSZone*)zone{\
return instance;\
}\
-(oneway void)release{}\
-(instancetype)retain {return instance;}\
-(instancetype)autorelease {return instance;}\
-(NSUInteger)retainCount {return ULONG_MAX;}
#endif

//每天一遍,第四遍
//.h
#define SINGLE_H(className)     +(instancetype)shared##className;

//.m
#if __has_feature(objc_arc)
#define SINGLE_M(className)\
static id instance;\
+(instancetype)allocWithZone:(struct _NSZone*)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
instance=[super allocWithZone:zone];\
});\
return instance;\
}\
+(instancetype)shared##className{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
instance=[[self alloc]init];\
});\
return instance;\
}
#else
#define SINGLE_M(className)\
static id instance;\
+(instancetype)allocWithZone:(struct _NSZone*)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
instance=[super allocWithZone:zone];\
});\
return instance;\
}\
+(instancetype)shared##className{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken,^{\
instance=[[self alloc]init];\
});\
return instance;\
}\
-(id)copyWithZone:(NSZone*)zone{\
return instance;\
}\
-(oneway void)release{}\
-(instancetype)autorelease {return instance;}\
-(instancetype)retain {return instance;}\
-(NSUInteger)retainCount {return ULONG_MAX;}
#endif



























#endif /* WXSingleShared_h */
