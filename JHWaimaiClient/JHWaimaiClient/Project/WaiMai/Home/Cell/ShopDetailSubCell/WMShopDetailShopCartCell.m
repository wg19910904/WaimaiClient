//
//  WMShopDetailShopCartCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/18.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopDetailShopCartCell.h"
#import "YFSteper.h"
#import "NSString+Tool.h"

@interface WMShopDetailShopCartCell()<YFSteperDelegate>

@property(nonatomic,weak)UILabel *nameLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *oldPriceLab;// 优惠前的价格
@property(nonatomic,weak)YFSteper *steper;
@property(nonatomic,weak)UILabel *propretyLab;// 属性
@end

@implementation WMShopDetailShopCartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *dotView = [UIView new];
    [self.contentView addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.width.offset=5;
        make.height.offset=5;
    }];
    dotView.backgroundColor = THEME_COLOR_Alpha(1.0);
    dotView.layer.cornerRadius=2.5;
    dotView.clipsToBounds=YES;
    
    UILabel *nameLab = [UILabel new];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotView.mas_right).offset=10;
        make.centerY.offset=-8;
        make.height.offset=20;
        make.width.lessThanOrEqualTo(@130);
    }];
    nameLab.font = FONT(12);
    nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLab.textColor = TEXT_COLOR;
    self.nameLab = nameLab;
    
    UILabel *propretyLab = [UILabel new];
    [self.contentView addSubview:propretyLab];
    [propretyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotView.mas_right).offset=10;
        make.centerY.offset=8;
        make.height.offset=20;
        make.width.lessThanOrEqualTo(@130);
    }];
    propretyLab.font = FONT(11);
    propretyLab.lineBreakMode = NSLineBreakByTruncatingTail;
    propretyLab.textColor = HEX(@"666666", 1.0);
    self.propretyLab = propretyLab;
    
    YFSteper *steper = [YFSteper new];
    [self.contentView addSubview:steper];
    [steper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.width.offset=100;
        make.height.offset=40;
    }];
    steper.minCount = 0;
    steper.delegate = self;
    steper.subBtnImg = @"btn-num_subtraction";
    steper.addBtnImg = @"btn-num_addCart";
    self.steper = steper;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(steper.mas_left).offset= -5;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    priceLab.font = FONT(14);
    priceLab.textColor = HEX(@"ff6600", 1.0);
    self.priceLab = priceLab;
    
    UILabel *oldPriceLab = [UILabel new];
    [self.contentView addSubview:oldPriceLab];
    [oldPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceLab.mas_left).offset= -5;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    oldPriceLab.font = FONT(10);
    oldPriceLab.textColor = HEX(@"b3b3b3", 1.0);
    self.oldPriceLab = oldPriceLab;
    
}

-(void)reloadCellWithModel:(WMShopGoodModel *)model isCou:(BOOL)is_cou{
    
    NSString *current_price = @"";
    NSString *all_price = @"";
    
    
    if (is_cou) {
        current_price = model.price;
        all_price = model.oldprice;
    }else{
        if(Current_Is_Other_ShopCart) {
            NSDictionary *dic = [[WMShopDBModel shareWMShopDBModel].current_good_price_dic objectForKey:model.goodDB_id];
            current_price = dic[@"current_price"];
            all_price = dic[@"all_price"];
        }else{
            NSDictionary *dic = [[WMShopDBModel shareWMShopDBModel].good_price_dic objectForKey:model.goodDB_id];
            current_price = dic[@"current_price"];
            all_price = dic[@"all_price"];
        }
        
    }
   
    NSString *name =  model.title;
    NSString *str;
    int count = [[WMShopDBModel shareWMShopDBModel] getShopGoodChoosedCountFromDB:model.product_id choosedSize_id:model.choosedSize_id propretyStr:model.choosed_proprety good:model];
    if (model.is_spec) {
        name = [name stringByAppendingString:[NSString stringWithFormat:@"(%@)",model.choosedSize_Name]];
        self.steper.maxCount = count == 0 ? model.choosedSize_sale_ku :(model.remain_count+ count);
        str = model.choosedSize_price;
    }else if (model.is_specification) {// 非规格商品但是属性商品
        self.steper.maxCount = count == 0 ? model.sale_sku :(model.remain_count+ count);
        str = model.price;
    }else{
        str = model.price;
        self.steper.maxCount = count == 0 ? model.sale_sku :(model.remain_count+ count);
    }
    
    current_price = current_price.length == 0 ? [NSString getStrFromFloatValue:[str floatValue] * count bitCount:2] : current_price;
    
    self.priceLab.attributedText = [NSString priceLabText:current_price attributeFont:14];
    
    self.steper.currentCount = count;
    self.propretyLab.text = model.show_choosed_proprety;
    self.propretyLab.hidden = model.choosed_proprety.length == 0;
    self.nameLab.text = name;

    self.oldPriceLab.hidden = ([all_price floatValue] <= [current_price floatValue]);
    if (model.is_discount) {
        NSString *str = [ NSLocalizedString(@"¥ ", NSStringFromClass([self class])) stringByAppendingString:all_price];
        self.oldPriceLab.attributedText = [NSString getAttributeString:str strAttributeDic:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName : HEX(@"b3b3b3", 1.0)}];
    }else{
        self.oldPriceLab.attributedText = nil;
    }
    
    [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset= model.choosed_proprety.length > 0 ? -8 : 0;
    }];

}

#pragma mark ======YFSteperDelegate=======
-(void)addCount{
    if (self.block) {
        self.block(YES);
    }
}

-(void)subCount:(int)count{
    if (self.block) {
        self.block(NO);
    }
}

@end
