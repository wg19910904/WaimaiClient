//
//  ZQNoteImageVerifyView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/29.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQNoteImageVerifyView : UIControl
/**
 获取图形验证码的api
 */
@property(nonatomic,copy)NSString *getCodeApi;
/**
 验证图形输入是否正确的接口
 */
@property(nonatomic,strong)NSString *verifyApi;
/**
 验证的接口需要的参数值
 */
@property(nonatomic,strong)NSString *phone;
/**
 图形验证成功的block
 */
@property(nonatomic,copy)void(^successBlock)(void);
/**
 图形验证失败的block
 */
@property(nonatomic,copy)void(^failBlock)(NSString *err);
-(void)showAnimation;//展示
@end
