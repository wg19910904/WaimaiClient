//
//  WMShopCartOfShopCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopCartOfShopCell.h"
#import "YFCollectionViewLayout.h"
#import "ShopCartOfShopCollectionCell.h"
#import "JHShopCartGoodCell.h"
#import "YFTypeBtn.h"

@interface WMShopCartOfShopCell()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIButton *deleteBtn;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)WMShopDBModel *shopDBModel;
@end

@implementation WMShopCartOfShopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.width.lessThanOrEqualTo(@170);
        make.height.offset=20;
    }];
    titleLab.font =FONT(14);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.textColor = TEXT_COLOR;
    self.titleLab = titleLab;

    UIImageView *arrowImgView = [UIImageView new];
    [self.contentView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset=10;
        make.centerY.equalTo(titleLab.mas_centerY).offset=0;
        make.width.offset=7;
        make.height.offset=12;
    }];
    arrowImgView.image = IMAGE(@"icon-arrowR_white");
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(titleLab.mas_bottom).offset=10;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UIButton *deleteBtn = [UIButton new];
    [self.contentView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
         make.centerY.equalTo(titleLab.mas_centerY).offset=0;
        make.width.offset=24;
        make.height.offset=32;
    }];
    [deleteBtn setImage:IMAGE(@"btn_delete") forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *vLineView=[UIView new];
    [self.contentView addSubview:vLineView];
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleteBtn.mas_left).offset=-5;
        make.top.offset=5;
        make.width.offset=0.5;
        make.height.offset=30;
    }];
    vLineView.backgroundColor=LINE_COLOR;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(vLineView.mas_left).offset= -10;
        make.centerY.equalTo(titleLab.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    countLab.font = FONT(14);
    countLab.textColor = HEX(@"999999", 1.0);
    self.countLab = countLab;
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.scrollEnabled = NO;
    [self.contentView addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=40;
        make.right.offset=0;
        make.bottom.offset = 0;
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (self.shopDBModel.showShopCartMoreGood) {
        return self.shopDBModel.choosedGoodsArr.count;
    }else{
        return self.shopDBModel.choosedGoodsArr.count > 3 ? 3 : self.shopDBModel.choosedGoodsArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHShopCartGoodCell *cell = [JHShopCartGoodCell initWithTableView:tableView reuseIdentifier:@"JHShopCartGoodCell"];
    WMShopGoodModel *good = self.shopDBModel.choosedGoodsArr[indexPath.item];
    [cell reloadCellWithModel:good];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (!self.shopDBModel.showShopCartMoreGood && self.shopDBModel.choosedGoodsArr.count > 3) ? 40 : CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.shopDBModel.showShopCartMoreGood && self.shopDBModel.choosedGoodsArr.count > 3) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        
        YFTypeBtn *btn = [YFTypeBtn new];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset = 0;
        }];
        btn.btnType = RightImage;
        btn.imageMargin = 10;
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"展开更多商品 %d个", NSStringFromClass([self class])),self.shopDBModel.shop_choosedCount];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(14);
        [btn addTarget:self action:@selector(clickShowMore) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:IMAGE(@"btn_arrow_down") forState:UIControlStateNormal];
        btn.titleMargin = (WIDTH - 140) /2;
        
        UIView *lineView=[UIView new];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=0;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
        return view;
    }
    return nil;
}

#pragma mark ====== Functions =======
-(void)reloadCellWithModel:(WMShopDBModel *)model{
    
    self.titleLab.text = model.shop_title;
    self.countLab.text = [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"共", nil),model.shop_choosedCount,NSLocalizedString(@"件", @"JHWMShowChangeGoodsVC")];
    self.shopDBModel = model;
    
    CGFloat height = 0;
    NSInteger count =  self.shopDBModel.choosedGoodsArr.count;
    if (!self.shopDBModel.showShopCartMoreGood) {

        count = self.shopDBModel.choosedGoodsArr.count > 3 ? 3 : self.shopDBModel.choosedGoodsArr.count;
         height = self.shopDBModel.choosedGoodsArr.count > 3 ? 40 : 0;
    }

    if (self.shopDBModel.choosedGoodsArr.count) {
        height += 70 * count;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height);
    }];
    [self.tableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     YF_SAFE_BLOCK(self.showMoreGoodBlock,NO,nil);
}

-(void)clickShowMore{
    YF_SAFE_BLOCK(self.showMoreGoodBlock,YES,nil);
}

-(void)clickDelete{
    if (self.clickDeleteShopDB) {
        self.clickDeleteShopDB();
    }
}

@end
