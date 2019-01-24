//
//  ContentView.h
//  EleDemo
//
//  Created by ios_yangfei on 17/5/11.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"

@protocol ContentViewDelegate <NSObject>

@optional
-(void)removeBehaviors;
-(void)panGestureDealWith:(UIPanGestureRecognizer *)pan;
-(void)velocityOfTableViewWhenTableIsTop:(CGFloat)speed;
@end

@interface ContentView : UIView

@property(nonatomic,assign)int currentIndex;// 当前的index

@property(nonatomic,strong)UITableView *currentTableView;

@property(nonatomic,weak)id<ContentViewDelegate> delegate;
// 需要传递给tableView的速度
@property(nonatomic,assign)float velocity;

//@property(nonatomic,weak)JHBaseVC *shopVC;

-(void)addViewController:(UIView *)view index:(NSInteger)index;

@end
