//
//  ZQChoseWithClassOrAreaOrSortView.m
//  Ceshi
//
//  Created by 洪志强 on 17/5/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQChoseWithClassOrAreaOrSortView.h"
#import "ZQBottomView.h"
#import "ZQConditonModel.h"
#import "ZQSaveSelecter.h"
#import "ZQSaveSelecter.h"
#define CURRENT_WIDTH [[UIScreen mainScreen] bounds].size.width
#define CURRENT_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface ZQChoseWithClassOrAreaOrSortView()
@property(nonatomic,assign)EishaveRightBtnType currentType;
@property(nonatomic,strong)UIButton * rightBtn;//右边的按钮
@property(nonatomic,strong)ZQBottomView *bottomView;//排序的view
@property(nonatomic,strong)UIButton *oldBtn;//保存选中的按钮
@property(nonatomic,strong)NSMutableArray *sortArr;//排序的数组
@property(nonatomic,strong)NSMutableArray *classArr;//分类的数组
@property(nonatomic,strong)NSMutableArray *classShopArr;//商家分类的数组
@property(nonatomic,strong)NSMutableArray *areaArr;//区域的数组
@property(nonatomic,strong)NSMutableArray *topBtnArr;//顶部的数组
@end
@implementation ZQChoseWithClassOrAreaOrSortView
/**
 创建view
 
 @param type 是否有右边的按钮
 @return 返回创建的对象
 */
+(ZQChoseWithClassOrAreaOrSortView *)showViewWithType:(EishaveRightBtnType)type inView:(UIView *)view frame:(CGRect)frame{
    ZQChoseWithClassOrAreaOrSortView *currentView = [[ZQChoseWithClassOrAreaOrSortView alloc]init];
    currentView.frame = frame;
    currentView.currentType = type;
    currentView.backgroundColor = [UIColor whiteColor];
    [view addSubview:currentView];
    //添加三个按钮
    [currentView creatThreenBtn];
    //添加底部的分割线
    [currentView creatButtomLine];
    if (type == EishaveRightBtnTypeYes) {
        currentView.isCanClick = YES;
        [currentView rightBtn];
    }
    [currentView initData];
    return currentView;
}
-(void)initData{
    [ZQSaveSelecter saveModel].isClass = NO;
    [ZQSaveSelecter saveModel].isSub = NO;
    [ZQSaveSelecter saveModel].indexP = nil;
    [ZQSaveSelecter saveModel].isArea = NO;
    [ZQSaveSelecter saveModel].isAreaSub = NO;
    [ZQSaveSelecter saveModel].areaIndexP = nil;
    [ZQSaveSelecter saveModel].isSelector = NO;
    [ZQSaveSelecter saveModel].row = 0;
    //初始化数组
    _sortArr = @[].mutableCopy;
    _classArr = @[].mutableCopy;
    _areaArr = @[].mutableCopy;
    _classShopArr = @[].mutableCopy;
    //sort
    NSArray *sort_tempArr = @[NSLocalizedString(@"智能排序", nil),NSLocalizedString(@"距离最近", nil),NSLocalizedString(@"好评优先", nil),NSLocalizedString(@"人均最低", nil)];
    for (int i = 0; i < sort_tempArr.count; i ++) {
        ZQConditonModel *model = [[ZQConditonModel alloc]init];
        model.title = sort_tempArr[i];
        [self.sortArr addObject:model];
    }
    //分类
    NSArray *class_tempArr = @[NSLocalizedString(@"全部分类(888)", nil),NSLocalizedString(@"美食(7)", nil),NSLocalizedString(@"购物(666)", nil),NSLocalizedString(@"酒店(999)", nil),NSLocalizedString(@"生鲜(12)", nil),NSLocalizedString(@"休闲娱乐(6)", nil)];
    for (int i = 0; i < class_tempArr.count; i++) {
        ZQConditonModel *model = [[ZQConditonModel alloc]init];
        model.title = class_tempArr[i];
        if (i % 2 == 1) {
            NSArray *subTempArr =  @[NSLocalizedString(@"哈哈", nil),NSLocalizedString(@"哈哈", nil),NSLocalizedString(@"哈哈", nil),NSLocalizedString(@"哈哈", nil),NSLocalizedString(@"哈哈", nil)];
            for (int j = 0; j<subTempArr.count; j ++) {
                ZQConditonModel *subModel = [[ZQConditonModel alloc]init];
                subModel.title = subTempArr[j];
                [model.subArr addObject:subModel];
            }
        }
        [self.classArr addObject:model];
    }
    //商家的分类
    NSArray *tepArr = @[NSLocalizedString(@"食品", nil),NSLocalizedString(@"女装", nil),NSLocalizedString(@"鞋靴", nil),NSLocalizedString(@"箱包", nil),NSLocalizedString(@"女装", nil),NSLocalizedString(@"百货", nil)];
    for (int i = 0; i < tepArr.count; i ++) {
        ZQConditonModel *model = [[ZQConditonModel alloc]init];
        model.title = tepArr[i];
        [self.classShopArr addObject:model];
    }

    //区域
    NSArray *area_tempArr = @[NSLocalizedString(@"附近", nil),NSLocalizedString(@"蜀山区", nil),NSLocalizedString(@"庐阳区", nil),NSLocalizedString(@"瑶海区", nil),NSLocalizedString(@"包河区", nil),NSLocalizedString(@"经开区", nil),NSLocalizedString(@"政务区", nil),NSLocalizedString(@"滨湖区", nil),NSLocalizedString(@"新站区", nil)];
    for (int i = 0; i < area_tempArr.count; i++) {
        ZQConditonModel *model = [[ZQConditonModel alloc]init];
        model.title = area_tempArr[i];
        if (i % 2 == 1) {
            NSArray *subTempArr =  @[NSLocalizedString(@"嘻嘻", nil),NSLocalizedString(@"呼呼", nil),NSLocalizedString(@"哈哈", nil),NSLocalizedString(@"哒哒", nil),NSLocalizedString(@"嘟嘟", nil)];
            for (int j = 0; j<subTempArr.count; j ++) {
                ZQConditonModel *subModel = [[ZQConditonModel alloc]init];
                subModel.title = subTempArr[j];
                [model.subArr addObject:subModel];
            }
        }
        [self.areaArr addObject:model];
    }

}
-(void)setIsShangCheng:(BOOL)isShangCheng{
    _isShangCheng = isShangCheng;
    [self.areaArr removeAllObjects];
    NSArray *arr_tempArr = @[NSLocalizedString(@"全部", nil),NSLocalizedString(@"热销", nil),NSLocalizedString(@"上新", nil)];
    for (int i = 0; i < arr_tempArr.count; i ++) {
        ZQConditonModel *model = [[ZQConditonModel alloc]init];
        model.title = arr_tempArr[i];
        [self.areaArr addObject:model];
    }

}
-(NSMutableArray *)classShopArr{
    for (int i = 0; i < _classShopArr.count; i ++) {
        ZQConditonModel *model = _classShopArr[i];
        model.isSelector = NO;
        if ([ZQSaveSelecter saveModel].isSub && i == [ZQSaveSelecter saveModel].indexP.row) {
            model.isSelector = YES;
        }
    }
    return _classShopArr;
}
-(NSMutableArray *)sortArr{
    for (int i = 0; i < _sortArr.count; i ++) {
        ZQConditonModel *model = _sortArr[i];
        model.isSelector = NO;
        if ([ZQSaveSelecter saveModel].isSelector && i == [ZQSaveSelecter saveModel].row) {
            model.isSelector = YES;
        }
    }
    return _sortArr;
}
-(NSMutableArray *)classArr{
    for (int i = 0; i < _classArr.count; i ++) {
        ZQConditonModel *model = _classArr[i];
        model.isSelector = NO;
        if ([ZQSaveSelecter saveModel].isClass && i == [ZQSaveSelecter saveModel].indexP.section) {
            model.isSelector = YES;
        }
        for (int j = 0; j < model.subArr.count; j++) {
            ZQConditonModel *subModel = model.subArr[j];
            subModel.isSelector = NO;
            if ([ZQSaveSelecter saveModel].isSub && j == [ZQSaveSelecter saveModel].indexP.row && i == [ZQSaveSelecter saveModel].indexP.section){
                subModel.isSelector = YES;
            }
        }
    }

    return _classArr;
}
-(NSMutableArray *)areaArr{
    for (int i = 0; i < _areaArr.count; i ++) {
        if (_isShangCheng) {
            ZQConditonModel *model = _areaArr[i];
            model.isSelector = NO;
            if ([ZQSaveSelecter saveModel].isAreaSub && i == [ZQSaveSelecter saveModel].areaIndexP.row) {
                model.isSelector = YES;
            }
        }else{
            ZQConditonModel *model = _areaArr[i];
            model.isSelector = NO;
            if ([ZQSaveSelecter saveModel].isArea && i == [ZQSaveSelecter saveModel].areaIndexP.section) {
                model.isSelector = YES;
            }
            for (int j = 0; j < model.subArr.count; j++) {
                ZQConditonModel *subModel = model.subArr[j];
                subModel.isSelector = NO;
                if ([ZQSaveSelecter saveModel].isAreaSub && j == [ZQSaveSelecter saveModel].areaIndexP.row && i == [ZQSaveSelecter saveModel].areaIndexP.section){
                    subModel.isSelector = YES;
                }
            }
  
        }
  }

    return _areaArr;
}
#pragma mark - 创建三个按钮的方法
-(void)creatThreenBtn{
    CGFloat w = self.frame.size.width/3;
    if (self.currentType == EishaveRightBtnTypeYes) {
        w = (self.frame.size.width -50)/3;
    }
    NSArray *titleArr = @[NSLocalizedString(@"分类", nil),NSLocalizedString(@"区域", nil),NSLocalizedString(@"排序", nil)];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(w*i, 0, w, self.frame.size.height-0.5);
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:0.1 alpha:0.8] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:15/255.0 green:170/255.0 blue:10/255.0 alpha:1] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setImage:[UIImage imageNamed:@"icon-arrow-down"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon-arrow-up"] forState:UIControlStateSelected];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 2*14+btn.currentImage.size.width+25, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -(2*14+btn.currentImage.size.width-10), 0, 0);
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.topBtnArr addObject:btn];
        if (i == 2 && self.currentType == EishaveRightBtnTypeNo) {
            return;
        }
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(w-0.5, 10, 0.5, self.frame.size.height-20);
        line.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        [btn addSubview:line];
        
    }
}
-(NSMutableArray *)topBtnArr{
    if (!_topBtnArr) {
        _topBtnArr = @[].mutableCopy;
    }
    return _topBtnArr;
}
-(void)setTopTitleArr:(NSArray *)topTitleArr{
    _topTitleArr = topTitleArr;
    for (int i = 0 ; i < topTitleArr.count; i ++) {
        UIButton *btn = _topBtnArr[i];
        [btn setTitle:topTitleArr[i] forState:UIControlStateNormal];
        if (i == 2) {
            [btn setImage:[UIImage imageNamed:@"mall_btn_price_down"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"mall_btn_price_up"] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithWhite:0.1 alpha:0.8] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithWhite:0.1 alpha:0.8] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
 
        }
    }
}
#pragma mark - 点击按钮的方法
-(void)clickBtn:(UIButton *)sender{
    if (_oldBtn != sender) {
        _oldBtn.selected = NO;
    }
    sender.selected = !sender.selected;
    _oldBtn = sender;
    if (!sender.selected) {
        [_bottomView clickRemove];
        return;
    }
    switch (sender.tag) {
        case 0:
        {
            [self sortViewWithType:EBottomViewTypeClass];
        }
            break;
        case 1:
        {
            [self sortViewWithType:EBottomViewTypeArea];
        }
            break;
        default:
        {
            if (_isShangCheng) {
                [_bottomView clickRemoveForPrice];
                return;
            }
            [self sortViewWithType:EBottomViewTypeSort];
        }
            break;
    }
}
#pragma mark - 添加底部的分割线
-(void)creatButtomLine{
    UIView *line_b = [[UIView alloc]init];
    line_b.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    line_b.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    [self addSubview:line_b];
}
#pragma mark - 右边的按钮
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        _rightBtn.frame = CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height - 0.5);
        [_rightBtn setImage:[UIImage imageNamed:@"btn_switch_two_yes"] forState:UIControlStateSelected];
        [_rightBtn setImage:[UIImage imageNamed:@"btn_switch_dan"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}
-(void)setIsCanClick:(BOOL)isCanClick{
    _isCanClick = isCanClick;
    _rightBtn.enabled = isCanClick;
    if (isCanClick) {
        [_rightBtn setImage:[UIImage imageNamed:@"btn_switch_two_yes"] forState:UIControlStateNormal];
    }else{
        [_rightBtn setImage:[UIImage imageNamed:@"btn_switch_two_no"] forState:UIControlStateNormal];
    }
}
#pragma mark - 点击右边的方法
-(void)clickRightBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_bottomView clickRemove];
    if (self.myBlock) {
        self.myBlock(sender.selected);
    }
}
#pragma mark - 排序的按钮
-(ZQBottomView *)sortViewWithType:(EBottomViewType)type{
    if (!_bottomView) {
        _bottomView =  [ZQBottomView showZQBottomViewWithFrame:CGRectMake(0, 149,CURRENT_WIDTH, CURRENT_HEIGHT-149) inView:self.superview];
        _bottomView.isShengCheng = _isShangCheng;
        _bottomView.isGoods = _isGoods;
        __weak typeof(self) weakSelf=self;
        [_bottomView setRemoveBlock:^{
            weakSelf.oldBtn.selected = NO;
            weakSelf.bottomView = nil;
        }];
    }
    _bottomView.type = type;
    if (type == EBottomViewTypeSort) {
         _bottomView.currentArr = self.sortArr;
    }else if (type == EBottomViewTypeArea){
        _bottomView.areaArr = self.areaArr;
    }else{
        if (_isShangCheng && !_isGoods) {
            _bottomView.classArr = _classShopArr;
        }else{
            _bottomView.classArr = _classArr;
        }
        
    }
   
    return _bottomView;
}
-(void)clickRemove{
    [_bottomView clickRemove];
}
@end
