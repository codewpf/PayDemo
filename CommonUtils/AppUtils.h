//
//  AppUtils.h
//  PNeayBy
//
//  Created by wpf on 15/11/15.
//  Copyright © 2015年 wpf. All rights reserved.
//
//////////////////////////---系统设置，方法替换---//////////////////////////////

#ifndef AppUtils_h
#define AppUtils_h

#pragma mark - SDK宏定义
//////////////////////////支付宝//////////////////////////////
#define AlipayPARTNER           @""
#define AlipaySELLER            @""
#define AlipayRSA_PRIVATE       @""
#define AlipayRSA_ALIPAY_PUBLIC @"";
//获取服务器端支付数据地址（商户自定义）
#define AlipayBackURL           @""


//////////////////////////微信//////////////////////////////
#define WeChatAppID             @""
#define WeChatAppSecret         @""
//商户号，填写商户对应参数
#define WeChatMCH_ID                  @""
//商户API密钥，填写相应参数
#define WeChatPARTNER_ID              @""
//支付结果回调页面
#define WeChatNOTIFY_URL              @""
//获取服务器端支付数据地址（商户自定义）
#define SP_URL                  @""
//http://pay1.fujin.com/aspx/alipayreturn_m.aspx?f=app1


#pragma mark - 方法替换等
//////////////////////////方法替换//////////////////////////////
#ifdef DEBUG
#define WPFLOG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#elif RELEASE
#define WPFLOG(xx, ...)  ((void)0)
#else
#define WPFLOG(xx, ...)  ((void)0)
#endif


#define IMAGE(a)                     [UIImage imageNamed:(a)]


// 防止循环引用
#define WS(weakSelf)      __weak __typeof(&*self)weakSelf = self;



#pragma mark - 字体
//////////////////////////字体//////////////////////////////
#define mySysFont(a)                 [UIFont systemFontOfSize:(a)]
#define myBolFont(a)                 [UIFont boldSystemFontOfSize:(a)]
#define myItaFont(a)                 [UIFont italicSystemFontOfSize:(a)]

#pragma mark - 颜色
//////////////////////////颜色//////////////////////////////

#define RGBIntegerColor(r,g,b,a)     [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)/100.0f]

#define COLOR_WITHIMAGE(a)           [UIColor colorWithPatternImage:[UIImage imageNamed:(a)]]
//
#define COLOR_CLEARCOLOR             [UIColor clearColor]
#define COLOR_WHITECOLOR             [UIColor whiteColor]
#define COLOR_BLACKCOLOR             [UIColor blackColor]
#define COLOR_GRAYCOLOR              [UIColor grayColor]
#define COLOR_LIGHTGRAYCOLOR         [UIColor lightGrayColor]
#define COLOR_REDCOLOR               [UIColor redColor]
#define COLOR_BLUECOLOR              [UIColor blueColor]
#define COLOR_GREENCOLOR             [UIColor greenColor]





#pragma mark - 系统属性
//////////////////////////系统属性//////////////////////////////
#define NAVHEIGHT         64




#endif /* AppUtils_h */
