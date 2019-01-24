//
//  WMMoreShopCartCellTableViewCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/18.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "WMMoreShopCartCell.h"
#import "WMMoreShopCartGoodCell.h"

@interface WMMoreShopCartCell ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UILabel *numLab;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *goodsArr;
@property(nonatomic,weak)UIButton *changeBtn;
@end

@implementation WMMoreShopCartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *numLab = [UILabel new];
    [self.contentView addSubview:numLab];
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.top.offset(18);
        make.height.width.offset(18);
    }];
    numLab.layer.cornerRadius=9;
    numLab.clipsToBounds=YES;
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.textColor = HEX(@"ffffff", 1.0);
    numLab.font = FONT(14);
    self.numLab = numLab;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLab.mas_right).offset(10);
        make.centerY.equalTo(numLab.mas_centerY).offset(0);
        make.height.offset(20);
        make.width.lessThanOrEqualTo(@120);
    }];
    titleLab.font = FONT(16);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;
    
    UIButton *editBtn = [UIButton new];
    [self.contentView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset(8);
        make.centerY.equalTo(numLab.mas_centerY).offset(0);
        make.width.height.offset(30);
    }];
    [editBtn setImage:IMAGE(@"shopcart_edit") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [UIButton new];
    [self.contentView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.centerY.equalTo(numLab.mas_centerY).offset(0);
        make.width.offset(47);
        make.height.offset(20);
    }];
    [deleteBtn setTitle: NSLocalizedString(@"删除Ta", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [deleteBtn setTitleColor:HEX(@"999999", 1.0) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = FONT(11);
    deleteBtn.layer.borderColor=HEX(@"999999", 1.0).CGColor;
    deleteBtn.layer.borderWidth=0.5;
    deleteBtn.layer.cornerRadius=2;
    deleteBtn.clipsToBounds=YES;
    [deleteBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeBtn = [UIButton new];
    [self.contentView addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleteBtn.mas_left).offset(-6);
        make.centerY.equalTo(numLab.mas_centerY).offset(0);
        make.width.offset(47);
        make.height.offset(20);
    }];
    [changeBtn setTitleColor:HEX(@"20AD20", 1.0) forState:UIControlStateNormal];
    changeBtn.titleLabel.font = FONT(11);
    changeBtn.layer.borderColor=HEX(@"20AD20", 1.0).CGColor;
    changeBtn.layer.borderWidth=0.5;
    changeBtn.layer.cornerRadius=2;
    changeBtn.clipsToBounds=YES;
    [changeBtn addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
    self.changeBtn = changeBtn;

    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(40, 50, WIDTH-40, 40) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.contentView addSubview:tableView];
//    tableView.estimatedRowHeight = 40;
//    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.scrollEnabled = NO;
    self.tableView=tableView;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.top.offset(50);
        make.width.offset(WIDTH-40);
        make.bottom.offset(0);
    }];
    
    UILabel *desLab = [UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.left.offset(40);
        make.height.offset(40);
    }];
    desLab.font = FONT(13);
    desLab.textColor = HEX(@"999999", 1.0);
    desLab.text =  NSLocalizedString(@"还没有添加商品", NSStringFromClass([self class]));
    self.desLab = desLab;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMMoreShopCartGoodCell *cell = [WMMoreShopCartGoodCell initWithTableView:tableView reuseIdentifier:@"WMMoreShopCartGoodCell"];
    [cell reloadCellWithModel:self.goodsArr[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


#pragma mark ====== Functions =======

-(void)clickEdit{
    YF_SAFE_BLOCK(self.clickActionBlock,YES,@"edit");
}

-(void)clickDelete{
    YF_SAFE_BLOCK(self.clickActionBlock,YES,@"delete");
}

-(void)clickChange{
    YF_SAFE_BLOCK(self.clickActionBlock,YES,@"change");
}

-(void)reloadCellWithModel:(JHWMShopCartModel *)model{
    
    self.numLab.text = [NSString stringWithFormat:@"%d",model.shopcartNum];
    self.numLab.backgroundColor = model.shopcartColor;
    self.titleLab.text = model.shopcartName;
    
    self.goodsArr = model.choosedGoodsArr;
    
    BOOL is_zero = model.choosedGoodsArr.count == 0;
    CGFloat height = is_zero ? 40 : (model.choosedGoodsArr.count * 40);
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height);
        make.bottom.offset(0);
    }];
    [self.tableView reloadData];
    self.tableView.hidden = is_zero;
    self.desLab.hidden = !is_zero;
    
    NSString *str = is_zero? NSLocalizedString(@"添加商品", NSStringFromClass([self class])) : NSLocalizedString(@"修改商品", NSStringFromClass([self class]));
    [self.changeBtn setTitle:str forState:UIControlStateNormal];
    

}

@end
