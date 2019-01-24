//
//  JHTempJumpWithRouteModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 2017/4/10.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "JHJumpRouteModel.h"
#import "NSString+Tool.h"
#import "YFTabBarController.h"

@protocol JavaScriptDelegate <JSExport>

//@optional(不能设置optional，否则代理不走)
-(void)goBack;
JSExportAs(onShare, -(void)onShare:(id)json);
JSExportAs(onShare, -(void)gotoShare:(id)obj);//网页中的分享
JSExportAs(onContextMenu,-(void)addMenu:(id)obj);//添加导航右边的按钮
JSExportAs(previewImage,-(void)previewImage:(id)obj);//图片浏览
JSExportAs(onLogin,-(void)onLogin:(id)obj);//登录
JSExportAs(onPayment, -(void)onPayment:(id)obj);//调用原生支付
-(void)chooseImage;//选择图片
-(void)getLocation;//获取坐标
@end

@interface JHJumpRouteModel()<JavaScriptDelegate>
@end
@implementation JHJumpRouteModel

#pragma mark ======JS交互需要实现的方法=======
-(void)goBack{
    if ([self.jsDelegate respondsToSelector:@selector(goBack)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.jsDelegate goBack];
        });
    }
}
-(void)onShare:(id)json{
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(onShare:)]) {
        if ([json isKindOfClass:[NSDictionary class]]) {
           [self.jsDelegate onShare:json];
        }else{
            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            [self.jsDelegate onShare:dic];
        }
    }
}
#pragma 网页中的分享会调用这个方法
-(void)gotoShare:(id)obj{
    NSDictionary *dic;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dic = obj;
    }else{
        dic = [self jsonStrToDic:obj];
    }
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(gotoShare:)]) {
        [self.jsDelegate gotoShare:dic];
    }
}
#pragma mark - 给原生导航右边添加按钮
-(void)addMenu:(id)obj{
    NSDictionary *dic;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dic = obj;
    }else{
        dic = [self jsonStrToDic:obj];
    }
    NSString *str = dic[@"type"];
    EMenuType type = 0;
    if ([str isEqualToString:@"more"]) {
        type = EMenuTypeMore;
    }else if ([str isEqualToString:@"search"]){
        type = EMenuTypeSearch;
    }else if ([str isEqualToString:@"phone"]){
        type = EMenuTypePhone;
    }else if ([str isEqualToString:@"share"]){
        type = EMenuTypeShare;
    }else if ([str isEqualToString:@"text"]){
        type = EMenuTypeText;
    }
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(addMenu:type:)]) {
        [self.jsDelegate addMenu:dic[@"params"] type:type];
    }
}
#pragma mark - 调用app展示一组图片
-(void)previewImage:(id)obj{
    NSDictionary *dic;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dic = obj;
    }else{
        dic = [self jsonStrToDic:obj];
    }
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(previewImage:)]) {
        [self.jsDelegate previewImage:dic];
    }
}
#pragma mark - 将json字符串转化为字典
-(NSDictionary *)jsonStrToDic:(NSString *)str{
    NSData *data= [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}
#pragma mark - 将json字符串转化为数组
-(NSArray *)jsonStrToArr:(NSString *)str{
    NSData *data= [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return arr;
}
#pragma mark - 选择图片
-(void)chooseImage{
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(chooseImage)]) {
        [self.jsDelegate chooseImage];
    }
}
#pragma mark -获取坐标
-(void)getLocation{
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(getLocation)]) {
        [self.jsDelegate getLocation];
    }
}
#pragma mark - 登录
-(void)onLogin:(id)obj{
    NSDictionary *dic;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dic = obj;
    }else{
        dic = [self jsonStrToDic:obj];
    }
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(onLogin:)]) {
        [self.jsDelegate onLogin:dic];
    }
}
#pragma mark - 调用原生支付
-(void)onPayment:(id)obj{
    NSDictionary *dic;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dic = obj;
    }else{
        dic = [self jsonStrToDic:obj];
    }
    if (self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(onPayment:)]) {
        [self.jsDelegate onPayment:dic];
    }
}
//-(void)goload{
//    
//    if ([self.jsDelegate respondsToSelector:@selector(goload)]) {
//        [self.jsDelegate goload];
//    }
//}
//
//- (void)toPay:(NSString *)order_id amount:(NSString *)amount url:(NSString *)url code:(NSString *)code{
//    
//    if ([self.jsDelegate respondsToSelector:@selector(toPay:amount:url:code:)]) {
//        [self.jsDelegate toPay:order_id amount:amount url:url code:code];
//    }
//    
//}


#pragma mark ====== 路由处理 =======
+(id)jumpWithLink:(NSString *)link{

    UIViewController *vc;
     // 首页
    if ([link hasSuffix:[NSString stringWithFormat:@"%@/%@",KReplace_Url,@"index.html"]]
        || [link hasSuffix:[NSString stringWithFormat:@"%@/%@",KReplace_Url,@"index/index.html"]]) {
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:NSClassFromString(@"YFTabBarController")]) {
            YFTabBarController *tabbar = (YFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
            tabbar.selectedIndex = 0;
            vc = tabbar;
            goto back;
        }
    }
    
    // 登录
    if ([link containsString:@"passport/login.html"]) {
        [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
        return vc;
    }

//    #pragma mark ====== 跑腿的路由 =======
//    if ([link containsString:@"paotui/index"]) {
//        vc = [YFTabBarController new];
//        [(YFTabBarController *)vc paoTuiTabbar];
//        goto back;
//    }
//    
//    #pragma mark ====== 团购的路由 =======
//    if ([link containsString:[NSString stringWithFormat:@"tuan.%@",KReplace_Url]]||IsTuanGou) {
//        // 团购模块
//        if ([link isEqualToString:[NSString stringWithFormat:@"http://tuan.%@",KReplace_Url]]||
//            [link isEqualToString:[NSString stringWithFormat:@"https://tuan.%@",KReplace_Url]]) {
//            
//            vc = [YFTabBarController new];
//            [(YFTabBarController *)vc tuanGouTabbar];
//            goto back;
//        }
//        
//        // 团购分类列表
//        if ([link containsString:@"shop/index"]) {
//            vc = [NSClassFromString(@"JHTuanSearchResultVC") new];
//            NSString *cate_id = [NSString getSingleParamFormUrlStr:link param:@"cat_id"];
//            [vc setValue:cate_id forKey:@"cate_id"];
//            goto back;
//        }
//        
//        // 团购商品详情
//        if ([link containsString:@"product/detail"]) {
//            vc = [NSClassFromString(@"JHTuanGouGoodsDetailVC") new];
//            [vc setValue:[self getParameterWithLink:link] forKey:@"tuan_id"];
//            goto back;
//        }
//        
//        // 团购商家详情
//        if ([link containsString:@"shop/detail"]) {
//            vc = [NSClassFromString(@"JHTuanGouShopDetailVC") new];
//            [vc setValue:[self getParameterWithLink:link] forKey:@"shop_id"];
//            goto back;
//        }
//    }
//
//    #pragma mark ====== 商城的路由 =======
//    if ([link containsString:[NSString stringWithFormat:@"mall.%@",KReplace_Url]]||IsMall) {
//        // 商城模块
//        NSString *normal_link = [link componentsSeparatedByString:@"://"].lastObject;
//        
//        if ([normal_link isEqualToString:[NSString stringWithFormat:@"mall.%@",KReplace_Url]] || [normal_link isEqualToString:KReplace_Url] ||  [link hasSuffix:@"/mall/index.html"]) {
//            vc = [YFTabBarController new];
//            [(YFTabBarController *)vc mallTabbar];
//            goto back;
//        }
//        
//        // 商城商品详情
//        if ([link containsString:@"product/detail"]) {
//            vc = [NSClassFromString(@"JHMallGoodsDetailVC") new];
//            [vc setValue:[self getParameterWithLink:link] forKey:@"product_id"];
//            goto back;
//        }
//        
//        // 商城商家详情
//        if ([link containsString:@"shop/detail"]) {
//            vc = [NSClassFromString(@"JHMallShopDetailVC") new];
//            [vc setValue:[self getParameterWithLink:link] forKey:@"shop_id"];
//            goto back;
//        }
//        
//        // 商城搜索界面
//        if ([link containsString:@"shop/index"] || [link containsString:@"product/index"]) {
//            vc = [NSClassFromString(@"JHMallSearchResultVC") new];
//            [vc setValue:@([link containsString:@"shop/index"]) forKey:@"is_more_shop"];
//            [vc setValue:[NSString getSingleParamFormUrlStr:link param:@"cate_id"] forKey:@"cate_id"];
//            goto back;
//        }
//        
//        // 商城订单界面
//        if ([link containsString:@"ucenter/order.html"] || [link containsString:@"ucenter/order/index"]) {
//            vc = [NSClassFromString(@"JHMallAllOrderVC") new];
//            goto back;
//        }
//
//    }
//    
    #pragma mark ====== 外卖的路由 =======
    if ([link containsString:[NSString stringWithFormat:@"waimai.%@",KReplace_Url]]||IsWaiMai) {
    
        // 外卖模块
        if ([link isEqualToString:[NSString stringWithFormat:@"http://waimai.%@",KReplace_Url]] || [link isEqualToString:[NSString stringWithFormat:@"https://waimai.%@",KReplace_Url]]) {
            vc = [YFTabBarController new];
            [(YFTabBarController *)vc waimaiTabbar];
            goto back;
        }
        
        // 外卖商家列表
        if ([link containsString:@"shoplist/index"]) {
            
            NSString *cate_id = [NSString getSingleParamFormUrlStr:link param:@"cate_id"];
            cate_id = cate_id.length == 0 ? [NSString getSingleParamFormUrlStr:link param:@"cat_id"] : cate_id;
            cate_id = cate_id.length == 0 ? [self getParameterWithLink:link] : cate_id;
            
            vc = [NSClassFromString(@"JHWaiMaiShopListVC") new];
            [vc setValue:cate_id forKey:@"cate_id"];
            
            goto back;
        }
        
        // 外卖商家详情
        if ([link containsString:@"shop/detail"]) {
            NSString *shop_id =  [self getParameterWithLink:link];
            vc = [NSClassFromString(@"JHWaiMaiShopDetailVC") new];
            [vc setValue:shop_id forKey:@"shop_id"];
            goto back;
        }
        
        // 外卖订单详情
        if ([link containsString:@"ucenter/order/detail"]) {
            
            NSString *order_id =  [self getParameterWithLink:link];
            vc = [NSClassFromString(@"JHWaimaiOrderDetailVC") new];
            [vc setValue:order_id forKey:@"order_id"];
            goto back;
        }
        
        // 外面订单列表
        if ([link containsString:@"ucenter/order.html"]) {
            
            YFTabBarController *tabbar = (YFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
            tabbar.selectedIndex = 2;
            
            vc = [NSClassFromString(@"JHWaiMaiOrderVC") new];
            goto back;
        }
        
        // 外卖个人中心
        if ([link containsString:@"ucenter/member.html"]) {
            
            YFTabBarController *tabbar = (YFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
            tabbar.selectedIndex = 3;
            
            vc = [NSClassFromString(@"JHWaiMaiMySelfVC") new];
            goto back;
        }
   }
    
    back: {
        if (!vc)  {
            vc = [NSClassFromString(@"JHADWebVC") new];
            [vc setValue:link forKey:@"url"];
        }
    }
    return vc;
    
}
//原生界面,如果有参数,取出参数
+(NSString *)getParameterWithLink:(NSString *)link{
    
    link = [[link componentsSeparatedByString:@".html"]firstObject];
    NSString *str = @"";
    
    if ([link containsString:@"shoplist/index-"]) {
        // 商家列表
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if ([link containsString:@"shop/detail-"]){
        // 商家详情 
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if ([link containsString:@"ucenter/order/detail-"] && [link containsString:@"-"]){
        // 订单详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
        
    }else if ([link containsString:@"product/detail-"]){
        // 商品详情
        str = [[link componentsSeparatedByString:@"-"]lastObject];
    }

    return str;
    
}

@end
