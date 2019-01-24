//
//  YFCubeLab.h
//  LayoutTest
//
//  Created by ios_yangfei on 17/3/29.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickIndex)(NSInteger index);

@interface YFCubeLab : UILabel
@property(nonatomic,copy)ClickIndex clickIndex;
@property(nonatomic,strong)NSArray *textArr;
@property(nonatomic,assign)float duration;
@end
