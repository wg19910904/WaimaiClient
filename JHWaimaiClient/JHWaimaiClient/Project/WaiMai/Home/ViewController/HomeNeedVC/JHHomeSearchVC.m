//
//  JHHomeSearchVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHHomeSearchVC.h"
#import "YFTextField.h"
#import "HistorySearchView.h"
#import "YFSegmentedControl.h"
#import "JHSearchResultOfGoods.h"
#import "JHSearchResultOfShopper.h"

@interface JHHomeSearchVC ()<UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)YFTextField *searchField;
@property(nonatomic,weak)UIScrollView *contentView;
@property(nonatomic,weak)YFSegmentedControl *segment;
@property(nonatomic,assign)BOOL is_scrollDelegate;// 手动设置的代理方法需不需要处理
@property(nonatomic,strong)NSArray *subVcArr;

// 搜索历史的View
@property(nonatomic,strong)HistorySearchView *historySearchView;

@end

@implementation JHHomeSearchVC

-(void)viewDidLoad{
    
    [super viewDidLoad];

    [self getData];
    [self setUpView];
    
}

-(void)setUpView{
    self.navigationItem.titleView = self.searchField;
    
    YFSegmentedControl *segment = [[YFSegmentedControl alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 40) titleArr:@[@{@"title":NSLocalizedString(@"商家", nil)},@{@"title":NSLocalizedString(@"商品", nil)}]];
    segment.indicatorWidth = 60;
    segment.textFont = FONT(16);
    segment.showIndicator = YES;
    segment.selectedColor = THEME_COLOR_Alpha(1.0);
    segment.normalColor = HEX(@"333333", 1.0);
    [segment addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    self.segment = segment;

    JHSearchResultOfGoods *goodVC = [JHSearchResultOfGoods new];
    JHSearchResultOfShopper *shopVC = [JHSearchResultOfShopper new];
    shopVC.view.frame = FRAME(0, 0, WIDTH, HEIGHT - 40 - NAVI_HEIGHT);
    goodVC.view.frame = FRAME(WIDTH, 0, WIDTH, HEIGHT - 40 - NAVI_HEIGHT);
    goodVC.historySearchView = self.historySearchView;
    shopVC.historySearchView = self.historySearchView;
    [self addChildViewController:goodVC];
    [self addChildViewController:shopVC];
    
    self.subVcArr = @[shopVC,goodVC];

    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:FRAME(0, 40 + NAVI_HEIGHT, WIDTH, HEIGHT - 40 - NAVI_HEIGHT)];
    contentView.bounces = NO;
    contentView.scrollEnabled = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.delegate = self;
    contentView.contentSize = CGSizeMake(WIDTH * 2, HEIGHT - 40 - NAVI_HEIGHT);
    [contentView addSubview:goodVC.view];
    [contentView addSubview:shopVC.view];
    [contentView setContentOffset:CGPointMake(WIDTH * segment.selectedSegmentIndex, 0) animated:YES];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    [self.view addSubview:self.historySearchView];
}

#pragma mark ====== 懒加载 =======
-(YFTextField *)searchField{
    if (_searchField==nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 30)];
        [btn setImage:IMAGE(@"nav_btn_search_gray") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
        
        _searchField=[[YFTextField alloc] initWithFrame:CGRectMake(0, 0, 350, 30) leftView:[UIView new] rightView:btn];
        _searchField.letfMargin = 15;
        _searchField.rightMargin = 5;
        _searchField.font = FONT(14);
        _searchField.placeholdeFont = FONT(14);
        _searchField.textColor = HEX(@"666666", 1.0);
        _searchField.placeholdeColor = HEX(@"999999", 1.0);
        _searchField.delegate = self;
        _searchField.placeholder = NSLocalizedString(@"搜索商家、商品", nil);
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.backgroundColor = [UIColor whiteColor];
        _searchField.layer.cornerRadius=15;
        _searchField.clipsToBounds=YES;
        _searchField.returnKeyType = UIReturnKeySearch;
    }
    return _searchField;
}

-(HistorySearchView *)historySearchView{
    if (_historySearchView==nil) {
        __weak typeof(self) weakSelf=self;
        _historySearchView=[[HistorySearchView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT)];
        _historySearchView.backgroundColor =BACK_COLOR;
        _historySearchView.historyCashDataFilePath = @"JHHomeSearchHistory";
        _historySearchView.hotSearchUrl = @"client/waimai/shop/hotsearch";
        _historySearchView.clickTitle = ^(NSString *title){
            weakSelf.searchField.text = title;
            [weakSelf clickSearch];
        };
    }
    return _historySearchView;
}

#pragma mark ====== 点击清除搜索信息的按钮 =======
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view bringSubviewToFront:self.historySearchView];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickSearch];
    return YES;
}

#pragma mark ====== Functions =======
// 点击搜索
-(void)clickSearch{
    if (self.searchField.text.length == 0 ) {
        return;
    }
    [self.searchField endEditing:YES];
    [self.searchField resignFirstResponder];

    [self getData];
    [self.view sendSubviewToBack:self.historySearchView];
}

// 获取数据
-(void)getData{

    if (self.searchField.text.length == 0 ) {
        return;
    }
    
    if (self.segment.selectedSegmentIndex == 0) {
        JHSearchResultOfShopper *shopVC = self.subVcArr[self.segment.selectedSegmentIndex];
        [shopVC getDataWithKeyword:self.searchField.text];
    }else{
        JHSearchResultOfGoods *goodVC = self.subVcArr[self.segment.selectedSegmentIndex];
        [goodVC getDataWithKeyword:self.searchField.text];
    }
    
}

// 点击segment
-(void)clickSegment:(YFSegmentedControl *)segment{

    [self.contentView setContentOffset:CGPointMake(WIDTH * segment.selectedSegmentIndex, 0) animated:YES];
    [self getData];
}

@end
