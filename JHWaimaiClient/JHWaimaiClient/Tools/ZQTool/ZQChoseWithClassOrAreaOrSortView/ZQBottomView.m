//
//  ZQSortView.m
//  Ceshi
//
//  Created by 洪志强 on 17/5/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQBottomView.h"
#import "ZQConditionCell.h"
#import "ZQConditonModel.h"
#import "ZQSaveSelecter.h"
#import "ZQAreaView.h"
#import "ZQClassView.h"
@interface ZQBottomView()<UITableViewDelegate,UITableViewDataSource>
{
    ZQConditonModel *oldModel;
}
@property(nonatomic,strong)UITableView * sortTab;
@property(nonatomic,strong)ZQClassView *classView;
@property(nonatomic,strong)ZQAreaView *areaView;
@property(nonatomic,strong)ZQConditionCell *cell;
@end
@implementation ZQBottomView

+(ZQBottomView *)showZQBottomViewWithFrame:(CGRect)frame inView:(UIView *)view
{
    ZQBottomView *currentView = [[ZQBottomView alloc]init];
    currentView.frame = frame;
    currentView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    currentView.alpha = 0;
    [view addSubview:currentView];
    [UIView animateWithDuration:0.25 animations:^{
        currentView.alpha = 1;
    }];
    [currentView addTarget:currentView action:@selector(clickRemove) forControlEvents:UIControlEventTouchUpInside];
    return currentView;
}
#pragma mark - 点击移除的方法
-(void)clickRemove{
    if (self.type == EBottomViewTypeSort) {
        [self hiddenSortView];
    }else if (self.type == EBottomViewTypeArea){
        [self hiddenAreaView];
    }else{
        [self hiddenClassView];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.removeBlock) {
            self.removeBlock();
        }
    }];
}
/**
 点击价格或者销量移除的方法
 */
-(void)clickRemoveForPrice{
    if (self.type == EBottomViewTypeSort) {
        [self hiddenSortView];
    }else if (self.type == EBottomViewTypeArea){
        [self hiddenAreaView];
    }else{
        [self hiddenClassView];
    }

}
#pragma mark - 添加分类的view
-(ZQClassView *)classView{
    if (!_classView) {
        _classView = [[ZQClassView alloc]init];
        _classView.frame = FRAME(0, 0,self.frame.size.width, 0);
        _classView.dataArr = _classArr;
        _classView.isShangCheng = _isShengCheng;
        _classView.isGoods = _isGoods;
        [self addSubview:_classView];
        __weak typeof (self)weakSelf = self;
        [_classView setRemoveBlock:^{
            [weakSelf clickRemove];
        }];
    }
    return _classView;
}
#pragma mark - 展示分类的方法
-(void)showClassView{
    BOOL isYes = YES;
    if (_sortTab) {
        [self hiddenSortView];
    }else if (_areaView) {
        [self hiddenAreaView];
    }else{
        isYes = NO;
    }
    if (isYes) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self classView];
            CGFloat h = _classArr.count *44>HEIGHT/2? HEIGHT/2:_classArr.count *44;
            [UIView animateWithDuration:0.25 animations:^{
                _classView.frame = FRAME(0, 0,self.frame.size.width,h);
            }];
        });
    }else{
        [self classView];
        CGFloat h = _classArr.count *44>HEIGHT/2? HEIGHT/2:_classArr.count *44;
        [UIView animateWithDuration:0.25 animations:^{
            _classView.frame = FRAME(0, 0,self.frame.size.width,h);
        }];
    }
    
}
#pragma mark - 隐藏分类的方法
-(void)hiddenClassView{
    [UIView animateWithDuration:0.25 animations:^{
         _classView.frame = FRAME(0, 0,self.frame.size.width,0);
    } completion:^(BOOL finished) {
        [_classView removeFromSuperview];
        _classView = nil;
    }];
}
-(void)setClassArr:(NSArray *)classArr{
    _classArr = classArr;
    if (self.type == EBottomViewTypeClass) {
        [self showClassView];
    }
}
#pragma mark - 添加区域的view
-(ZQAreaView *)areaView{
    if (!_areaView) {
        _areaView = [[ZQAreaView alloc]init];
        _areaView.frame = FRAME(0, 0,self.frame.size.width, 0);
        [self addSubview:_areaView];
        _areaView.isShangCheng = _isShengCheng;
        _areaView.dataArr = self.areaArr;
        __weak typeof (self)weakSelf = self;
        [_areaView setRemoveBlock:^{
            [weakSelf clickRemove];
        }];
    }
    return _areaView;
}
#pragma mark - 展示区域的方法
-(void)showAreaView{
    BOOL isYes = YES;
    if (_sortTab) {
        [self hiddenSortView];
    }else if (_classView) {
        [self hiddenClassView];
    }else{
        isYes = NO;
    }
    if (isYes) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self areaView];
            CGFloat h = _areaArr.count *44>HEIGHT/2? HEIGHT/2:_areaArr.count *44;
            [UIView animateWithDuration:0.25 animations:^{
                _areaView.frame = FRAME(0, 0,self.frame.size.width,h);
            }];
        });
    }else{
        [self areaView];
        CGFloat h = _areaArr.count *44>HEIGHT/2? HEIGHT/2:_areaArr.count *44;
        [UIView animateWithDuration:0.25 animations:^{
            _areaView.frame = FRAME(0, 0,self.frame.size.width,h);
        }];
    }
   
}
#pragma mark - 隐藏区域的方法
-(void)hiddenAreaView{
    [UIView animateWithDuration:0.25 animations:^{
        _areaView.frame = FRAME(0, 0,self.frame.size.width,0);
    } completion:^(BOOL finished) {
        [_areaView removeFromSuperview];
        _areaView = nil;
    }];
}
-(void)setAreaArr:(NSArray *)areaArr{
    _areaArr = areaArr;
    if (self.type == EBottomViewTypeArea) {
        [self showAreaView];
    }
}
#pragma mark - sortTab
-(UITableView *)sortTab{
    if (!_sortTab) {
        _sortTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) style:UITableViewStylePlain];
        _sortTab.delegate = self;
        _sortTab.dataSource = self;
        _sortTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sortTab.backgroundColor = [UIColor whiteColor];
        [self addSubview:_sortTab];
    }
    return _sortTab;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"ZQConditionCell";
    ZQConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[ZQConditionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    ZQConditonModel *model = _currentArr[indexPath.row];
    cell.text = model.title;
    cell.isSelector = model.isSelector;
    if (model.isSelector) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     oldModel.isSelector = NO;
     ZQConditonModel *model = _currentArr[indexPath.row];
     model.isSelector = YES;
     oldModel = model;
    [_sortTab reloadData];
    [self clickRemove];
//    [ZQSaveSelecter saveModel].isClass = NO;
//    [ZQSaveSelecter saveModel].isSub = NO;
//    [ZQSaveSelecter saveModel].indexP = nil;
//    [ZQSaveSelecter saveModel].isArea = NO;
//    [ZQSaveSelecter saveModel].isAreaSub = NO;
//    [ZQSaveSelecter saveModel].areaIndexP = nil;
    [ZQSaveSelecter saveModel].isSelector = YES;
    [ZQSaveSelecter saveModel].row = indexPath.row;
}
////具体是打开哪种条件筛选
//-(void)setType:(EBottomViewType)type{
//    _type = type;
//    switch (type) {
//        case 1://分类
//        {
//            if (_classArr.count > 0) {
//                [self showClassView];
//            }
//        }
//            break;
//        case 2://区域
//        {
//            if (_areaArr.count > 0) {
//                [self showAreaView];
//            }
//        }
//            break;
//        default://排序
//        {
//            if (self.currentArr.count >0) {
//                [self showSortView];
//            }
//        }
//            break;
//    }
//}
-(void)setCurrentArr:(NSArray *)currentArr{
    _currentArr = currentArr;
    if (self.type == EBottomViewTypeSort) {
       [self showSortView]; 
    }
}
//展示排序的按钮
-(void)showSortView{
    BOOL isYes = YES;
    if (_classView) {
        [self hiddenClassView];
    }else if (_areaView) {
        [self hiddenAreaView];
    }else{
        isYes = NO;
    }
    if (isYes) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sortTab];
             CGFloat h = _currentArr.count *44>HEIGHT/2? HEIGHT/2:_currentArr.count *44;
            [UIView animateWithDuration:0.25 animations:^{
                self.sortTab.frame = CGRectMake(0, 0, self.frame.size.width, h);
            }];
        });
    }else{
        [self sortTab];
         CGFloat h = _currentArr.count *44>HEIGHT/2? HEIGHT/2:_currentArr.count *44;
        [UIView animateWithDuration:0.25 animations:^{
            self.sortTab.frame = CGRectMake(0, 0, self.frame.size.width, h);
        }];
    }
    
}
-(void)hiddenSortView{
    [UIView animateWithDuration:0.25 animations:^{
        self.sortTab.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [_sortTab removeFromSuperview];
        _sortTab = nil;
    }];
}
@end
