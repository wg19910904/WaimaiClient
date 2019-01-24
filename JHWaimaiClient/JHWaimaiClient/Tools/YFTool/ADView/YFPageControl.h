//
//  YFPageControl.h
//
//  Created by ios_yangfei on 17/4/17.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFPageControl : UIView

// 每个dot的间距
@property(nonatomic,assign)CGFloat interSpace;
// 每个dot的宽度
@property(nonatomic,assign)CGFloat dotWidth;
// 每个dot的高度
@property(nonatomic,assign)CGFloat dotHeight;
// 选中的颜色
@property(nonatomic,strong)UIColor *currentPageIndicatorTintColor;
// 默认的颜色
@property(nonatomic,strong)UIColor *pageIndicatorTintColor;
// dot的个数
@property(nonatomic,assign)NSInteger numberOfPages;
// 当前选中的dot，从0开始
@property(nonatomic,assign)NSInteger currentPage;

@end
