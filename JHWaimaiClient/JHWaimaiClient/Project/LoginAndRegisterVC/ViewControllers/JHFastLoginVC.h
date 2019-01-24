//
//  JHFastLoginVC.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/4/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHFastLoginVC : JHBaseVC
@property(nonatomic,assign)BOOL bindWX;//是否是微信绑定
@property(nonatomic,copy)NSString *wx_openid;
@property(nonatomic,copy)NSString *wx_unionid;
@property(nonatomic,copy)NSString *wx_nickname;
@property(nonatomic,copy)NSString *wx_headimgurl;
@end
