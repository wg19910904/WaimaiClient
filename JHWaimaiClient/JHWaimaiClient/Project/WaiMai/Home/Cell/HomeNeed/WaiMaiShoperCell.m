//
//  WaiMaiShoperCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WaiMaiShoperCell.h"
#import "YFStartView.h"
#import "YFTypeBtn.h"
#import <UIImageView+WebCache.h>
#import "YFCollectionViewLayout.h"
#import "WaiMaiGoodCollectionCell.h"
#import "NSString+Tool.h"

@interface WaiMaiShoperCell()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewLayoutDelegate>
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UILabel *goodCountLab;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)YFStartView *starView;
@property(nonatomic,weak)UILabel *scoreLab;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UILabel *sendPriceLab;
@property(nonatomic,weak)UIImageView *sendTypeImgView;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *distanceLab;
@property(nonatomic,weak)YFTypeBtn *activityBtn;
@property(nonatomic,weak)UITableView *activityTableView;
@property(nonatomic,weak)UICollectionView *goodCollectionView;
@property(nonatomic,weak)UILabel *shopStatusLab;// 营业状态
@property(nonatomic,weak)UIImageView *shopTypeImgView;// 店铺标签
@property(nonatomic,strong)NSArray *activityArr;
@property(nonatomic,strong)NSArray *goodsArr;
@property(nonatomic,weak)UIView *lineView;

@end

@implementation WaiMaiShoperCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
        self.contentView.backgroundColor = BACK_COLOR;
    }
    return self;
}

-(void)configUI{
    
    UIView *backView = [UIView new];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.bottom.offset=-10;
    }];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(10, 10, 60, 60)];
    imgView.layer.borderColor = LINE_COLOR.CGColor;
    imgView.layer.borderWidth = 0.5;
    imgView.layer.cornerRadius = 3;
    [backView addSubview:imgView];
    //    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.offset=10;
    //        make.top.offset=10;
    //        make.width.offset=60;
    //        make.height.offset=60;
    //    }];
    self.imgView = imgView;
    
    UILabel *goodCountLab = [[UILabel alloc] initWithFrame:FRAME(0, 0, 15, 15)];
    [backView addSubview:goodCountLab];
    [goodCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgView.mas_right).offset=0;
        make.centerY.equalTo(imgView.mas_top).offset=0;
        make.width.offset=15;
        make.height.offset=15;
    }];
    goodCountLab.centerX = 60;
    goodCountLab.centerY = 0;
    goodCountLab.textColor = [UIColor whiteColor];
    goodCountLab.textAlignment = NSTextAlignmentCenter;
    goodCountLab.layer.borderColor=HEX(@"ffffff", 1.0).CGColor;
    goodCountLab.layer.borderWidth=2.0;
    goodCountLab.layer.cornerRadius = 7.5;
    goodCountLab.layer.masksToBounds=YES;
    goodCountLab.backgroundColor = HEX(@"ff2200", 1.0);
    goodCountLab.font = FONT(10);
    goodCountLab.hidden = YES;
    self.goodCountLab = goodCountLab;
    
    UILabel *shopStatusLab = [UILabel new];
    [imgView addSubview:shopStatusLab];
    [shopStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset=0;
        make.right.offset=0;
        make.left.offset=0;
        make.height.offset=20;
    }];
    shopStatusLab.backgroundColor = HEX(@"000000", 0.3);
    shopStatusLab.textColor = [UIColor whiteColor];
    shopStatusLab.font = FONT(10);
    shopStatusLab.textAlignment = NSTextAlignmentCenter;
    self.shopStatusLab = shopStatusLab;
    
    UIImageView *shopTypeImgView = [UIImageView new];
    [backView addSubview:shopTypeImgView];
    [shopTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset=43;
        make.height.offset=43;
    }];
    self.shopTypeImgView = shopTypeImgView;
    
    UILabel *titleLab = [UILabel new];
    [backView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset=10;
        make.top.offset=10;
        make.right.offset=-70;
        make.height.offset=20;
    }];
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.font = B_FONT(16);//FONT(14);
    titleLab.textColor = HEX(@"222222", 1.0);
    self.titleLab = titleLab;
    
    UIImageView *sendTypeImgView = [UIImageView new];
    [backView addSubview:sendTypeImgView];
    [sendTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(titleLab.mas_centerY).offset=0;
        make.width.offset=48;
        make.height.offset=16;
    }];
    self.sendTypeImgView = sendTypeImgView;
    
    YFStartView *starView = [YFStartView new];
    [backView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset=10;
        make.top.equalTo(titleLab.mas_bottom).offset=0;
        make.centerY.equalTo(imgView.mas_centerY).offset=0;
        make.height.offset = 12;
        make.width.offset = 70;
    }];
    starView.interSpace = 2.5;
    starView.fullStarNum = 5;
    starView.currentStarScore = 0.0;
    starView.starType = YFStarViewFloat;
    starView.userInteractionEnabled = NO;
    starView.imgSize = CGSizeMake(12, 12);
    self.starView = starView;
    
    UILabel *scoreLab = [UILabel new];
    [backView addSubview:scoreLab];
    [scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starView.mas_right).offset=5;
        make.centerY.equalTo(starView.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    scoreLab.textColor = HEX(@"ff9900", 1.0);
    scoreLab.font = FONT(12);
    self.scoreLab = scoreLab;
    
    UILabel *countLab = [UILabel new];
    [backView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scoreLab.mas_right).offset=10;
        make.centerY.equalTo(starView.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    countLab.textColor = HEX(@"999999", 1.0);
    countLab.font = FONT(12);
    self.countLab = countLab;
    
    UILabel *timeLab = [UILabel new];
    [backView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset= -10;
        make.centerY.equalTo(starView.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    timeLab.textColor = HEX(@"ff4d5b", 1.0);
    timeLab.font = FONT(12);
    self.timeLab = timeLab;
    
    UILabel *sendPriceLab = [UILabel new];
    [backView addSubview:sendPriceLab];
    [sendPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset=10;
        make.bottom.equalTo(imgView.mas_bottom).offset=0;
        make.height.offset=20;
    }];
    sendPriceLab.textColor = HEX(@"999999", 1.0);
    sendPriceLab.font = FONT(12);
    self.sendPriceLab = sendPriceLab;
    
    UILabel *distanceLab = [UILabel new];
    [backView addSubview:distanceLab];
    [distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.bottom.equalTo(imgView.mas_bottom).offset=0;
        make.height.offset=20;
    }];
    distanceLab.textColor = HEX(@"999999", 1.0);
    distanceLab.font = FONT(11);
    self.distanceLab = distanceLab;
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(10, 80, WIDTH-20, 0) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [backView addSubview:tableView];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.userInteractionEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.activityTableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=80;
        make.right.offset=-10;
    }];
    
    YFTypeBtn *activityBtn = [YFTypeBtn new];
    [backView addSubview:activityBtn];
    [activityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.top.equalTo(tableView.mas_top).offset=0;
        make.height.offset=30;
    }];
    activityBtn.titleMargin = -5;
    activityBtn.imageMargin = 5;
    activityBtn.btnType = RightImage;
    activityBtn.titleLabel.font = FONT(10);
    [activityBtn setImage:IMAGE(@"arrow_down_black") forState:UIControlStateNormal];
    [activityBtn setImage:IMAGE(@"arrow_up_black") forState:UIControlStateSelected];
    [activityBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
    [activityBtn addTarget:self action:@selector(showMoreActivity) forControlEvents:UIControlEventTouchUpInside];
    self.activityBtn = activityBtn;
    
    UIView *lineView=[UIView new];
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(tableView.mas_bottom).offset=10;
        make.right.offset=-10;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
    self.lineView = lineView;
    
    YFCollectionViewLayout * flowLayout=[[YFCollectionViewLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.lineItems = 20;
    flowLayout.interSpace = 10;
    flowLayout.delegate = self;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,0) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[WaiMaiGoodCollectionCell class] forCellWithReuseIdentifier:@"WaiMaiGoodCollectionCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    [backView addSubview:collectionView];
    self.goodCollectionView = collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lineView.mas_bottom).offset=10;
        make.right.offset=-10;
        make.height.offset=  (WIDTH - 50)/4 + 30;
        make.bottom.offset=0;
    }];
    
    
    self.sendTypeImgView.image = IMAGE(@"label_son");
    self.shopTypeImgView.image = IMAGE(@"label_new");
}

#pragma mark ======UITableViewDelegate/DataSource=======
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activityArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"ShoperActivityCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *lab = [UILabel new];
        [cell addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.centerY.offset=0;
            make.width.offset=15;
            make.height.offset=15;
        }];
        lab.layer.cornerRadius=5;
        lab.clipsToBounds=YES;
        lab.font = FONT(10);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.tag = 101;
        
        UILabel *desLab = [UILabel new];
        [cell addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=25;
            make.centerY.offset=0;
            make.right.offset=0;
            make.height.offset=15;
        }];
        desLab.lineBreakMode = NSLineBreakByTruncatingTail;
        desLab.font = FONT(11);
        desLab.textColor = HEX(@"666666", 1.0);
        desLab.tag = 102;
    }
    
    UILabel *typeLab = [cell viewWithTag:101];
    UILabel *desLab = [cell viewWithTag:102];
    
    NSDictionary *dic = self.activityArr[indexPath.row];
    typeLab.backgroundColor = HEX(dic[@"color"], 1.0);
    typeLab.text = dic[@"word"];
    desLab.text = dic[@"title"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}

#pragma mark ======UICollectionViewDelegate/DataSource=======
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsArr.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WaiMaiGoodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaiMaiGoodCollectionCell" forIndexPath:indexPath];
    WMHomeShopProducts *good = self.goodsArr[indexPath.item];
    [cell reloadCellWithModel:good];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (WIDTH - 50)/4;
    return CGSizeMake(width, width + 25);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMHomeShopProducts *good = self.goodsArr[indexPath.item];
    if (self.goShopDetail) {
        self.goShopDetail(good.product_id);
    }
    
}

#pragma mark ======Function=======
-(void)reloadCellWithModel:(WMHomeShopModel *)model{
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.shop.logo)] placeholderImage:IMAGE(@"logo_shop60_default")];
    self.sendTypeImgView.hidden = NO;
    if (model.shop.pei_type == 0) {
        self.sendTypeImgView.image = IMAGE(@"label_son_shop");
    }else if(model.shop.pei_type == 1){
        self.sendTypeImgView.image = IMAGE(@"label_son");
    }else{
        self.sendTypeImgView.hidden = YES;
    }
    self.titleLab.text = model.shop.title;
    self.starView.currentStarScore = model.shop.avg_score;
    
    self.scoreLab.text = [NSString stringWithFormat:@"%@%@",[NSString getStrFromFloatValue:model.shop.avg_score bitCount:1],NSLocalizedString(@"分", nil)];
    self.countLab.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"已售", nil),model.shop.orders,NSLocalizedString(@"单", @"WaiMaiShoperCell")];
    self.shopStatusLab.text = model.shop.status == 1 ? @"": NSLocalizedString(@"已打烊", nil);
    self.shopStatusLab.backgroundColor = model.shop.status == 1 ? [UIColor clearColor] : HEX(@"999999",1);
    self.shopTypeImgView.hidden = !model.shop.is_new;
    self.timeLab.text = [NSString stringWithFormat:@"%@%@",model.shop.pei_time,NSLocalizedString(@"分钟", @"WaiMaiShoperCell")];
    self.distanceLab.text = model.shop.juli_label;
    
    if ([model.shop.freight floatValue] == 0) {
        self.sendPriceLab.text = [NSString stringWithFormat:@"%@%@%@/%@",NSLocalizedString(@"¥", nil),model.shop.min_amount,NSLocalizedString(@"起送", nil),NSLocalizedString(@"免配送费", nil)];
    }else{
        self.sendPriceLab.text = [NSString stringWithFormat:@"%@%@%@/%@¥%@",NSLocalizedString(@"¥", nil),model.shop.min_amount,NSLocalizedString(@"起送", nil),NSLocalizedString(@"配送费", nil),model.shop.freight];
    }
    
    self.goodsArr = model.products;
    self.activityArr = model.shop.huodong;
    
    self.activityBtn.hidden = (self.activityArr.count <= 3);
    self.activityBtn.selected = model.shop.showMore;
    [self.activityBtn setTitle:[NSString stringWithFormat:@"%ld%@",self.activityArr.count,NSLocalizedString(@"个活动", nil)] forState:UIControlStateNormal];
    [self reloadActivityTableView:model.shop.showMore];
    self.activityTableView.hidden = (self.activityArr.count == 0) ;
    [self.activityTableView reloadData];
    
    //    if (self.activityArr.count == 0) {
    //        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.offset=10;
    //            make.top.equalTo(self.imgView.mas_bottom).offset=10;
    //            make.right.offset=-10;
    //            make.height.offset=1;
    //        }];
    //    }else{
    //        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.offset=10;
    //            make.top.equalTo(self.activityTableView.mas_bottom).offset=10;
    //            make.right.offset=-10;
    //            make.height.offset=1;
    //        }];
    //    }
    //
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.left.offset=10;
        make.top.equalTo(self.activityTableView.mas_bottom).offset= (self.activityArr.count == 0 ? 15 : 10);
        //        make.right.offset=-10;
        //        make.height.offset=1;
    }];
    
    self.lineView.hidden = NO;
    if (model.products.count == 0 && model.shop.huodong.count == 0) {
        self.lineView.hidden = YES;
    }
    [self.goodCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset =  model.products.count == 0 ? 0 : 10;
        make.height.offset= model.products.count == 0 ? 0 : (WIDTH - 50)/4 + 30;
    }];
    [self.goodCollectionView reloadData];
    [self dealShopCount:model.shop.shop_id];
}

-(void)reloadActivityTableView:(BOOL)showMore{
    
    NSInteger count = self.activityArr.count;
    if (!showMore) {
        count = count > 3 ? 3 : count;
    }
    self.activityBtn.selected = showMore;
    [self.activityTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset = count == 0 ? 65 : 80;
        make.height.offset = 20 * count;
    }];
    [self layoutSubviews];
    
}

-(void)dealShopCount:(NSString *)shop_id{
    [[WMShopDBModel shareWMShopDBModel] getShopChoosedCountFromDB:shop_id block:^(int count) {
        NSString *str = [NSString stringWithFormat:@"%d",count];
        CGFloat width = [str boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width + 5;
        width = width < 15 ? 15 : width;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.goodCountLab.hidden = NO;
            self.goodCountLab.text = str;
            [self.goodCountLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset=width;
            }];
            self.goodCountLab.hidden = count == 0;
        });
    }];
}

// 显示跟多活动
-(void)showMoreActivity{
    if (self.clickShowMore) {
        self.clickShowMore();
    }
}
@end

