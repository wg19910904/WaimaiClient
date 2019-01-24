//
//  JHFilterTableView.m
//  Lunch
//
//  Created by ios_yangfei on 17/3/21.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import "YFFilterView.h"
#import "YFTypeBtn.h"
#import "FilterTableView.h"
#import "FilterModel.h"
#import "FilterAddressModel.h"


#define btn_tag 200

@interface YFFilterView ()
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,weak)YFTypeBtn *selectedBtn;
@property(nonatomic,strong)FilterTableView *cateTableView;
@property(nonatomic,strong)FilterTableView *areaTableView;
@property(nonatomic,strong)FilterTableView *sortTableView;

@property(nonatomic,assign)BOOL threeOrTwoFilter;// yes: three, no: two
@end

@implementation YFFilterView

-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)arr{
    
    if (self = [super initWithFrame:frame]) {
        
        [self configUIWith:arr];
    }
    
    return self;
}

-(void)configUIWith:(NSArray *)titleArr{
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, 0);
    control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    [control addTarget:self action:@selector(filterTableHidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    self.control=control;
    control.alpha = 0;
    
    for (NSInteger i=0; i<titleArr.count; i++) {
        
        YFTypeBtn * btn = [YFTypeBtn new];
        [self addSubview:btn];
        btn.backgroundColor = [UIColor whiteColor];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=WIDTH/(titleArr.count) * i;
            make.top.offset=0;
            make.width.offset=WIDTH/(titleArr.count);
            make.height.offset=44;
        }];
        btn.titleLabel.font = FONT(14);
        btn.btnType = AllCenterTitleFront;
        btn.imageMargin = -5;
        btn.tag = btn_tag + i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        [btn setTitleColor:THEME_COLOR_Alpha(1.0) forState:UIControlStateSelected];
        [btn setImage:IMAGE(@"btn_arrow_d") forState:UIControlStateNormal];
        [btn setImage:IMAGE(@"btn_arrow_up") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickTable:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i != 0) {
            UIView *lineView=[UIView new];
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=WIDTH/(titleArr.count) * i - 0.5;
                make.top.offset=8;
                make.width.offset=1;
                make.height.offset=44-16;
            }];
            lineView.backgroundColor=LINE_COLOR;
        }
    }
    
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
    if (titleArr.count == 3) {
        [self addSubview:self.areaTableView];
        self.threeOrTwoFilter = YES;
    }
    
}

-(void)clickTable:(YFTypeBtn *)btn{
    
    if (btn == self.selectedBtn) {// 不展示选择界面
        [self filterTableHidden];
    }else{
        if (self.firstArr.count == 0) {
            [self getData];
        }
        self.selectedBtn.selected = NO;
        btn.selected = YES;
        self.selectedBtn = btn;
        
        self.frame = FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT);
        self.control.height = HEIGHT;
        
        [UIView animateWithDuration:0.1 animations:^{
            self.control.alpha = 1;
        }];
        
        [self startAnimation];
        
    }
    
}

-(void)startAnimation{
    CGFloat height = 0;
    if (self.threeOrTwoFilter) {// 三个筛选条件
        if (self.selectedBtn.tag - btn_tag == 0) {
            self.sortTableView.height = 0;
            self.areaTableView.height = 0;
            height = self.firstArr.count > 8 ? 44 * 8: 44 * self.firstArr.count;
            [UIView animateWithDuration:0.25 animations:^{
                self.cateTableView.height = height;
            }];
            [self.cateTableView reloadView];
        }else if (self.selectedBtn.tag - btn_tag == 1){
            self.cateTableView.height = 0;
            self.sortTableView.height = 0;
            height = self.secondArr.count > 8 ? 44 * 8: 44 * self.secondArr.count;
            [UIView animateWithDuration:0.25 animations:^{
                self.areaTableView.height = height;
            }];
            [self.areaTableView reloadView];
        }else{
            self.areaTableView.height = 0;
            self.cateTableView.height = 0;
            height = self.thirdArr.count > 8 ? 44 * 8: 44 * self.thirdArr.count;
            [UIView animateWithDuration:0.25 animations:^{
                self.sortTableView.height = height;
            }];
            
            [self.sortTableView reloadView];
        }
        
    }else{// 两个筛选条件
        if (self.selectedBtn.tag - btn_tag == 0) {
            self.sortTableView.height = 0;
            height = self.firstArr.count > 8 ? 44 * 8: 44 * self.firstArr.count;
            [UIView animateWithDuration:0.25 animations:^{
                self.cateTableView.height = height;
            }];
            [self.cateTableView reloadView];
        }else{
            self.cateTableView.height = 0;
            height = self.secondArr.count > 8 ? 44 * 8: 44 * self.secondArr.count;
            [UIView animateWithDuration:0.25 animations:^{
                self.sortTableView.height = height;
            }];
            [self.sortTableView reloadView];
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
        if (self.threeOrTwoFilter) {
            self.areaTableView.height = 0;
        }
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
        
        [weakSelf.selectedBtn setTitle:[NSString stringWithFormat:@"%@   ",title]
                              forState:UIControlStateNormal];
        [weakSelf filterTableHidden];
    };
    
}

-(void)setSecondArr:(NSArray *)secondArr{
    _secondArr = secondArr;
    __weak typeof(self) weakSelf=self;
    if (self.threeOrTwoFilter) {
        
        self.areaTableView.leftArr = secondArr;
        
        _areaTableView.chooseBlock = ^(NSInteger left,NSInteger right){
            NSString *title ;
            FilterAddressModel *area = secondArr[left];
            NSString * business_id = @"";
            if (right >= 0) {
                NSDictionary *dic = area.business[right];
                title = dic[@"business_name"];
                business_id = dic[@"business_id"];
            }else{
                title = area.area_name;
            }
            
            if (weakSelf.chooseFilter) {
                weakSelf.chooseFilter(area.area_id,business_id,2);
            }
            [weakSelf.selectedBtn setTitle:[NSString stringWithFormat:@"%@   ",title]
                                  forState:UIControlStateNormal];
            [weakSelf filterTableHidden];
        };
        
    }else{
        
        //        self.sortTableView.leftArr = secondArr;
        //        _sortTableView.chooseBlock = ^(NSInteger left,NSInteger right){
        //            NSDictionary *dic = secondArr[left];
        //            NSString *title = dic[@"title"];
        //            if (weakSelf.chooseFilter) {
        //                weakSelf.chooseFilter(dic[@"cate_id"],2);
        //            }
        //            [weakSelf.selectedBtn setTitle:title forState:UIControlStateNormal];
        //            [weakSelf filterTableHidden];
        //        };
    }
}

-(void)setThirdArr:(NSArray *)thirdArr{
    _thirdArr = thirdArr;
    if (self.threeOrTwoFilter) {
        
        __weak typeof(self) weakSelf=self;
        self.sortTableView.leftArr = thirdArr;
        _sortTableView.chooseBlock = ^(NSInteger left,NSInteger right){
            NSDictionary *dic = thirdArr[left];
            NSString *title = dic[@"title"];
            if (weakSelf.chooseFilter) {
                weakSelf.chooseFilter(dic[@"cate_id"],nil,3);
            }
            [weakSelf.selectedBtn setTitle:[NSString stringWithFormat:@"%@   ",title]
                                  forState:UIControlStateNormal];
            [weakSelf filterTableHidden];
        };
    }
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

-(FilterTableView *)areaTableView{
    if (_areaTableView==nil) {
        _areaTableView=[[FilterTableView alloc] initWithFrame:FRAME(0, 44, WIDTH, 0)];
        _areaTableView.filterType = FilterTwoTable;
        _areaTableView.kindType = 1;
    }
    return _areaTableView;
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
    NSString *api;
    if (_isShop) {
        api = @"client/v2/shop/cate";
    }else{
        api = @"client/v2/waimai/shop/cate";
    }
    [HttpTool postWithAPI:api withParams:@{} success:^(id json) {

        NSLog(@"分类列表 =======  %@",json);
        if (ISPostSuccess) {
            
            NSArray *cateArr = [FilterModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            NSArray *areaArr = [FilterAddressModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"citys"]];
            NSArray *orderArr = json[@"data"][@"order"];
            
            weakSelf.firstArr = cateArr;
            weakSelf.secondArr = areaArr;
            weakSelf.thirdArr = orderArr;
            
            [weakSelf dealwithFirstSelectedType];
//                        [weakSelf startAnimation];
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


@end
