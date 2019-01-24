//
//  JHWMOrderDetailProductBasketCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/8/10.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWMOrderDetailProductBasketCell.h"
#import "JHWMOrderDetailMoreCartProductCell.h"

@interface JHWMOrderDetailProductBasketCell ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSDictionary *basketDic;
@end


@implementation JHWMOrderDetailProductBasketCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.contentView addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor= [UIColor whiteColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
        make.bottom.offset = -10;
    }];
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    lineView.backgroundColor=LINE_COLOR;
  
    UIView *bottomLineView=[UIView new];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=-0.5;
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    bottomLineView.backgroundColor=LINE_COLOR;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.basketDic[@"product"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHWMOrderDetailMoreCartProductCell *cell=[JHWMOrderDetailMoreCartProductCell initWithTableView:tableView reuseIdentifier:@"JHWMOrderDetailMoreCartProductCell"];
    NSDictionary *dic = self.basketDic[@"product"][indexPath.row];
    [cell reloadCellWithModel:dic];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    UIImageView *imgView = [UIImageView new];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
        make.width.offset(18);
        make.height.offset(18);
    }];
    imgView.image = IMAGE(@"icon_basket");

    UILabel *titleLab = [UILabel new];
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(8);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.text = self.basketDic[@"basket_title"];
    
    return view;
}

-(void)reloadCellWithModel:(NSDictionary *)basketDic{
    self.basketDic = basketDic;
    [self.tableView reloadData];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 30 * [self.basketDic[@"product"] count] + 40;
    }];
}

@end


