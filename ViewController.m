//
//  ViewController.m
//  WXReactiveCocoaDemo
//
//  Created by WX on 16/11/28.
//  Copyright © 2016年 WXmozhuxuanke. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>
#import "ShareVC.h"

@interface ViewController ()

@property(nonatomic,strong)UITextField * userNameFiled;
@property(strong,nonatomic)UITextField * passwordFiled;
@property (strong,nonatomic)UIButton*signBtn;
@property(nonatomic,strong)NSString *textFiledText;
@end

@implementation ViewController
#pragma mark - 快速创建单例
WX_SINGLESHARE_M(ViewController)

#pragma mark - lazy
- (UITextField *) userNameFiled{
    if (!_userNameFiled) {
        _userNameFiled=[[UITextField alloc]init];
    }
    return _userNameFiled;
}
- (UITextField *) passwordFiled{
    if (!_passwordFiled) {
        _passwordFiled=[[UITextField alloc]init];
    }
    return _passwordFiled;
}
- (UIButton *) signBtn{
    if (!_signBtn) {
        _signBtn=[[UIButton alloc]init];
    }
    return _signBtn;
}



#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    /*
     *  一 . RAC 在登录界面的简单应用
     */
    [self textFildAndLogTest];
    
    /*
     * 二. RAC对集合数组方面的使用
     */
    [self foundationTest];
    
    /*
     * 三. RAC_代替KVC中的应用---实现许多监听事件
     */
    [self kvc];
    
    /*
     * 四.RAC_小技巧
     */
    [self other];
    
    /*
     * 五. RAC_代替代理
     */
    [self delegate];//用法一
//    [self gotoshare];//用法二(跳转控制器中使用)
    
    
    /*
     * 六. RAC_代替通知(在ShareVC中发送通知,在这里接收)
     */
    [self notification];
    
}

/*
 *测试登录账户用户名和密码框的输入,以及登录按钮的变化
 */
#pragma mark - 测试登录账户用户名和密码框的输入,以及登录按钮的变
-(void)textFildAndLogTest{
    
    [self setUI];//界面
    
    //一个信号,用来绑定用户名
    RACSignal *validUsernameSignal =
    [self.userNameFiled.rac_textSignal
     map:^id(NSString *text) {//返回一个信号
         self.textFiledText=text;
         if (text.length>5) {
             [self.signBtn setTitle:@"赶紧上船" forState:UIControlStateNormal];
         }
         if(text.length>7){
             [self.signBtn setTitle:@"滚犊子" forState:UIControlStateNormal];
             
         }
         if(text.length<5){
             [self.signBtn setTitle:@"登录" forState:UIControlStateNormal];
             
         }
         return @([self isValidUsername:text]);
     }];
    
    //第二个信号,用来绑定密码
    RACSignal *validPasswordSignal =
    [self.passwordFiled.rac_textSignal
     map:^id(NSString *text) {//返回一个信号
         return @([self isValidPassword:text]);
     }];
    //监听用户名的背景颜色属性,对其进行修改
    RAC(self.userNameFiled, backgroundColor)=[validUsernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor redColor];
    }];
    //监听用户名的背景颜色属性,对其进行修改
    RAC(self.passwordFiled, backgroundColor)=[validPasswordSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor redColor];
    }];
    //监听密码输入长度,做一些逻辑处理
    [self.passwordFiled.rac_textSignal subscribeNext:^(NSString *  x) {
        if (x.length>5) {
            [self.signBtn setTitle:@"一般" forState:UIControlStateNormal];
        }else if (x.length>7){
            [self.signBtn setTitle:@"真安全👍" forState:UIControlStateNormal];
        }else if (x.length<5){
            [self.signBtn setTitle:@"太危险" forState:UIControlStateNormal];
        }
    }];
    
}
/*
 *字符串集合数组元祖等简单使用
 */
#pragma mark - 字符串集合数组元祖等简单使用
-(void)foundationTest{
    
    /*
     *  一 对于集合,RAC 的简单应用
     */
    
    //>>>例子1
    
    //1.用一个信号接收 : 字符串集合分割成数组后,再变成rac 的集合,再转化为的信号,
    RACSignal * letters=[@"a s d f g g h h j k k h f " componentsSeparatedByString:@" "].rac_sequence.signal;
    //2.订阅信号,输出打印,在block里面可以对其进行修改
    [letters subscribeNext:^(id x) {
        NSLog(@"RAC----RAC----------%@",x);
    }];
    //2的变形:可以判定输出完成的订阅信号的方式
    [letters subscribeNext:^(id x) {
        NSLog(@"RAC----RAC----------%@",x);
    } completed:^{//标示接收数据完成了
        NSLog(@"RAC`----RAC----------结束了");
    }];
    
    //>>>例子2
    
    //1用来处理数字集合
    RACSignal *numbers=[@" 3 4 5 6 7 8 9 12 21 27 22" componentsSeparatedByString:@" "].rac_sequence.signal;
    //1直接订阅,打印符合条件的数字
    [numbers subscribeNext:^(NSNumber *x) {//这里的  id x   --->可以改为任何自己需要的数据类型NSString * str
        if ((x.intValue%3)==0) {//打印可以整除3的数字|这里可以自己用条件语句判断,也可以用RAC自带的filter
            NSLog(@"%@",x);
        }
    }];
    
    //>>>例子3
    //2用rac 的集合,创建一个新数组
    RACSequence *num=[@"1 2 3 4 5 6 7 8 9"componentsSeparatedByString:@" "].rac_sequence;
    //对这个RAC的集合进行过滤.返回的是bool类型
    RACSequence *filtered=[num filter:^BOOL(NSString *value){//block传进的参数原来是id x  -->NSString
        return (value.intValue%2)==0;//返回可以整除2 的数字
    }];
    //3.filtered.signal--->把filter转化为信号, subscribeNext:------>订阅这个信号(信号只有被订阅才能变为热信号,才能激活,有变化时,及时传输新的变化值)
    [filtered.signal subscribeNext:^(id x) {
        NSLog(@"另一所学校:%@",x);
    }];
    //>>>例子3(多种使用形式)
    
    //在这里不能直接用filtered.|先过滤,在订阅打印
    [[num.signal filter:^BOOL(NSString* value) {
        return  (value.intValue%5)==0;
    }] subscribeNext:^(id x) {
        NSLog(@"数字%@能把五整除,厉害吧",x);
    }];
    
    
    /*
     *对于NSArray的应用
     */
    //>>>array.rac_sequence.signal是先把书谁谁转换为RAC的集合形式,再转化为信号|subscribeNext:--->订阅信号
    NSArray * array=@[@"1",@"2",@"3",@"4",@"5"];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
    }];
    //使用RAC遍历数组
    NSArray * arr=@[@"4",@"2",@"3",@"3"];
    
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    //过滤数组,再订阅打印符合条件的值
    [[array.rac_sequence.signal filter:^BOOL(NSNumber* value) {
        return (value.integerValue%3)==1;
    }] subscribeNext:^(id x) {
        NSLog(@"数组里除以三余数为一的数 = %@",x)//
    }];
    
    /*
     *
     */
    //RAC==>遍历字典
    NSDictionary * dic=@{@"nihk":@"898 ",@"age":@"434343"};
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [dic.rac_sequence.signal subscribeNext:^(RACTuple * x) {
            //RAC 宏解析元组
            RACTupleUnpack(NSString * key,NSString * value)=x;
            
            NSLog(@"%@:%@",key,value);
        }];
    });
    
    
    /*
     *对于元组的使用
     */
    
    //快速创元组
    RACTuple *tuple=RACTuplePack(@"终于",@"JDK",@"你了",@"哈哈");
    
    [tuple.rac_sequence.signal subscribeNext:^(id x) {
        //快速解析元组
        RACTupleUnpack(NSString * str,NSString * strValue,NSString * ni,NSString*h)=tuple;//(等号右边是要被解析的元组)
        
        NSLog(@"%@:%@,%@,%@",str,strValue,ni,h);
    }];
}
#pragma mark - RAC代替KVC的使用
-(void)kvc{
    /*
     *RAC代替KVC的使用
     */
    //1-用RACObserve监听控制器的textFiledText属性
    [RACObserve(self, self.textFiledText) subscribeNext:^(NSString * x) {
        NSLog(@"%@",x);
    }];
    //2-用RACObserve监听登录按钮的text
    [RACObserve(self, self.signBtn.titleLabel.text) subscribeNext:^(NSString * x) {
        NSLog(@"%@",x);
    }];
    
    /*
     *3-RAC结合单例实现kvc--->监听本控制器的登录按钮的属性-->和上面的效果一样
     */
    [RACObserve([ViewController sharedViewController], signBtn.titleLabel.text) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    //textfiled中,监听输入的文字,用👇方式
    //4-监听用户名的文本输入
    [self.userNameFiled.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"userNameFiled:%@",x);
    } completed:^{
        NSLog(@"userNameFiled:++++");
    }];
    //监听密码框的输入
    [self.passwordFiled.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"passwordFiled:%@",x);
    } completed:^{
        NSLog(@"passwordFiled:++++");
    }];
    //5-监听某个对象属性的改变
    [[self.view rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    //6-监听某个属性的事件的改变
    [[self.signBtn rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(id x) {
        NSLog(@"点击了登录按扭");
    }];
    
}
#pragma mark - 跳过-延迟
-(void)other{
    //跳过前一个信号-->skip
    [[[self.userNameFiled rac_textSignal] skip:1] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    //延迟-->delay:几秒发送信号
    [[[self.userNameFiled rac_textSignal] delay:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
#pragma mark - RAC 代替代理
-(void)delegate{
    //用view去监听他视图上的某个方法的点击事情,实现代理
    [[self.view rac_signalForSelector:@selector(gotoshare) ] subscribeNext:^(id x) {
        NSLog(@"gotovc 被点击了");
    }];
    
}
#pragma mark - RAC 代替通知NSNotification
-(void)notification{
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RAC_notification" object:nil] subscribeNext:^(NSNotification* notificaton) {
        //第一种接收方式
        NSLog(@"%@",notificaton.object);
        //第二种接收方式(知道传输的数据格式的前提下)
        NSDictionary * dic=notificaton.object;
        NSLog(@"%@",dic[@"name"]);
    }];
}
#pragma mark - SETUI
-(void)setUI{
    self.userNameFiled.layer.borderWidth=1;
    self.userNameFiled.placeholder=@"请输入用户名";
    self.userNameFiled.layer.borderColor=[UIColor blueColor].CGColor;
    self.userNameFiled.frame=CGRectMake(50, kMainTopHeight+50, kMainScreen_width-100, 40);
    [self.view addSubview:self.userNameFiled];

    self.passwordFiled.layer.borderWidth=1;
    self.passwordFiled.placeholder=@"请输入密码";
    self.passwordFiled.layer.borderColor=[UIColor blueColor].CGColor;
    self.passwordFiled.frame=CGRectMake(50, kMainTopHeight+100, kMainScreen_width-100, 40);
    [self.view addSubview:self.passwordFiled];
    
    self.signBtn.layer.borderWidth=1;
    [self.signBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.signBtn addTarget:self action:@selector(gotoshare) forControlEvents:UIControlEventTouchUpInside];
    [self.signBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.signBtn.layer.borderColor=[UIColor blueColor].CGColor;
    self.signBtn.frame=CGRectMake((kMainScreen_width-80)/2, kMainTopHeight+150, 80, 40);
    [self.view addSubview:self.signBtn];

}

#pragma mark -  分享跳转控制器
-(void)gotoshare{
    
    ShareVC * vc=[[ShareVC alloc]init];
    //deegate实现
    vc.delegateSignal=[RACSubject subject];
    [vc.delegateSignal subscribeNext:^(id x) {
        NSLog(@"已经分享过了,哈哈");
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 判断用户名是否有效
- (BOOL)isValidUsername:(NSString *)userName
{
    return userName.length > 2;
}
#pragma mark - 判断密码是否有效
- (BOOL)isValidPassword:(NSString *)password
{
    return password.length > 2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
