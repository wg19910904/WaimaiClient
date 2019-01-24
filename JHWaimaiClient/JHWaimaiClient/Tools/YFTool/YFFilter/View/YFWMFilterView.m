//
//  YFWMFilterView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "YFWMFilterView.h"
#import "FilterTableView.h"
#import "FilterModel.h"
#import "FilterAddressModel.h"

#import "FilterCollectionView.h"

#define btn_tag 200

@interface YFWMFilterView ()
@property(nonatomic,weak)UIWindow *currentW;
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,weak)YFTypeBtn *selectedBtn;
@property(nonatomic,strong)FilterTableView *cateTableView;
@property(nonatomic,strong)FilterTableView *sortTableView;
@property(nonatomic,strong)FilterCollectionView *filterCollectionView;

@end

@implementation YFWMFilterView

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)arr{
    
    if (self = [super initWithFrame:frame]) {
        
        [self configUIWith:arr];
        //接收到关闭的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(filterTableHidden)
                                                     name:KNotification_close_fenlei_shaixuan
                                                   object:nil];
    }
    
    return self;
}

-(void)configUIWith:(NSArray *)titleArr{
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, NAVI_HEIGHT+44, WIDTH, 0);
    control.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [control addTarget:self action:@selector(filterTableHidden) forControlEvents:UIControlEventTouchUpInside];
    _currentW = [UIApplication sharedApplication].delegate.window;
    [_currentW addSubview:control];
    self.control=control;
    control.alpha = 0;
    //添加毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-NAVI_HEIGHT-44);
    effectView.userInteractionEnabled = NO;
    [_control addSubview:effectView];
    
    NSArray *imgArr = @[@"btn_arrow_b_small",@"btn_arrow_b_small",@"btn_choose_select"];
    NSArray *selectImagArr = @[@"btn_arrow_t_small",@"btn_arrow_t_small",@"btn_choose_select"];
    for (NSInteger i=0; i<titleArr.count; i++) {
        YFTypeBtn *btn = [YFTypeBtn new];
        btn.btnType = TitleCenter;
        btn.tag = 200+i;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = WIDTH/3*i;
            make.width.offset = WIDTH/3;
            make.height.offset = 44;
            make.top.offset = 0;
        }];
        [btn setTitle:titleArr[i] forState:0];
        [btn setTitleColor:HEX(@"242424", 1.0) forState:0];
        btn.titleLabel.font = FONT(15);
        [btn setImage:IMAGE(imgArr[i]) forState:0];
        [btn setImage:IMAGE(selectImagArr[i]) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickTable:) forControlEvents:(UIControlEventTouchUpInside)];
    }

    [_control addSubview:self.cateTableView];
    [_control addSubview:self.sortTableView];
    [_control addSubview:self.filterCollectionView];
    

}
- (void)updateTitle:(NSArray *)titleArr{
    NSArray <YFTypeBtn *>*btnArr = @[[self viewWithTag:200],[self viewWithTag:201],[self viewWithTag:202]];
    for (int i = 0; i < 3; i++) {
        YFTypeBtn *tem_btn = btnArr[i];
        [tem_btn setTitle:titleArr[i] forState:0];
    }
}


-(void)clickTable:(YFTypeBtn *)btn{
    if (self.targetVC) {
        [self.targetVC clickFenlei:btn];
        return;
    }
    
    if (btn == self.selectedBtn) {// 不展示选择界面
        [self filterTableHidden];
        btn.titleLabel.font = FONT(15);
    }else{
        [_currentW bringSubviewToFront:self.control];
        self.selectedBtn.selected = NO;
        self.selectedBtn.titleLabel.font = FONT(15);
        btn.selected = YES;
        self.selectedBtn = btn;
        btn.titleLabel.font = B_FONT(15);
        self.control.height = HEIGHT-NAVI_HEIGHT-44;
        
        [UIView animateWithDuration:0.1 animations:^{
            self.control.alpha = 1;
        }];
        
        [self startAnimation];
    }
}

-(void)startAnimation{
    CGFloat height = 0;
   
    if (self.selectedBtn.tag - btn_tag == 0) {
        self.sortTableView.height = 0;
        self.filterCollectionView.height = 0;
        height = self.firstArr.count > 8 ? 44 * 8: MAX(44*3,44*self.firstArr.count);
        [UIView animateWithDuration:0.25 animations:^{
            self.cateTableView.height = height;
        }];
        [self.cateTableView reloadView];
    }else if (self.selectedBtn.tag - btn_tag == 1){
        self.filterCollectionView.height = 0;
        self.cateTableView.height = 0;
        height = self.secondArr.count > 8 ? 44 * 8: MAX(44*3,44*self.secondArr.count);
        [UIView animateWithDuration:0.25 animations:^{
            self.sortTableView.height = height;
        }];
        
        [self.sortTableView reloadView];
    }else{
        
        self.cateTableView.height = 0;
        self.sortTableView.height = 0;
        height = 100;
        [UIView animateWithDuration:0.25 animations:^{
            self.filterCollectionView.height = height;
        }];
        [self.filterCollectionView reloadCollectionViews];
    }
        

}

-(void)filterTableHidden{
    self.selectedBtn.selected = NO;
    self.selectedBtn.titleLabel.font = FONT(15);
    self.selectedBtn = nil;
    [UIView animateWithDuration:0.15 animations:^{
        self.cateTableView.height = 0;
        self.sortTableView.height = 0;
        self.filterCollectionView.height = 0;
        self.control.alpha = 0;
    } completion:^(BOOL finished) {
        self.control.height = 0;
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_Home_shaixuanDisappear
                                                        object:nil];
}

#pragma mark ======Setter=======

-(void)setFirstArr:(NSArray *)firstArr{
    _firstArr = firstArr;
    
    self.cateTableView.leftArr = firstArr;
    __weak typeof(self) weakSelf=self;
    _cateTableView.chooseBlock = ^(NSInteger left,NSInteger right){
        NSString *title ;
        FilterModel *cate = firstArr[left];
        if (right >= 0) {
            cate = cate.childrens[right];
        }
        title = cate.title;
        title = [NSString stringWithFormat:@"%@   ",title];
        if (weakSelf.chooseFilter) {
            weakSelf.chooseFilter(cate.cate_id,@"",@"",@"",@"",1,
                                  title,@"",@"");
        }
        [weakSelf.selectedBtn setTitle:title
                              forState:UIControlStateNormal];
        [weakSelf filterTableHidden];
    };
    
}

-(void)setSecondArr:(NSArray *)secondArr{
    _secondArr = secondArr;
    __weak typeof(self) weakSelf=self;
    
    NSArray * arr = @[@"",@"juli",@"score",@"sales",@"price",@"ptime"];
    self.sortTableView.leftArr = secondArr;
    _sortTableView.chooseBlock = ^(NSInteger left,NSInteger right){
        NSString *title = secondArr[left];
        title = [NSString stringWithFormat:@"%@   ",title];
        if (weakSelf.chooseFilter) {
             weakSelf.chooseFilter(@"",arr[left],@"",@"",@"",2,
                                   @"",title,@"");
        }
        [weakSelf.selectedBtn setTitle:title
                              forState:UIControlStateNormal];
        [weakSelf filterTableHidden];
    };
}

-(void)setThirdArr:(NSArray *)thirdArr{
    _thirdArr = thirdArr;
    NSArray *firstArr = @[@"",@"roof_pei",@"shop_pei"];
    NSArray *secondArr = @[@"",@"manjian",@"manfan",@"youhui_first",@"coupon"];
    NSArray *threeArr = @[@"",@"is_new",@"online_pay",@"free_pei",@"zero_amount"];
    self.filterCollectionView.firstArr =@[NSLocalizedString(@"不限", nil),NSLocalizedString(@"平台送", nil),NSLocalizedString(@"商家送", nil)];
    self.filterCollectionView.secondArr =@[NSLocalizedString(@"满减优惠", nil),NSLocalizedString(@"满返优惠", nil),NSLocalizedString(@"首单优惠", nil),NSLocalizedString(@"进店领劵", nil)];
    self.filterCollectionView.thirdArr =@[NSLocalizedString(@"新店开业", nil),NSLocalizedString(@"在线支付", nil),NSLocalizedString(@"免配送费", nil),NSLocalizedString(@"¥0起送",nil)];
    __weak typeof(self) weakSelf=self;
    _filterCollectionView.chooseBlock = ^(NSInteger first,NSInteger second,NSInteger third){
        if (weakSelf.chooseFilter) {
            weakSelf.chooseFilter(@"",@"",firstArr[first],secondArr[second+1],threeArr[third+1],3,
                                  @"",@"",@"");
        }
        [weakSelf filterTableHidden];
    };
    self.filterCollectionView.height = 100;
    self.filterCollectionView.height = 0;
}

#pragma mark ======懒加载=======
-(FilterTableView *)cateTableView{
    if (_cateTableView==nil) {
        _cateTableView=[[FilterTableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0)];
        _cateTableView.filterType = FilterTwoTable;
        _cateTableView.kindType = 0;
        _cateTableView.clipsToBounds = YES;
    }
    return _cateTableView;
}

-(FilterTableView *)sortTableView{
    if (_sortTableView==nil) {
        _sortTableView=[[FilterTableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0)];
        _sortTableView.filterType = FilterOneTable;
        _sortTableView.kindType = 2;
        _sortTableView.clipsToBounds = YES;
    }
    return _sortTableView;
}

-(FilterCollectionView *)filterCollectionView{
    if (_filterCollectionView==nil) {
        _filterCollectionView= [[FilterCollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
        _filterCollectionView.clipsToBounds = YES;
    }
    return _filterCollectionView;
}
#pragma mark ======获取筛选条件的数组=======
-(void)getData{
    NSDictionary *configDic = [UserDefaults objectForKey:@"appInfo"];
    NSArray *cateArr = [FilterModel mj_objectArrayWithKeyValuesArray:configDic[@"waimai_cates"]];
    self.firstArr = cateArr;
    self.secondArr = @[NSLocalizedString(@"智能排序", nil),NSLocalizedString(@"距离最近", nil),NSLocalizedString(@"评分最高", nil),NSLocalizedString(@"销量最高", nil),NSLocalizedString(@"起送价最低", nil),NSLocalizedString(@"最早送达", nil)];
    self.thirdArr = @[];
    [self dealwithFirstSelectedType];
}

#pragma mark ======处理预设的选中=======
-(void)dealwithFirstSelectedType{
    if (_firstSelectedType.length == 0 || !_firstSelectedType || self.firstArr.count == 0) {
        return;
    }
    
    NSInteger leftIndex = -1;
    NSInteger rightIndex = -1;
    NSString *title = @"";
    for (FilterModel *cate in self.firstArr) {
        if ([cate.cate_id isEqualToString:_firstSelectedType]) {
            leftIndex = [self.firstArr indexOfObject:cate];
            title = cate.title;
            continue;
        }else{
            if (cate.childrens.count == 0) {
                continue;
            }else{
                for (FilterModel *sub in cate.childrens) {
                    if ([sub.cate_id isEqualToString:_firstSelectedType]) {
                        leftIndex = [self.firstArr indexOfObject:cate];
                        rightIndex = [cate.childrens indexOfObject:sub];
                        title = sub.title;
                        continue;
                    }
                }
            }
        }
    }
    if (leftIndex<0) {
        return;
    }
    FilterModel *cate = self.firstArr[leftIndex];
    YFTypeBtn *btn = [self viewWithTag:btn_tag];
    self.cateTableView.rightArr = cate.childrens;
    self.cateTableView.leftSelectedIndex = leftIndex;
    self.cateTableView.rightSelectedIndex = rightIndex;
    title = [NSString stringWithFormat:@"%@   ",title];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
