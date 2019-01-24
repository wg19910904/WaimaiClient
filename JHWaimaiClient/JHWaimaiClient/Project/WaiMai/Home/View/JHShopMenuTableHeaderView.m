//
//  JHShopMenuTableHeaderView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/31.
//  Copyright © 2018年 xixixi. All rights reserved.
//
#import "YFBaseTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface MenuADCell : YFBaseTableViewCell
@property(nonatomic,weak)UIImageView *adImgView;
-(void)reloadCellWith:(NSDictionary *)dic;
@end

@implementation  MenuADCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
 
    UIImageView *imgView = [UIImageView new];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.right.offset(-10);
        make.bottom.offset(0);
    }];
    self.adImgView = imgView;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.cornerRadius=4;
    imgView.clipsToBounds=YES;
    
}

-(void)reloadCellWith:(NSDictionary *)dic{
    [self.adImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(dic[@"photo"])] placeholderImage:IMAGE(@"home_banner_default")];
}

@end


#import "JHShopMenuTableHeaderView.h"
#import "NSString+Tool.h"

@interface JHShopMenuTableHeaderView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,weak)UILabel *youhuiLab;
@property(nonatomic,weak)UILabel *youhuiDesLab;
@property(nonatomic,assign)BOOL have_coupon;// 是否有优惠劵
@end

@implementation JHShopMenuTableHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    
    [self createRightTableYouHuiFooterView];
    
}

// 右边tableView的优惠劵view
-(void)createRightTableYouHuiFooterView{
    
    UIButton *youHuiView = [[UIButton alloc] initWithFrame:FRAME(0, 0, WIDTH * 0.75, 70)];
//    youHuiView.backgroundColor = [UIColor blackColor];
    
    UIImageView *imgView = [UIImageView new];
    [youHuiView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.right.offset=-10;
        make.bottom.offset= -10;
    }];
    imgView.image = IMAGE(@"index_quan_box");
    imgView.contentMode= UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = NO;
    
    UILabel *moneyLab = [UILabel new];
    [imgView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset=0;
        make.left.offset=0;
        make.width.equalTo(imgView.mas_width).multipliedBy(0.25);
        make.height.offset=20;
    }];
    moneyLab.font = FONT(12);
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.textColor = [UIColor whiteColor];
    self.youhuiLab = moneyLab;
    
    UILabel *desLab = [UILabel new];
    [imgView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset=0;
        make.left.equalTo(moneyLab.mas_right).offset= 5;
        make.right.offset = -5;
    }];
    desLab.font = FONT(13);
    desLab.numberOfLines = 2;
    desLab.textColor = [UIColor whiteColor];
    self.youhuiDesLab = desLab;
    
    UILabel *getLab = [UILabel new];
    [imgView addSubview:getLab];
    [getLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.width.offset = 60;
        make.centerY.offset = 0;
        make.height.offset = 20;
    }];
    getLab.layer.cornerRadius=10;
    getLab.clipsToBounds=YES;
    getLab.layer.borderColor=HEX(@"ffffff", 1.0).CGColor;
    getLab.layer.borderWidth=0.5;
    getLab.font = FONT(10);
    getLab.textAlignment = NSTextAlignmentCenter;
    getLab.textColor = [UIColor whiteColor];
    getLab.text = NSLocalizedString(@"立即领劵", @"JHShopMenuVC");
    
    [youHuiView addTarget:self action:@selector(getQuan) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = youHuiView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MenuADCell *cell = [MenuADCell initWithTableView:tableView reuseIdentifier:@"MenuADCell"];
    [cell reloadCellWith:self.dataSource[indexPath.section]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH * 0.75 * 0.33;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGFLOAT_MIN : 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return self.dataSource.count - 1 == section ? 10 : CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YF_SAFE_BLOCK(self.clickItemBlock,indexPath.section,YES);
}

#pragma mark ====== Functions =======
// 刷新
-(void)reloadViewWith:(WMShopModel *)shop{
    if ([shop.shop_coupon[@"title"] length] == 0) {
        self.tableView.tableHeaderView = nil;
    }
    self.have_coupon = [shop.shop_coupon[@"title"] length] != 0;
    self.dataSource = shop.advs;
    [self reloadYouhuiView:shop];
}

// 刷新优惠劵View
-(void)reloadYouhuiView:(WMShopModel *)shop{
    
    self.youhuiLab.attributedText = [NSString priceLabText:shop.shop_coupon[@"coupon_amount"] attributeFont:20];
    
    NSMutableAttributedString * att2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"商家优惠劵\n", @"JHShopMenuVC")];
    [att2 appendAttributedString:[NSString getAttributeString:shop.shop_coupon[@"title"] strAttributeDic:@{NSFontAttributeName : FONT(11)}]];
    //建立行间距模型
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    //设置行间距
    [paragraphStyle1 setLineSpacing:3.f];
    
    //把行间距模型加入NSMutableAttributedString模型
    [att2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [att2 length])];
    
    self.youhuiDesLab.attributedText = att2;
}

// 领取优惠劵
-(void)getQuan{
    YF_SAFE_BLOCK(self.clickItemBlock,0,NO);
}

@end
