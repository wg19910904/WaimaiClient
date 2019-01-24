//
//  YFStartView.h
//  PresentAnimationTest
//
//  Created by ios_yangfei on 17/4/19.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YFStarViewFull,// 只显示完整的星星
    YFStarViewHalf,// 可以显示一半的星星
    YFStarViewFloat,// 可以显示小数的星星
} YFStarViewType;

@interface YFStartView : UIView

// 全部星星的个数
@property(nonatomic,assign)int fullStarNum;
// 当前的评分
@property(nonatomic,assign)float currentStarScore;
// 背景星星的图片
@property(nonatomic,copy)NSString *backStar;
// 评分星星的图片
@property(nonatomic,copy)NSString *topStar;
// 星星显示的类型
@property(nonatomic,assign)YFStarViewType starType;
// 星星之间的间距
@property(nonatomic,assign)float interSpace;

@property(nonatomic,assign)CGSize imgSize;

@end
