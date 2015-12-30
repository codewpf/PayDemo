//
//  ViewController.m
//  PayDemo
//
//  Created by wpf on 15/12/30.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *aliPay;
@property (nonatomic, strong) UIButton *wechatPay;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WS(weakSelf);
    [self.aliPay makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.height.equalTo(35);
        make.centerY.equalTo(weakSelf.view).offset(-40);
    }];
    [self.wechatPay makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.aliPay.bottom).offset(10);
        make.left.right.height.equalTo(weakSelf.aliPay);
    }];
    
    
}


- (void)aliPayClick
{
    Product *product = [Product new];
    product.orderId = [AppMethod getRandomString];
    product.subject = @"PayDemo_AliPayTest_subject";
    product.body = @"PayDemo_AliPayTest_body";
    product.price = 0.01;
    [[AlipayHelper shared] alipay:product block:^(NSDictionary *result) {
        
        NSString *message = @"";
        switch([[result objectForKey:@"resultStatus"] integerValue])
        {
            case 9000:message = @"订单支付成功";break;
            case 8000:message = @"正在处理中";break;
            case 4000:message = @"订单支付失败";break;
            case 6001:message = @"用户中途取消";break;
            case 6002:message = @"网络连接错误";break;
            default:message = @"未知错误";
        }
        
        UIAlertController *aalert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [aalert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:aalert animated:YES completion:nil];
    }];

}

- (void)wechatPayClick
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:WeChatAppID forKey:@"appid"];
    [dict setObject:@"PayDemo_WeChatPayTest_body" forKey:@"body"];
    [dict setObject:WeChatMCH_ID forKey:@"mch_id"];
    [dict setObject:[AppMethod getRandomString] forKey:@"nonce_str"];
    [dict setObject:WeChatNOTIFY_URL forKey:@"notify_url"];
    
    [dict setObject:[AppMethod getRandomString] forKey:@"out_trade_no"];
    [dict setObject:[AppMethod deviceIPAdress] forKey:@"spbill_create_ip"];
    [dict setObject:@"1" forKey:@"total_fee"];
    [dict setObject:@"APP" forKey:@"trade_type"];
    
    
    NSDictionary *params = [AppMethod partnerSignOrder:dict];
    NSString *postStr = [params XMLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.mch.weixin.qq.com/pay/unifiedorder"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:responseObject];
        if(dict != nil)
        {
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = WeChatMCH_ID;
            req.prepayId            = [dict objectForKey:@"prepay_id"];
            req.nonceStr            = [dict objectForKey:@"nonce_str"];
            req.timeStamp           = [[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] intValue];
            req.package             = @"Sign=WXPay";
            
            NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
            [rdict setObject:WeChatAppID forKey:@"appid"];
            [rdict setObject:req.partnerId forKey:@"partnerid"];
            [rdict setObject:req.prepayId forKey:@"prepayid"];
            [rdict setObject:req.nonceStr forKey:@"noncestr"];
            [rdict setObject:[NSString stringWithFormat:@"%u",(unsigned int)req.timeStamp] forKey:@"timestamp"];
            [rdict setObject:req.package forKey:@"package"];
            NSDictionary *result = [AppMethod partnerSignOrder:rdict];
            
            
            req.sign                = [result objectForKey:@"sign"];
            
            [WXApi sendReq:req];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];

}

- (UIButton *)aliPay
{
    if(!_aliPay)
    {
        _aliPay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_aliPay setTitle:@"支付宝支付" forState:UIControlStateNormal];
        [_aliPay setTitleColor:RGBIntegerColor(0, 209, 170, 100) forState:UIControlStateNormal];
        [_aliPay addTarget:self action:@selector(aliPayClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_aliPay];
    }
    return _aliPay;
}

- (UIButton *)wechatPay
{
    if(!_wechatPay)
    {
        _wechatPay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatPay setTitle:@"微信支付" forState:UIControlStateNormal];
        [_wechatPay setTitleColor:RGBIntegerColor(67, 170, 212, 100) forState:UIControlStateNormal];
        [_wechatPay addTarget:self action:@selector(wechatPayClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_wechatPay];

    }
    return _wechatPay;
}

@end
