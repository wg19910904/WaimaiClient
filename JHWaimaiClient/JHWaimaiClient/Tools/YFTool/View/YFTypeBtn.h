//
//  TypeBtn.h
//  RQCodeTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LeftImage,
    TopImage,
    RightImage,
    BottomImage,
    AllCenterImgageFront,
    AllCenterTitleFront,
    TitleCenter,
    NormalType
} ButtonType;


@interface YFTypeBtn : UIButton
// 设置btn的类型即图片的位置,默认是LeftImage类型
@property(nonatomic,assign)ButtonType btnType;
// 图片的margin
@property(nonatomic,assign)CGFloat imageMargin;
// 文字的margin
@property(nonatomic,assign)CGFloat titleMargin;
// 文字的对齐方式
@property(nonatomic,assign)NSTextAlignment titleAlignment;

@end
