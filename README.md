# PayDemo
支付宝和微信支付两种方式集成

做这两个支付集成的时候遇到了一些坑，特此写了一个小的DEMO供大家参考

1、支付宝的集成比较简单，主要就是一些设置上的问题；
2、微信的集成比较坑爹，而且官方文档写的也不清不楚的，坑了我很久。

项目中使用的pod添加了三个第三方的框架：AFNetworking Masonry XMLDictionary

一些iOS9的设置就不在下面提了，大家自行百度吧。

# 支付宝支付
支付宝在官方文档中写的比较详细，给的DEMO也很清楚，大家跟着步骤走一步一步都能实现集成。主要是以下几个需要稍微注意一下

1、Header Search Paths的设置

  添加支付宝官方库，导入系统库，其他的不需要设置太多。但是这一个必须要添加以下，不然openssl中的头文件引用会出现问题。
  
  在项目->Build Settings->Header Search Paths中添加下面一行
  
  $(SRCROOT)/\*\*/\*\*/AlipaySDK 其中$(SRCROOT)是项目根目录，AlipaySDK是官方库所在的文件夹。中间路径需要自己添加。
  
2、appScheme的设置

  支付宝有三个地方需要设置而且要保持一致，不然支付完成就无法跳转回应用。Demo中写的是alipayPayDemo
  
  1)项目->Info->URL Types->“+”符号->URL Schemes
  
  2)info.plist->URL Types->URL Schemes  此项一般添加1)后就会自动添加，如有修改记得修改此处。因为修改1)，此处不会跟着修改。
  
  3)AlipayHelper.m->@selector(alipay:block:)方法中的局部参数appScheme
  
3、跟服务端的交互的地方
  
  只有获取订单信息的时候才会跟服务进行交互，所需要的参数在Product中。测试中price一般情况下都给0.01
  
4、系统繁忙，请稍后再试(ALI**)

  **数字类型可能不太一样，大概以下几种问题
  
  1)私钥不正确
  
  2)公钥、私钥没有上传到支付宝商户的后台
  
  3)out_trade_no不能有符号


# 微信支付
微信的设置上没太大问题，但是做的官方支持就非常差劲。而且还使用XML，这一条让一些人可能就懵逼了。

客户端需要做的两步，如果服务端做了统一下单的功能就缩短为一步了。

1、统一下单

  https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=9_1    ->API列表->统一下单
  按照文档要求appid，mch_id，nonce_str，sign，body，out_trade_no，total_fee，spbill_create_ip，notify_url，trade_type这十个参数是必须的。
  
  其中appid，mch_id是微信给的；trade_type传定值APP；nonce_str，spbill_create_ip是直接在手机上获取到的；body，out_trade_no，total_fee这三个是从服务端上获取的数据。sign根据以上键值对按照签名规则得到的。
  
  完成之后要转化成XML格式上传到微信服务器。
  
  第一个比较坑的地方在这，如果直接使用AF的POST方式是不行的，总是会返回"XML格式错误"。必须使用NSMutableURLRequest添加method和body，然后用AFHTTPRequestOperation进行网络请求才行。
  
  
  
  然后接收到数据的返回。其中返回数据中有用的只有prepayid，其他的要么本地就有，要么就是恶心你的值。
  
2、客户端调起支付
  
  https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=9_1    ->API列表->调起支付接口
  文档要求appid，partnerid，prepayid，package，noncestr，timestamp，sign这七个参数是必须的，但是DEMO中appid根本没有用到，所以其实只需要六个参数，这是第二个坑爹的地方！！！
  partnerid就是第一步的mch_id，prepayid是上一步返回的最重要的数据，package传定值Sign=WXPay，noncestr就是上一步中的nonce_str，timestamp这个按照规则生成十位的。
  
  sign是最最最坑的地方，不是上一步返回的那个sign，不是上一步返回的那个sign，不是上一步返回的那个sign。他是根据上面的五个参数进行签名得出的值。不然每次调用就只看见微信界面只有一个确定。
  
  对于返回签名错误的，可以对照他们的签名测试工具检验。https://pay.weixin.qq.com/wiki/tools/signverify/

以上~  

因安全原因项目中的一些配置参数已经删除，大家调试的时候需要添加本公司或个人申请的配置参数。

如有问题可发邮件至iOS_wpf@163.com、ioswpf@gmail.com，或新浪微博私信@弯弯月儿变鸟飞


# ------分割线------

建议各位看官参考此DEMO之前先详细了解官方的文档，熟悉之后如有有问题可以参考此DEMO或者微博、邮件咨询我。有些朋友在微博、邮件中提的问题，在官方文档中讲解的比我本人回答的要详细、专业，部分内容我也是从文档中拷贝出来给各位看官解答的~



