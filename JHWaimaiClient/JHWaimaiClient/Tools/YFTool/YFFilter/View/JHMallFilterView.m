//
//  JHMallFilterView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/8/21.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHMallFilterView.h"
#import "YFTypeBtn.h"
#import "FilterTableView.h"
#import "FilterModel.h"
#import "FilterAddressModel.h"

#define btn_tag 200

@interface JHMallFilterView ()
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,weak)YFTypeBtn *selectedBtn;
@property(nonatomic,strong)FilterTableView *cateTableView;
@property(nonatomic,strong)FilterTableView *sortTableView;
@property(nonatomic,assign)BOOL goodTypeSelected;// 商品时表格的type类型，单双行
@property(nonatomic,weak)UIButton *chageTableTypeBtn;
@property(nonatomic,assign)NSInteger goodLastSelected;// 存储上次商品选择的排序条件
@property(nonatomic,assign)NSInteger shopLastSelected;// 存储上次商家选择的排序条件
@property(nonatomic,weak)UIButton *priceOrAmountBtn;
@property(nonatomic,assign)BOOL price_selected;// 价格
@property(nonatomic,assign)BOOL sales_selected;// 销量
@property(nonatomic,assign)BOOL choose_good_sort_table;
@property(nonatomic,assign)BOOL choose_shop_sort_table;
@end

@implementation JHMallFilterView

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)arr{
    
    if (self = [super initWithFrame:frame]) {
        [self configUIWith:arr];
    }
    
    return self;
}

-(void)configUIWith:(NSArray *)titleArr{

    self.choose_good_sort_table = YES;
    self.choose_shop_sort_table = YES;
    
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, 0);
    control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    [control addTarget:self action:@selector(filterTableHidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    self.control=control;
    control.alpha = 0;
    
    UIButton *chageTableTypeBtn = [UIButton new];
    chageTableTypeBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:chageTableTypeBtn];
    [chageTableTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=0;
        make.top.offset=0;
        make.width.offset=44;
        make.height.offset=44;
    }];
    [chageTableTypeBtn addTarget:self action:@selector(changeTableListType) forControlEvents:UIControlEventTouchUpInside];
    self.chageTableTypeBtn = chageTableTypeBtn;
    
    CGFloat btnW = (WIDTH-44)/(titleArr.count);
    for (NSInteger i=0; i<titleArr.count; i++) {
        
        YFTypeBtn * btn = [YFTypeBtn new];
        [self addSubview:btn];
        btn.backgroundColor = [UIColor whiteColor];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=btnW * i;
            make.top.offset=0;
            make.width.offset=btnW;
            make.height.offset=44;
        }];
        btn.titleLabel.font = FONT(14);
        btn.btnType = AllCenterTitleFront;
        btn.imageMargin = -5;
        btn.tag = btn_tag + i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        if (i == 2) {
            self.priceOrAmountBtn = btn;
            [btn setImage:[UIImage imageNamed:@"mall_btn_price"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"mall_btn_price"] forState:UIControlStateSelected];
        }else{
            [btn setImage:IMAGE(@"btn_arrow_d") forState:UIControlStateNormal];
            [btn setImage:IMAGE(@"btn_arrow_up") forState:UIControlStateSelected];
            [btn setTitleColor:THEME_COLOR_Alpha(1.0) forState:UIControlStateSelected];
        }
        
        [btn addTarget:self action:@selector(clickTable:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView=[UIView new];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=btnW * (i+1) - 0.5;
            make.top.offset=8;
            make.width.offset=1;
            make.height.offset=44-16;
        }];
        lineView.backgroundColor=LINE_COLOR;
        
    }
    
    UIView *lineView=[UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UIView *lineView1=[UIView new];
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=43;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView1.backgroundColor=LINE_COLOR;
    
    [self addSubview:self.cateTableView];
    [self addSubview:self.sortTableView];

}

-(void)clickTable:(YFTypeBtn *)btn{
    
    if (btn == self.selectedBtn) {// 不展示选择界面
        if (btn.tag - btn_tag != 2) {
            [self filterTableHidden];
        }else{
            btn.selected = !btn.isSelected;
            self.selectedBtn = btn;
            [self startAnimation];
        }
        
    }else{
        if (self.firstArr.count == 0) {
            [self getData];
        }
        if (self.selectedBtn.tag - btn_tag != 2) {
            self.selectedBtn.selected = NO;
        }
        btn.selected = !btn.isSelected;
        self.selectedBtn = btn;

        if (self.selectedBtn.tag - btn_tag != 2) {
            self.control.height = HEIGHT;
            [UIView animateWithDuration:0.1 animations:^{
                self.control.alpha = 1;
            }];
            self.frame = FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT -NAVI_HEIGHT);
        }else{
            self.frame = FRAME(0, NAVI_HEIGHT, WIDTH, 44);
        }

        [self startAnimation];

    }
    
    if (btn.tag - btn_tag == 2) {
        self.isShop ? (self.sales_selected = self.selectedBtn.selected) : (  self.price_selected = self.selectedBtn.selected);
    }
    
}

-(void)startAnimation{
    CGFloat height = 0;
    if (self.selectedBtn.tag - btn_tag == 0) {
        self.sortTableView.height = 0;
        height = self.firstArr.count > 8 ? 44 * 8: 44 * self.firstArr.count;
        [UIView animateWithDuration:0.25 animations:^{
            self.cateTableView.height = height;
        }];
        [self.cateTableView reloadView];
    }else if (self.selectedBtn.tag - btn_tag == 1){
        self.cateTableView.height = 0;
        height = self.secondArr.count > 8 ? 44 * 8: 44 * self.secondArr.count;
        [UIView animateWithDuration:0.25 animations:^{
            self.sortTableView.height = height;
        }];
        [self.sortTableView reloadView];
    }else{
        
        [self.priceOrAmountBtn setImage:[UIImage imageNamed:@"mall_btn_price_down"] forState:UIControlStateNormal];
        [self.priceOrAmountBtn setImage:[UIImage imageNamed:@"mall_btn_price_up"] forState:UIControlStateSelected];
        [UIView animateWithDuration:0.15 animations:^{
            self.cateTableView.height = 0;
            self.sortTableView.height = 0;
            self.control.alpha = 0;
        } completion:^(BOOL finished) {
            self.control.height = 0;
        }];
        
        if (self.chooseFilter) {
            self.sortTableView.leftSelectedIndex = -1;
            NSString *str ;
            if (self.isShop) {
                self.shopLastSelected = -1;
                str = self.selectedBtn.selected ? @"s_up" : @"s_down";
                self.sales_selected = self.selectedBtn.isSelected;
                self.choose_shop_sort_table = NO;
            }else{
                self.goodLastSelected = -1;
                str = self.selectedBtn.selected ? @"p_up" : @"p_down";
                self.price_selected = self.selectedBtn.isSelected;
                self.choose_good_sort_table = NO;
            }
            self.chooseFilter(str,nil,2);
        }
    }
 
}

-(void)filterTableHidden{
    
    self.selectedBtn.selected = NO;
    self.selectedBtn = nil;
    
    self.frame = FRAME(0, NAVI_HEIGHT, WIDTH, 44);
    [UIView animateWithDuration:0.15 animations:^{
        self.cateTableView.height = 0;
        self.sortTableView.height = 0;
        self.control.alpha = 0;
    } completion:^(BOOL finished) {
        self.control.height = 0;
    }];
    
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
        if (weakSelf.chooseFilter) {
            weakSelf.chooseFilter(cate.cate_id,nil,1);
        }
        
        [weakSelf.selectedBtn setTitle:title forState:UIControlStateNormal];
        [weakSelf filterTableHidden];
    };
    
}

-(void)setSecondArr:(NSArray *)secondArr{
    _secondArr = secondArr;
    __weak typeof(self) weakSelf=self;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in secondArr) {
        [arr addObject:dic[@"title"]];
    }
    _sortTableView.leftArr = arr.copy;
    _sortTableView.chooseBlock = ^(NSInteger left,NSInteger right){
        NSDictionary *dic = secondArr[left];
        if (weakSelf.chooseFilter) {
            weakSelf.priceOrAmountBtn.selected = NO;
            [weakSelf.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price") forState:UIControlStateNormal];
            [weakSelf.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price") forState:UIControlStateSelected];
            if (weakSelf.isShop) {
                weakSelf.sales_selected = NO;
                weakSelf.choose_shop_sort_table = YES;
            }else{
                weakSelf.price_selected = NO;
                weakSelf.choose_good_sort_table = YES;
            }
            weakSelf.chooseFilter(dic[@"cate_id"],nil,2);
        }
        [weakSelf filterTableHidden];
    };
    
}

#pragma mark ======懒加载=======
-(FilterTableView *)cateTableView{
    if (_cateTableView==nil) {
        _cateTableView=[[FilterTableView alloc] initWithFrame:FRAME(0, 44, WIDTH, 0)];
        _cateTableView.filterType = FilterTwoTable;
        _cateTableView.kindType = 0;
    }
    return _cateTableView;
}

-(FilterTableView *)sortTableView{
    if (_sortTableView==nil) {
        _sortTableView=[[FilterTableView alloc] initWithFrame:FRAME(0, 44, WIDTH, 0)];
        _sortTableView.filterType = FilterOneTable;
        _sortTableView.kindType = 2;
    }
    return _sortTableView;
}

#pragma mark ======获取筛选条件的数组=======
-(void)getData{
    
    __weak typeof(self) weakSelf=self;
    NSString *api = @"client/mall/shop/cates";
    [HttpTool postWithAPI:api withParams:@{} success:^(id json) {
        
        NSLog(@"商城分类列表 =======  %@",json);
        if (ISPostSuccess) {
            
            NSArray *cateArr = [FilterModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
//            NSArray *areaArr = [FilterAddressModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"area_items"]];
            
            weakSelf.firstArr = cateArr;
            [weakSelf dealwithFirstSelectedType];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
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
    [btn setTitle:title forState:UIControlStateNormal];
}

#pragma mark ====== 改变标的样式 =======
-(void)changeTableListType{
    self.chageTableTypeBtn.selected = !self.chageTableTypeBtn.isSelected;
    if (self.changeTableType) {
        self.changeTableType(self.chageTableTypeBtn.selected);
    }
}

-(void)setIsShop:(BOOL)isShop{
    _isShop = isShop;
    [self filterTableHidden];
    if (isShop) {
        NSArray *orderArr = @[@{@"title":NSLocalizedString(@"智能排序", NSStringFromClass([self class])),@"cate_id":@"default",},
                              @{@"title":NSLocalizedString(@"新店开业", NSStringFromClass([self class])),@"cate_id":@"new",},
                              @{@"title":NSLocalizedString(@"关注最多", NSStringFromClass([self class])),@"cate_id":@"collects",}];
        self.secondArr = orderArr;
        if (self.shopLastSelected == -1 || !self.choose_shop_sort_table) {
            [self.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price_down") forState:UIControlStateNormal];
            [self.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price_up") forState:UIControlStateSelected];
        }else{
            [self.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price") forState:UIControlStateNormal];
            [self.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price") forState:UIControlStateSelected];
        }
        self.goodLastSelected = self.sortTableView.leftSelectedIndex;
        self.sortTableView.leftSelectedIndex = self.shopLastSelected;
        self.chageTableTypeBtn.userInteractionEnabled = NO;
        [self.chageTableTypeBtn setImage:IMAGE(@"btn_switch_two_no") forState:UIControlStateNormal];
        [self.chageTableTypeBtn setImage:IMAGE(@"btn_switch_two_no") forState:UIControlStateSelected];
        [self.priceOrAmountBtn setTitle:NSLocalizedString(@"销量", NSStringFromClass([self class])) forState:UIControlStateNormal];
        self.priceOrAmountBtn.selected = self.sales_selected;
    }else{
        NSArray *orderArr = @[@{@"title": NSLocalizedString(@"综合", NSStringFromClass([self class])),@"cate_id":@"default",},
                              @{@"title": NSLocalizedString(@"热销", NSStringFromClass([self class])),@"cate_id":@"sales",},
                              @{@"title": NSLocalizedString(@"上新", NSStringFromClass([self class])),@"cate_id":@"new",}];
        self.secondArr = orderArr;
        if (self.goodLastSelected == -1 || !self.choose_good_sort_table) {
            [self.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price_down") forState:UIControlStateNormal];
            [self.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price_up") forState:UIControlStateSelected];
        }else{
            [self.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price") forState:UIControlStateNormal];
            [self.priceOrAmountBtn setImage:IMAGE(@"mall_btn_price") forState:UIControlStateSelected];
        }
        self.shopLastSelected = self.sortTableView.leftSelectedIndex;
        self.sortTableView.leftSelectedIndex = self.goodLastSelected;
        self.chageTableTypeBtn.userInteractionEnabled = YES;
        [self.chageTableTypeBtn setImage:IMAGE(@"btn_switch_two_yes") forState:UIControlStateNormal];
        [self.chageTableTypeBtn setImage:IMAGE(@"btn_switch_dan") forState:UIControlStateSelected];
        [self.priceOrAmountBtn setTitle: NSLocalizedString(@"价格", NSStringFromClass([self class])) forState:UIControlStateNormal];
        self.priceOrAmountBtn.selected = self.price_selected;
    }
    
    self.chooseFilter(@"",nil,4);
}

@end
