//
//  JHADWebVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/14.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHADWebVC.h"

#import "JHJumpRouteModel.h"
#import "ZQShareView.h"
#import "ZQSeeWebImageView.h"
#import "XTPopView.h"

#import "YFPayTool.h"
#import "JHWaimaiMineViewModel.h"
#import "YFTabBarController.h"
#import "ZQWebViewProgressBar.h"
@interface JHADWebVC ()<UIWebViewDelegate,JHJumpRouteModelDelegate,selectIndexPathDelegate>
{
    NSString *textTitle;//如果单个增加文本保存单次的按钮标题
    UIView *moreItem;
    NSString *loginSuccess_Url;//登录成功后需要跳转的网址
    NSString *order_id;//支付的order_id
    NSString *rebackurl;//支付成功
}
@property(nonatomic,strong)ZQShareView *shareView;//分享的view
/*
 以下是保存多个按钮的数据源
 */
@property(nonatomic,strong)NSDictionary *menuShareDic;//保存分享的数据
@property(nonatomic,strong)NSDictionary *menuSearchDic;//保存搜索的数据
@property(nonatomic,strong)NSDictionary *menuPhoneDic;//保存电话的数据
@property(nonatomic,strong)NSDictionary *menuTextDic;//保存文本的数据
@property(nonatomic,strong)NSDictionary *menuMoreDic;//保存更多按钮的数据

@property(nonatomic,copy)NSString *pay_code;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)ZQWebViewProgressBar *progressView;//进度条
/**
 右上角的弹出
 */
@property(nonatomic,strong)XTPopView *popView;

/**
 查看网页图片的View
 */
@property(nonatomic,strong)ZQSeeWebImageView *seeImageView;
// 是否调起了友好代付分享功能
@property(nonatomic,assign)BOOL have_friendPay_share;
@property(nonatomic,copy)NSString *order_id;// 分享支付的订单id
@end

@implementation JHADWebVC

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    JHBaseNavVC *nav_1 = (JHBaseNavVC *)self.tabBarController.viewControllers[1];
    JHBaseVC *vc_0 = (JHBaseVC *)nav_1.viewControllers[0];
    if ([vc_0 isKindOfClass:self.class] && self.tabBarController.selectedIndex == 1) {
        
    }else{
       [_web stopLoading];
    }
    
    [_progressView removeFromSuperview];
    _progressView = nil;
    
}
-(void)clickBackBtn{
    
    if (_is_frendPay_web) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    if (self.is_launch_ad) {
        if([_web canGoBack]){
            [_web goBack];
        }else{
            if (_web.isLoading) {
                [_web stopLoading];
                [_web removeFromSuperview];
                _web = nil;
            }
            [NoticeCenter postNotificationName:AppChangeRootVC object:nil];
        }
    }else{
        if ([self.web canGoBack]) {
            [self.web goBack];
            return;
        }
        JHBaseNavVC *nav_1 = (JHBaseNavVC *)self.tabBarController.viewControllers[1];
        JHBaseVC *vc_0 = (JHBaseVC *)nav_1.viewControllers[0];
        if ([vc_0 isKindOfClass:self.class] && self.tabBarController.selectedIndex == 1) {
            self.tabBarController.selectedIndex = 0;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setCookie];
    [self.view addSubview:self.web];
    JHBaseNavVC *nav = (JHBaseNavVC *)[self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
    if ([[nav.viewControllers firstObject] isKindOfClass:self.class]) {
        _closeBtn = [self addLeftBtnWith:@"nav_btn_back" sel:@selector(clickBackBtn)];
    }else{
        _closeBtn =  [self addLeftBtnWith:@"index_btn_close" sel:@selector(closeVC)];
    }

    self.navigationItem.title = self.titleStr;

    [NoticeCenter addObserver:self selector:@selector(getLoginSuccess) name:Login_Success object:nil];
    [self progressView];
}
-(ZQWebViewProgressBar *)progressView{
    if (!_progressView) {
        CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
        _progressView = [[ZQWebViewProgressBar alloc]init];
        _progressView.frame = FRAME(0, navBarHeight-2, WIDTH, 2);
        _progressView.tintColor = [UIColor colorWithRed:22/255.0 green:128/255.0 blue:250/255.0 alpha:1];
        [self.navigationController.navigationBar addSubview:_progressView];
    }
    return _progressView;
}
#pragma mark -初始化一些数据的方法
-(void)initData{
    _menuTextDic = @{}.mutableCopy;
    
}
#pragma mark - UIWebViewDelegate
#pragma mark ====== 路由跳转处理 =======
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self loadJsObj:webView];
    if (![request.URL.absoluteString containsString:KReplace_Url]) {
        return YES;
    }
    if ([request.URL.absoluteString containsString:@"paotui"]) {
        for (UIView *view in self.rightNavBtnView.subviews) {
            [view removeFromSuperview];
        }
    }
    NSString *str = @"";
    if ([self.url hasPrefix:@"https"]) {
        str = [[self.url componentsSeparatedByString:@"https://"]lastObject];
    }else{
        str = [[self.url componentsSeparatedByString:@"http://"]lastObject];
    }
    if (![request.URL.absoluteString containsString:str]) {// 自己本来的链接不处理
        UIViewController *toVC = [JHJumpRouteModel jumpWithLink:request.URL.absoluteString];
        if ([toVC isKindOfClass:[JHADWebVC class]] || !toVC) {
            return YES;
        }else{
            if ([toVC isKindOfClass:NSClassFromString(@"YFTabBarController")]){
                if ([(YFTabBarController *)toVC tabbarType] == YFTabBarControllerTypeMall) {
                    self.tabBarController.selectedIndex = 0;
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else if ([toVC isKindOfClass:NSClassFromString(@"JHNewWaiMaiMySelfVC")] || [toVC isKindOfClass:NSClassFromString(@"JHWaiMaiOrderVC")]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if ([toVC isKindOfClass:NSClassFromString(@"JHMallAllOrderVC")]) { // 处理商城订单从网页的订单详情一直返回到网页的订单列表的问题
                BOOL isContant = NO;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:NSClassFromString(@"JHMallAllOrderVC")]) {
                        toVC = vc;
                        isContant = YES;
                    }
                }
                if (isContant) {
                    [self.navigationController popToViewController:toVC animated:YES];
                }else{
                    [self.navigationController pushViewController:toVC animated:YES];
                }
                
            }else{
                [self.navigationController pushViewController:toVC animated:YES];
            }
            return NO;
        }
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    HIDE_HUD
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    if (webView.canGoBack) {
//        _closeBtn.hidden = NO;
//    }else{
//        _closeBtn.hidden = YES;
//    }
    [self.progressView completionAnimation];
    HIDE_HUD
    NSString *title =[_web stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title.length == 0 ? self.titleStr : title;
    [self loadJsObj:webView];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progressView initAnimation];
}


#pragma mark ====== Functions =======
// 点击关闭按钮
-(void)closeVC{
    if (_is_frendPay_web) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    if (self.is_launch_ad) {
        if (_web.isLoading) {
            [_web stopLoading];
            [_web removeFromSuperview];
            _web = nil;
        }
        [NoticeCenter postNotificationName:AppChangeRootVC object:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


// 登录成功的回调
-(void)getLoginSuccess{
    if (loginSuccess_Url.length > 0) {
        
        [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loginSuccess_Url]]];
    }else{
        [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    [self setCookie];
}

// 设置cookie
-(void)setCookie{
    if (![self.url containsString:@"http"]) {
        return;
    }
    NSURL *linkUrl = [NSURL URLWithString:self.url];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies];
    
    //cookie中如果有中文 需要特殊处理
    NSString *addr_str = [JHConfigurationTool shareJHConfigurationTool].lastCommunity;
    addr_str = addr_str.length ? addr_str : @"";

    NSString *addr_str_encode = [addr_str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    token = token.length ? token : @"";
    
    NSArray *nameArr = @[@"lat",@"lng",@"addr",@"KT-TOKEN",@"KT-UxCityId"];
    NSArray *valueArr = @[@([JHConfigurationTool shareJHConfigurationTool].lat).stringValue,
                          @([JHConfigurationTool shareJHConfigurationTool].lng).stringValue,
                            addr_str_encode,
                            token,
                          [JHConfigurationTool shareJHConfigurationTool].city_id];
    
    //先删除已经存在的
    for (int i = 0 ; i<arr.count; i++) {
        NSHTTPCookie *cookie_temp = arr[i];
        if ([nameArr containsObject:cookie_temp.name]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie_temp];
        }
    }
    //重新赋值
    arr = [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies mutableCopy];
    //再添加需要赋值的
    for (int i = 0; i < nameArr.count; i ++) {
        NSMutableDictionary *cookieProperties = @{}.mutableCopy;
        NSString *name = nameArr[i];
        NSString *value = valueArr[i];
        [cookieProperties setObject:name forKey:NSHTTPCookieName];
        [cookieProperties setObject:value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        [cookieProperties setObject:linkUrl.host forKey:NSHTTPCookieDomain];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [arr addObject:cookieuser];
    }
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:arr forURL:linkUrl mainDocumentURL:nil];
}
#pragma mark ======添加交互=======
-(void)loadJsObj:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JHJumpRouteModel *obj = [[JHJumpRouteModel alloc]init];
    context [@"JHAPP"] =obj;
    obj.jsDelegate = self;
    //设置异常处理
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [JSContext currentContext].exception = exception;
        NSLog(@"exception:%@",exception);
    };
}
#pragma mark - 接收到的交互方法
-(void)gotoShare:(NSDictionary *)dic{
    /*
     分享如果没有图片链接,直接ZQJavaS中的shareDefaultImage
     分享如果没有内容直接用里面的标题dic[@"desc"]?dic[@"desc"]:dic[@"title"]
     */
    NSLog(@"分享的内容如下:\ndesc:%@\n img:%@\n link:%@\n title:%@",dic[@"desc"],dic[@"img"],dic[@"link"],dic[@"title"]);
    [self shareConfig:dic];
}
-(void)shareConfig:(NSDictionary *)dic{
    self.shareView.shareStr = dic[@"desc"]?dic[@"desc"]:dic[@"title"];
    self.shareView.shareUrl = dic[@"link"];
    self.shareView.shareTitle = dic[@"title"];
    if (dic[@"img"]) {
        self.shareView.shareImgName = dic[@"img"];
    }else{
        self.shareView.isUrlImg = NO;
        self.shareView.shareImgName = @"shareDefaultImage";
    }
    self.have_friendPay_share = [dic[@"is_friendpay"] boolValue];
    self.order_id = dic[@"order_id"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.shareView showAnimation];
    });
}
#pragma mark ====== JHJumpRouteModelDelegate =======
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onShare:(NSDictionary *)json{
    self.shareView.shareStr = json[@"desc"];
    self.shareView.shareUrl = json[@"link"];
    self.shareView.shareTitle = json[@"title"];
    self.shareView.shareImgName = json[@"imgUrl"];
    self.have_friendPay_share = [json[@"is_friendpay"] boolValue];
    self.order_id = json[@"order_id"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.shareView showAnimation];
    });
    
}
-(ZQShareView *)shareView{
    if (!_shareView) {
         __weak typeof(self) weakSelf=self;
        _shareView = [[ZQShareView alloc]init];
        _shareView.isUrlImg = YES;
        _shareView.superVC = self;
        _shareView.shareResultBlock = ^(BOOL success, NSString *msg) {
            if (weakSelf.have_friendPay_share) {
                [weakSelf pushToNextVcWithVcName:@"JHWaimaiOrderDetailVC" params:@{@"order_id":weakSelf.order_id,@"FromPayVC":@(YES)}];
            }
        };
    }
    return _shareView;
}
#pragma mark - 增加按钮的回调
-(void)addMenu:(NSDictionary *)obj type:(EMenuType)type{
    /*
     type:(0:搜索1:电话2:分享3:文字4:多个按钮)
     */
    NSLog(@"%@",obj);
    if (type == 0) {
        _menuSearchDic = obj;
    }else if (type == 1){
        _menuPhoneDic = obj;
    }else if (type == 2){
        _menuShareDic = obj;
    }else if (type == 3){
        textTitle = obj[@"title"];
        [_menuTextDic setValue:obj forKey:textTitle];
    }else if (type == 4){
        _menuMoreDic = obj;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addRightMenu:type];
    });
    
}
#pragma mark - 添加导航右边按钮的方法
-(void)addRightMenu:(NSInteger)status{
    NSArray *arr;
    if ([self.navigationItem.rightBarButtonItem.customView isKindOfClass:NSClassFromString(@"NaviButtonItem")]) {
        arr = [self.navigationItem.rightBarButtonItem.customView subviews];
    };
    if (arr.count>=3) {
        return;
    }
    //    UIButton *item;
    switch (status) {
        case 0://搜索
        {
            //            item =
            [self itemWithImage:@"search" text:nil tag:0];
        }
            break;
        case 1://电话
        {
            //            item =
            [self itemWithImage:@"phone" text:nil tag:1];
        }
            break;
        case 2://分享
        {
            //            item =
            [self itemWithImage:@"share" text:nil tag:2];
        }
            break;
        case 3://文字
        {
            //            item =
            [self itemWithImage:nil text:textTitle tag:3];
        }
            break;
        default://多个按钮
        {
            //            item =
            [self itemWithImage:@"btn_more_v" text:nil tag:4];
            //            moreItem = item.customView;
        }
            break;
    }
    
    //    [arr insertObject:item atIndex:0];
    //    for (int i = 0; i < arr.count; i++) {
    //        UIButton * tempItem = arr[i];
    //        if (tempItem.tag == 4) {
    //            [arr removeObjectAtIndex:i];
    //            [arr insertObject:tempItem atIndex:0];
    //            break;
    //        }
    //    }
    //    self.navigationItem.rightBarButtonItems = arr;
}
-(UIButton *)itemWithImage:(NSString *)image text:(NSString *)text tag:(NSInteger)tag{
    UIButton *item;
    if (image) {
        //        item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(clickItem:)];
        item = [self addRightBtnWith:image sel:@selector(clickItem:)];
    }else{
        //item = [[UIBarButtonItem alloc]initWithTitle:text style:UIBarButtonItemStylePlain target:self action:@selector(clickItem:)];
        item = [self addRightTitleBtn:text titleColor:HEX(@"333333", 1.0) sel:@selector(clickItem:)];
    }
    item.tag = tag;
    return item;
    
}
#pragma mark - 点击导航右边的按钮的方法
-(void)clickItem:(UIBarButtonItem *)sender{
    switch (sender.tag) {
        case 0://搜索
        {
            NSLog(@"搜索的数据源:%@",_menuSearchDic);
            [self jumpLink:_menuMoreDic[@"link"] titleStr:_menuMoreDic[@"title"]];
        }
            break;
        case 1://电话
        {
            NSLog(@"电话的数据源:%@",_menuPhoneDic);
            NSArray *arr = _menuPhoneDic[@"phone"];
            if (arr.count == 1) {//一个电话直接拨号
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",arr[0][@"phone"]]]];
            }else{//多个电话
                [self creatPhoneSheetWithArr:arr];
            }
        }
            break;
        case 2://分享
        {
            NSLog(@"分享的数据源:%@",_menuShareDic);
            [self shareConfig:_menuShareDic];
        }
            break;
        case 3://文字
        {
            NSLog(@"文本的数据源:%@",_menuTextDic[[(UIButton *)sender currentTitle]]);
            NSString *key = [(UIButton *)sender currentTitle];
            NSDictionary *dic = _menuTextDic[key];
            [self jumpLink:dic[@"link"] titleStr:dic[@"title"]];
        }
            break;
        default://多个按钮
        {
            NSLog(@"多个按钮的数据源:%@",_menuMoreDic);
            [self.popView popView];
        }
            break;
    }
}
#pragma mark - 网页在原生这里增加按钮的点击的网页跳转
-(void)jumpLink:(NSString *)link titleStr:(NSString *)title{
  
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
}
#pragma mark - 多个电话按钮的显示
-(void)creatPhoneSheetWithArr:(NSArray *)arr{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *dic in arr) {
        [alert addAction:[UIAlertAction actionWithTitle:dic[@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",dic[@"phone"]]]];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(XTPopView *)popView{
    if (!_popView) {
        CGPoint point = CGPointMake((WIDTH - 25),NAVI_HEIGHT);
        NSArray *tempArr = _menuMoreDic[@"items"];
        _popView = [[XTPopView alloc] initWithOrigin:point Width:90 Height:40 * tempArr.count+10 Type:XTTypeOfUpRight Color:HEX(@"000000", 0.8)];
        NSMutableArray *dataA = @[].mutableCopy;
        NSMutableArray *imageA = @[].mutableCopy;
        for (NSDictionary *dic  in tempArr) {
            NSString *str = dic[@"type"];
            NSString *title = @"";
            NSString *imgStr = @"";
            if ([str isEqualToString:@"search"]){
                title = dic[@"params"][@"title"];
                imgStr = @"icon_search_white";
            }else if ([str isEqualToString:@"phone"]){
                title = NSLocalizedString(@"电话",nil);
                imgStr = @"btn_call_white";
                
            }else if ([str isEqualToString:@"share"]){
                title = NSLocalizedString(@"分享",nil);
                imgStr = @"icon_share_white";
            }else if ([str isEqualToString:@"text"]){
                title = dic[@"params"][@"title"];
                imgStr = @"icon_text_white";
            }
            [dataA addObject:title];
            [imageA addObject:imgStr];
        }
        _popView.dataArray = dataA;
        _popView.images = imageA;
        _popView.fontSize = 12;
        _popView.row_height = 40;
        _popView.titleTextColor = [UIColor whiteColor];
        _popView.delegate = self;
    }
    return _popView;
}
#pragma mark - pop的点击事件回调
- (void)selectIndexPathRow:(NSInteger)index
{
    [_popView removeFromSuperview];
    _popView = nil;
    if (index<0) {
        return;
    }
    NSDictionary *dic = _menuMoreDic[@"items"][index];
    if ([dic[@"type"] isEqualToString:@"share"]) {
        [self shareConfig:dic[@"params"]];
    }else if ([dic[@"type"] isEqualToString:@"phone"]){
        NSArray *arr = dic[@"params"][@"phone"];
        if (arr.count == 1) {//一个电话直接拨号
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",arr[0][@"phone"]]]];
        }else{//多个电话
            [self creatPhoneSheetWithArr:arr];
        }
        
    }else {
        [self jumpLink:dic[@"params"][@"link"] titleStr:dic[@"params"][@"title"]];
    }
    
}
#pragma mark - 网页调用原生的图片浏览器
-(void)previewImage:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.seeImageView showViewWithImgArr:dic[@"items"] index:[dic[@"index"] integerValue]];
    });
    
}
-(ZQSeeWebImageView *)seeImageView{
    if (!_seeImageView) {
        _seeImageView = [[ZQSeeWebImageView alloc]init];
    }
    return _seeImageView;
}
#pragma mark - 网页调用本地相册选择图片
-(void)chooseImage{
    NSLog(@"点击了选择图片");
}
#pragma mark - 网页获取坐标
-(void)getLocation{
    NSLog(@"点击了获取坐标");
}
-(void)goHome{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.navigationController.presentingViewController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    });
}
#pragma mark - 这是登录的方法
-(void)onLogin:(NSDictionary *)obj{
    loginSuccess_Url = obj[@"rebackurl"];
    //登录
    [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
}
#pragma mark - 这是调用原生支付的方法
-(void)onPayment:(NSDictionary *)obj{
    if ([JHUserModel shareJHUserModel].token) {
        [JHWaimaiMineViewModel postToGetUserInfoWithBlock:^(NSString *error) {
            order_id = obj[@"order_id"];
            self.pay_code = obj[@"code"];
            rebackurl = obj[@"rebackurl"];
            if ([obj[@"code"] length] == 0) {
                NSString *price = obj[@"amount"];
                 __weak typeof(self) weakSelf=self;
                MsgBlock block = ^(BOOL success ,NSString * msg){
                    if (success) {
                        if (rebackurl.length > 0) {
                            [weakSelf.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:rebackurl]]];
                        }
                    }else{
                        [weakSelf.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.url]]];
                    }
                };
                [weakSelf presentToNextVcWithVcName:@"JHPaySheetVC" params:@{@"superVC":weakSelf,@"order_id":order_id,@"amount":price,@"paySuccessBlock":block,@"is_show_friendPay":@(NO)}];
            }else{
                [self sureToPay];
            }
        }];
        
    }
    
    
}
#pragma mark - 这是调用原生支付的方法
-(void)onPaymentByCode:(NSDictionary *)obj{
    if ([JHUserModel shareJHUserModel].token) {
        SHOW_HUD_INVIEW(self.web);
         __weak typeof(self) weakSelf=self;
        [JHWaimaiMineViewModel postToGetUserInfoWithBlock:^(NSString *error) {
            order_id = obj[@"order_id"];
            self.pay_code = obj[@"code"];
            rebackurl = obj[@"rebackurl"];
            if ([obj[@"code"] length] == 0) {

                NSString *price = obj[@"amount"];
                MsgBlock block = ^(BOOL success ,NSString * msg){
                    if (success) {
                        if (rebackurl.length > 0) {
                            [weakSelf.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:rebackurl]]];
                        }
                    }else{
                        [weakSelf.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.url]]];
                    }
                };
                [weakSelf presentToNextVcWithVcName:@"JHPaySheetVC" params:@{@"superVC":weakSelf,@"order_id":order_id,@"amount":price,@"paySuccessBlock":block,@"is_show_friendPay":@(NO)}];
            }else{
                if([obj[@"from"] isEqualToString:@"card"]){
                    [YFPayTool getPayMessage:@"card" andDic:@{@"code":obj[@"code"],@"card_id":obj[@"card_id"]} andApi:@"client/payment/peicard" block:^(BOOL success, NSString *errStr) {
                        [weakSelf dealWithPayResult:success msg:errStr];
                    }] ;
                }else if([obj[@"from"] isEqualToString:@"spread"]){
                    [YFPayTool getPayMessage:@"spread" andDic:@{@"code":obj[@"code"],@"order_id":obj[@"order_id"],@"is_use_money":obj[@"is_use_money"]} andApi:@"client/payment/spread " block:^(BOOL success, NSString *errStr) {
                        [weakSelf dealWithPayResult:success msg:errStr];
                    }];
                }else if([obj[@"from"] isEqualToString:@"money"]){
                    [YFPayTool getPayMessage:@"money" andDic:@{@"code":obj[@"code"],@"amount":obj[@"amount"]} andApi:@"client/payment/money" block:^(BOOL success, NSString *errStr) {
                        [weakSelf dealWithPayResult:success msg:errStr];
                    }];
                }else if([obj[@"from"] isEqualToString:@"order"] ){
                    [YFPayTool getPayMessage:@"order" andDic:@{@"code":obj[@"code"],@"order_id":obj[@"order_id"],@"use_money":obj[@"use_money"]} andApi:@"client/payment/order" block:^(BOOL success, NSString *errStr) {
                        [self dealWithPayResult:success msg:errStr];
                    }];
                }else if([obj[@"from"] isEqualToString:@"hbPackage"]){
                    [YFPayTool getPayMessage:@"hbPackage" andDic:@{@"code":obj[@"code"],@"package_id":obj[@"package_id"]} andApi:@"client/payment/hbPackage" block:^(BOOL success, NSString *errStr) {
                        [weakSelf dealWithPayResult:success msg:errStr];
                    }];

                }else [weakSelf sureToPay];
            }
        }];
        
    }
}


// 确认支付
-(void)sureToPay{
    SHOW_HUD_INVIEW([UIApplication sharedApplication].keyWindow);
    NSDictionary *dic = @{@"order_id":order_id,@"code":self.pay_code,@"use_money":@(0).stringValue};
    if ([self.pay_code isEqualToString:@"alipay"]) {
        [YFPayTool AlipayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else if ([self.pay_code isEqualToString:@"wxpay"]){
        [YFPayTool WXPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }else if ([self.pay_code isEqualToString:@"money"]){
        [YFPayTool moneyPayApi:@"client/payment/order" params:dic block:^(BOOL success, NSString *errStr) {
            [self dealWithPayResult:success msg:errStr];
        }];
    }
    
}
// 处理支付结果
-(void)dealWithPayResult:(BOOL)success msg:(NSString *)msg{
    SHOW_HUD_INVIEW([UIApplication sharedApplication].keyWindow);
    HIDE_HUD_FOR_VIEW(self.web);
    [self showToastAlertMessageWithTitle:msg];
    if (success) {
        if (rebackurl.length > 0) {
            [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:rebackurl]]];
        }
    }
}
//是否展示返回按钮和标题
- (void)showBackBtnAndTitle:(id)obj{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = (NSDictionary *)obj;
        BOOL showBackBtn = [dic[@"showBack"] isEqualToString:@"1"];
        _closeBtn.hidden = !showBackBtn;
        NSString *title = dic[@"title"];
        if (title.length) {
            self.navigationItem.title = title;
        }
    });
}
#pragma mark - webView的缓存处理
-(void)clearCache{
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _web.delegate=nil;
    [_web stopLoading];
    _web=nil;
}

-(void)dealloc{
    _web.delegate=nil;
    [_web stopLoading];
    [self clearCache];
}

- (UIWebView *)web{
    if (_web == nil) {
        CGFloat height = 0;
        if ([(YFTabBarController *)self.tabBarController selectedIndex] == 1) {
            height = WMShopCartBottomViewH;
        }
        _web = [[UIWebView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - height)];
        _web.delegate = self;
        if (_url) {
            [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
    }
    return _web;
}


@end

