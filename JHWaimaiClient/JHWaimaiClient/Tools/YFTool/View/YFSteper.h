//
//  YFSteper.h
//  JHMainTain
//
//  Created by jianghu3 on 16/2/27.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YFSteperDelegate <NSObject>

@optional
-(void)countNumChange:(int)count;
-(void)addCount;
-(void)subCount:(int)count;
@end

@interface YFSteper : UIView
@property(nonatomic,assign)int minCount;//最小值
@property(nonatomic,assign)int maxCount;//最大值
@property(nonatomic,assign)int currentCount;//目前的值
@property(nonatomic,assign)CGFloat countFont;
@property(nonatomic,weak)id<YFSteperDelegate> delegate;
@property(nonatomic,copy)NSString *subBtnImg;
@property(nonatomic,copy)NSString *addBtnImg;
@property(nonatomic,weak)UIButton *addBtn;

-(void)startAniamtion:(BOOL)show;

@end
