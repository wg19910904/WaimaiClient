//
//  YFSlider.h
//  JHMainTain
//
//  Created by jianghu3 on 16/3/5.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSlider : UISlider
/**
 *  最低值
 */
@property(nonatomic,assign)float minNum;
@property(nonatomic,copy)NSString *thumbName;
@property(nonatomic,assign)float topY;
@property(nonatomic,assign)BOOL isShowTop;
@property(nonatomic,copy)NSString *topImgName;
@end
