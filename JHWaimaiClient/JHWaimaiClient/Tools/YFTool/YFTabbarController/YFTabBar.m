//
//  YFTabBar.m
//  PresentAnimationTest
//
//  Created by ios_yangfei on 17/4/24.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import "YFTabBar.h"
#import "UIImage+Extension.h"

#define btn_Tag 200

@interface YFTabBar()
@property(nonatomic,assign)NSInteger lastTag;
@property(nonatomic,strong)NSMutableArray *barItems;
@property(nonatomic,weak)UIView *backView;
@end

@implementation YFTabBar
-(YFTabBarItem *)getItemWithIndex:(NSInteger)index{
    return self.barItems[index];
}

-(void)setUpViewWithTitleArr:(NSArray *)titleArr normalImageArr:(NSArray *)normalArr selectedArr:(NSArray *)selectedArr{
    
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self setShadowImage:[UIImage imageWithColor:LINE_COLOR]];

    UIView *view=[[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.backView = view;
    
    CGFloat btnW = self.bounds.size.width/titleArr.count;
    CGFloat btnH = self.bounds.size.height;
    for (int i=0; i<titleArr.count; i++) {
        YFTabBarItem *item = [[YFTabBarItem alloc] setUpWithFrame:CGRectMake(i*btnW, 0, btnW, btnH) normalImage:normalArr[i]  selectedImage:selectedArr[i]  title:titleArr[i] tag:i+btn_Tag];
        [view addSubview:item];
        if (i == 0) {
            item.selected=YES;
            self.lastTag=i+btn_Tag;
        }
        [self.barItems addObject:item];
    }
    
    [self addSubview:view];

}

#pragma mark ====== YFTabBarItemDelegate =======
-(void)onClickItem:(NSInteger)tag{
    
    if (self.lastTag == tag) return;
    self.selectedIndex = tag - btn_Tag;

}

// 显示特殊角标
-(void)setShowNew:(BOOL)showNew{
    //    YFTabBarItem *item=self.items[2];
    //    item.showNew=showNew;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    
    if (self.lastTag-btn_Tag != selectedIndex) {
        YFTabBarItem *item2 = self.barItems[self.lastTag - btn_Tag];
        item2.selected = NO;
    }
    _selectedIndex = selectedIndex;
    
    YFTabBarItem *item = self.barItems[selectedIndex];
    item.selected = YES;
    self.lastTag = selectedIndex+btn_Tag;
    
}

-(NSMutableArray *)barItems{
    if (_barItems==nil) {
        _barItems=[[NSMutableArray alloc] init];
    }
    return _barItems;
}


//重写hitTest方法，去监听中间按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //判断当前手指是否点击到中间按钮上，如果是，则响应按钮点击，其他则系统处理
    //首先判断当前View是否被隐藏了，隐藏了就不需要处理了
    if (self.isHidden == NO) {

        for (YFTabBarItem *btn in [self.backView subviews]) {//遍历tabbar的子控件
            //将当前tabbar的触摸点转换坐标系，转换到中间按钮的身上，生成一个新的点
            CGPoint newP = [self convertPoint:point toView:btn];
    
            if (newP.y > 40) return nil;
            
            //判断如果这个新的点是在中间按钮身上，那么处理点击事件最合适的view就是中间按钮
            if ( [btn pointInside:newP withEvent:event]) {
                if (self.clickBarItem) {
                    self.clickBarItem(btn.tag - btn_Tag);
                }
                return btn;
            }
        }
        
    }

    return [super hitTest:point withEvent:event];
}

@end
