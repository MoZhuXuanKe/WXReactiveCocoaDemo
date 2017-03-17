//
//  ShareVC.m
//  WXReactiveCocoaDemo
//
//  Created by WX on 16/12/2.
//  Copyright © 2016年 WXmozhuxuanke. All rights reserved.
//

#import "ShareVC.h"
#import "UMSocial.h"                    // 友盟分享
#import "UMSocialWechatHandler.h"       // 微信
#import "UMSocialSinaSSOHandler.h"      // 微博
#import "UMSocialQQHandler.h"           // QQ和QQ空间
#import "WXRedView.h"
@interface ShareVC ()<UMSocialUIDelegate>
@property(nonatomic,strong)UIButton * btn;
@end

@implementation ShareVC
Single_M(ShareVC)
- (UIButton *) btn{
    if (!_btn) {
        _btn=[[UIButton alloc]init];
    }
    return _btn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreen_width/2, kMainScreen_height/2, 80, 40)];
    [self.btn setTitle:@"分享" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.btn];
    
    WXRedView * redView=[[WXRedView alloc]initWithFrame:CGRectMake(20, 64, kMainScreen_width, kMainScreen_height/2)];
    self.view=redView;
    
    [[redView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮上添加点击事件成功了");
       }];
}
-(void)shareBtnClick{
    
    if (self.delegateSignal) {
        NSLog(@"告诉第一个控制器,分享的控制器被点击了");
        [self.delegateSignal sendNext:@1];
        
    }
    
    NSString *shareContent = @"分享标题";
    NSString *shareIcon = @"my_wechat_qrcode.png";
    NSString *commonContent = @"主标题";
    NSString *commonURL = @"http://baidu.com";
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:YM_Share_App_Key
                                      shareText:shareContent
                                     shareImage:[UIImage imageNamed:shareIcon]
                                shareToSnsNames:@[UMShareToQQ,
                                                  UMShareToQzone,
                                                  UMShareToSina,
                                                  UMShareToWechatSession,
                                                  UMShareToWechatTimeline]
                                       delegate:self];
    //标题
    [UMSocialData defaultData].extConfig.qqData.title = commonContent;            // QQ 标题
    [UMSocialData defaultData].extConfig.qzoneData.title = commonContent;         // QQ 空间
    [UMSocialData defaultData].extConfig.wechatSessionData.title = commonContent;  //微信好友
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = commonContent; // 微信朋友圈
    //url
    [UMSocialData defaultData].extConfig.qqData.url = commonURL;                 // qq url
    [UMSocialData defaultData].extConfig.qzoneData.url = commonURL;           // QQ空间 url
    [UMSocialData defaultData].extConfig.wechatSessionData.url = commonURL;    // 微信好友 url
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = commonURL;    // 微信朋友圈 url

    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@,%@",commonContent,commonURL];
}
/** 分享回调 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
