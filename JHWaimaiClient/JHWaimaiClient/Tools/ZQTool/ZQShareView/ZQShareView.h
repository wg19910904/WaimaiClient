//
//  ZQShareView.h
//  PopUpView
//
//  Created by 洪志强 on 17/5/2.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
@interface ZQShareView : UIControl
@property(nonatomic,weak)JHBaseVC *superVC;
@property(nonatomic,copy)NSString *shareStr;
@property(nonatomic,copy)NSString *shareTitle;
@property(nonatomic,copy)NSString *shareUrl;
@property(nonatomic,copy)NSString *shareImgName;
/**
 *  分享的是不是网络图片
 */
@property(nonatomic,assign)BOOL isUrlImg;

#pragma mark ====== 小程序分享需要 =======
@property(nonatomic,assign)BOOL is_miniProgrammar;// 是不是小程序分享
@property(nonatomic,copy)NSString *pagePath;// 小程序分享的页面路径
@property(nonatomic,copy)NSString *userName;// 小程序的原始id
@property(nonatomic,strong)UIImage *mini_shareImg;// 分享的图片

@property(nonatomic,copy)MsgBlock shareResultBlock;


-(instancetype)init;
/**
 展示的动画
 */
-(void)showAnimation;

@end
