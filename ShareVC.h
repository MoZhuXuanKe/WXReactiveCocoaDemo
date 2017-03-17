//
//  ShareVC.h
//  WXReactiveCocoaDemo
//
//  Created by WX on 16/12/2.
//  Copyright © 2016年 WXmozhuxuanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXSingleShared.h"
@interface ShareVC : UIViewController
Single_H(ShareVC)
@property(nonatomic,strong)RACSubject *delegateSignal;
@end
