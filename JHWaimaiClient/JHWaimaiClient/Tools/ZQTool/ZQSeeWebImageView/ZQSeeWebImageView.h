//
//  ZQSeeWebImageView.h
//  JHAppWebViewTest
//
//  Created by ijianghu on 2017/7/17.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQSeeWebImageView : UIView

/**
 展示的方法

 @param arr 图片的链接的数组
 @param index 选中的第几张图片
 */
-(void)showViewWithImgArr:(NSArray *)arr
                    index:(NSInteger)index;
@end
