//
//  ZQTopChoseClassScrollView.h
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/6.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZQTopChoseClassScrollView : UIView
@property(nonatomic,assign)BOOL isBtnW_line;//选中指示的线的宽度是否等于按钮的宽度
@property (nonatomic, strong) NSArray *titleArray;//传入的标题数组
@property(nonatomic,assign)NSInteger index;//选择的分类索引(默认选择的是0)
@property(nonatomic,strong)UIFont *titleFont;//设置字体的大小
@property(nonatomic,copy)void(^clickBlock)(NSInteger tag);//选中后的回调
@end
