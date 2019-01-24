//
//  YFPayTool.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "YFPayTool.h"
#import <AlipaySDK/AlipaySDK.h>
//#import <PayPal-iOS-SDK/PayPalMobile.h>
#import "WXApi.h"

@interface YFPayTool ()
/// <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>
@property(nonatomic,copy)PayResultBlock resultBlock;
//@property(nonatomic,strong)PayPalPaymentViewController *paymentViewController;
//@property(nonatomic,weak)UIViewController *presentVC;
@end

@implementation YFPayTool

static id _instance=nil;

+(instancetype)shareYFPayTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] init];
         [NoticeCenter addObserver:_instance selector:@selector(successPayOrder) name:WXSuccessPay_Notification object:nil];
         [NoticeCenter addObserver:_instance selector:@selector(failPayOrder) name:WXFailPay_Notification object:nil];
    });
    return _instance;
}

#pragma mark ====== 支付宝支付 =======
+(void)AlipayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock{
    
    [HttpTool postWithAPI:api withParams:params success:^(id json) {
        NSLog(@"支付宝支付 %@",json);
        if ([json[@"error"] intValue]==0) {
            if ([json[@"data"][@"go_order_detail"] isEqualToString:@"1"]) {
                resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
                return ;
            }
            [[YFPayTool shareYFPayTool] AlipayWith:json[@"data"] block:resultBlock];
        }
        else  resultBlock(NO,Error_Msg);
    } failure:^(NSError *error) {
        resultBlock(NO,NSLocalizedString(@"服务器繁忙,请稍后再试!", @"YFPayTool"));
    }];
    
}

-(void)AlipayWith:(NSDictionary *)resultDic block:(PayResultBlock)resultBlock{
    
    NSString *partner = resultDic[@"partner"];
    NSString *seller = resultDic[@"seller_id"];
    if ([partner length] == 0 || [seller length] == 0 ) {
        resultBlock(NO,NSLocalizedString(@"缺少partner或者seller或者私钥", nil));
        return;
    }
    
    NSArray *urlArr =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    NSString *appScheme=@"waimaiV3";//用来区别不同app的标示，需要在info.plist文件中配置
    for (NSDictionary *dic in urlArr) {
        if ([dic.allKeys containsObject:@"CFBundleURLName"]) {
            appScheme=[dic[@"CFBundleURLSchemes"] lastObject];
        }
    }
    
    NSString *orderSpec =resultDic[@"signstr"];
    NSString *signedString = resultDic[@"sign"];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
//        NSLog(@"orderString   %@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"])  {
                resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
                return ;
            }
            else  {
                resultBlock(NO,NSLocalizedString(@"支付失败", @"YFPayTool"));
                return;
            }
            
        }];
    }
}

#pragma mark ====== 微信支付 =======
+(void)WXPayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock{
    
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        resultBlock(NO,NSLocalizedString(@"请先安装微信!", nil));
        return;
    }
    
    [HttpTool postWithAPI:api withParams:params success:^(id json) {
        NSLog(@"微信支付 %@",json);
        if ([json[@"error"] intValue]==0) {
            if ([json[@"data"][@"go_order_detail"] isEqualToString:@"1"]) {
                resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
                return ;
            }
            [[YFPayTool shareYFPayTool] WXPayWith:json[@"data"] block:resultBlock];
        }
        else  resultBlock(NO,Error_Msg);
        
    } failure:^(NSError *error) {
        resultBlock(NO,NSLocalizedString(@"服务器繁忙,请稍后再试!", @"YFPayTool"));
    }];
    
}

-(void)WXPayWith:(NSDictionary *)resultDic block:(PayResultBlock)resultBlock{
    self.resultBlock = resultBlock;
    
    PayReq * request = [[PayReq alloc]init];
    request.partnerId = resultDic[@"partnerid"];//商户号
    request.prepayId =  resultDic[@"prepayid"];//微信返回的支付交
    request.package =  resultDic[@"package"];//扩展字段
    request.nonceStr=  resultDic[@"noncestr"];//随机字符串
    request.timeStamp = (UInt32)[resultDic[@"timestamp"] integerValue];//时间戳
    request.sign = resultDic[@"sign"];//签名
    [WXApi sendReq:request];
    
}

// 微信支付的回调
-(void)successPayOrder{
    self.resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
}

-(void)failPayOrder{
    self.resultBlock(NO,NSLocalizedString(@"支付失败", @"YFPayTool"));
}

#pragma mark ====== 余额支付 =======
+(void)moneyPayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock{
    [HttpTool postWithAPI:api withParams:params success:^(id json) {
        NSLog(@"余额支付 %@",json);
        if ([json[@"error"] intValue]==0) resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
        else  resultBlock(NO,Error_Msg);
    } failure:^(NSError *error) {
        resultBlock(NO,NSLocalizedString(@"服务器繁忙,请稍后再试!", @"YFPayTool"));
    }];
}

#pragma mark ====== 好友代付 =======
+(void)friendPayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock{
    [HttpTool postWithAPI:api withParams:params success:^(id json) {
        NSLog(@"好友代付 %@",json);
        if ([json[@"error"] intValue]==0) resultBlock(YES,json[@"data"][@"friendpay_link"]);
        else  resultBlock(NO,Error_Msg);
    } failure:^(NSError *error) {
        resultBlock(NO,NSLocalizedString(@"服务器繁忙,请稍后再试!", @"YFPayTool"));
    }];
    
}

#pragma mark ====== 信用卡支付 =======
+(void)stripePayApi:(NSString *)api params:(NSDictionary *)params block:(PayResultBlock)resultBlock{
    [HttpTool postWithAPI:api withParams:params success:^(id json) {
        NSLog(@"信用卡支付 %@",json);
        if ([json[@"error"] intValue]==0) resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
        else  resultBlock(NO,Error_Msg);
    } failure:^(NSError *error) {
        resultBlock(NO,NSLocalizedString(@"服务器繁忙,请稍后再试!", @"YFPayTool"));
    }];
}

#pragma mark ====== PayPal支付 =======
+(void)PayPalPayApi:(NSString *)api params:(NSDictionary *)params presentVC:(UIViewController *)presentVC block:(PayResultBlock)resultBlock{

//    [HttpTool postWithAPI:api withParams:params success:^(id json) {
//        NSLog(@"PayPal支付 %@",json);
//        if ([json[@"error"] intValue]==0){
//            if ([json[@"data"][@"go_order_detail"] isEqualToString:@"1"]) {
//                resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
//                return ;
//            }else{
//                [[YFPayTool shareYFPayTool] payPalWithPresentVC:presentVC params:json[@"data"] ];
//            }
//        } else  resultBlock(NO,Error_Msg);
//    } failure:^(NSError *error) {
//        resultBlock(NO,NSLocalizedString(@"服务器繁忙,请稍后再试!", @"YFPayTool"));
//    }];
}

//#pragma mark ====== PayPal支付的处理 =======
//-(void) payPalWithPresentVC:(UIViewController *)presentVC params:(NSDictionary *)info{
//
//    self.presentVC = presentVC;
//    [self setPaypalClientID:info[@"clientId"] model:info[@"paypal_mode"]];
//
//    //paypal支付
//    PayPalPayment *payment = [[PayPalPayment alloc] init];
//    payment.amount = [NSDecimalNumber decimalNumberWithString:info[@"amount"]]; //总价
//    payment.shortDescription = info[@"item_name"];
//    payment.currencyCode = info[@"currency_code"];
//    payment.invoiceNumber = info[@"invoice"];
//
//    if (!payment.processable) {
//
//    }
//    PayPalConfiguration *payPalConfig = [[PayPalConfiguration alloc] init];
//    payPalConfig.acceptCreditCards = YES;
//    self.paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
//                                                                   configuration:payPalConfig
//                                                                        delegate:self];
//    [presentVC presentViewController:self.paymentViewController animated:YES completion:nil];
//}

//// PayPal设置登录账号
//-(void)setPaypalClientID:(NSString *)clientID model:(NSString *)model{
//    if ([model isEqualToString:@"sandbox"]) {
//        //启用paypal支付
//        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:@"",
//                                                               PayPalEnvironmentSandbox:clientID}];
//        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
//    }else{
//        //启用paypal支付
//        [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:clientID,
//                                                               PayPalEnvironmentSandbox:@""}];
//        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
//
//    }
//}

//#pragma mark ====== PayPalPaymentDelegateMethods =======
//- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController{
//    [self.presentVC dismissViewControllerAnimated:YES completion:nil];
//    self.resultBlock(NO,NSLocalizedString(@"支付失败", @"YFPayTool"));
//}
//- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment{
//    NSLog(@"paypal支付成功");
//
//    //发送数据验证
//    NSDictionary *confirmDic = completedPayment.confirmation;
//    NSString *paymentID = confirmDic[@"response"][@"id"];
//    NSString *trade_no = completedPayment.invoiceNumber;
//    [HttpTool postWithAPI:@"client/payment/paypal_return"
//               withParams:@{@"trade_no":trade_no,@"paymentId":paymentID}
//                  success:^(id json) {
//                      NSLog(@"验证数据返回");
//                      if ([json[@"error"] isEqualToString:@"0"]) {
//                          [paymentViewController dismissViewControllerAnimated:YES completion:nil];
//                          self.resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
//                      }
//
//                  } failure:^(NSError *error) {
//                     self.resultBlock(NO,NSLocalizedString(@"服务器繁忙,请稍后再试!", @"YFPayTool"));
//                  }];
//
//}
//
//- (void)payPalFuturePaymentDidCancel:(nonnull PayPalFuturePaymentViewController *)futurePaymentViewController {
//
//}
//
//- (void)payPalFuturePaymentViewController:(nonnull PayPalFuturePaymentViewController *)futurePaymentViewController didAuthorizeFuturePayment:(nonnull NSDictionary *)futurePaymentAuthorization {
//
//}
//
//- (void)payPalProfileSharingViewController:(nonnull PayPalProfileSharingViewController *)profileSharingViewController userDidLogInWithAuthorization:(nonnull NSDictionary *)profileSharingAuthorization {
//
//}
//
//- (void)userDidCancelPayPalProfileSharingViewController:(nonnull PayPalProfileSharingViewController *)profileSharingViewController {
//
//}
+(void)getPayMessage:(NSString *)from andDic:(NSDictionary *)dic andApi:(NSString *)api block:(PayResultBlock)resultBlock{
    
    
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if ([dic[@"code"] isEqualToString:@"alipay"]) {
            if ([json[@"error"] intValue]==0) {
//                if ([json[@"data"][@"go_order_detail"] isEqualToString:@"1"]) {
//                    //                resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
//                    return ;
//                }
                [[YFPayTool shareYFPayTool] AlipayWith:json[@"data"] block:resultBlock];
            }
            else  resultBlock(NO,Error_Msg);
        }else if([dic[@"code"] isEqualToString:@"wxpay"]){
            NSLog(@"微信支付 %@",json);
            if ([json[@"error"] intValue]==0) {
//                if ([json[@"data"][@"go_order_detail"] isEqualToString:@"1"]) {
//                    resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
//                    return ;
//                }
                [[YFPayTool shareYFPayTool] WXPayWith:json[@"data"] block:resultBlock];
            }
            else  resultBlock(NO,Error_Msg);
            
        }else if([dic[@"code"] isEqualToString:@"money"]){
            
            if ([json[@"error"] intValue]==0) resultBlock(YES,NSLocalizedString(@"支付成功", @"YFPayTool"));
            else  resultBlock(NO,Error_Msg);
            
        }
        
        
    } failure:^(NSError *error) {
        resultBlock(NO,NSLocalizedString(@"服务器繁忙,请稍后再试!", @"YFPayTool"));
    }];
    
    
}
@end
