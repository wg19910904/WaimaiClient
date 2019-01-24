//
//  JHWaimaiOrderPregresswebVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderPregresswebVC.h"

@interface JHWaimaiOrderPregresswebVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webV;
@end

@implementation JHWaimaiOrderPregresswebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"订单状态", nil);
    [self webV];
    SHOW_HUD
}
#pragma mark - web
-(UIWebView *)webV{
    if (!_webV) {
        _webV = [[UIWebView alloc]init];
        _webV.delegate = self;
        NSURL *url = [NSURL URLWithString:_urlStr];
        [_webV loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:_webV];
        [_webV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset = 0;
            make.top.offset = NAVI_HEIGHT;
        }];
    }
    return _webV;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    HIDE_HUD
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    HIDE_HUD
    NSLog(@"error:%@",error);
}
@end
