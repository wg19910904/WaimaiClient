//
//  WMGoodDetailCellOne.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/23.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMGoodDetailCellOne.h"
#import "YFSteper.h"
#import "NSString+Tool.h"

@interface WMGoodDetailCellOne ()<YFSteperDelegate>
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)YFSteper *steper;
@property(nonatomic,weak)UIButton *selectedTypeBtn;
@property(nonatomic,weak)UILabel *guiCountLab;
@property(nonatomic,assign)BOOL is_gui;
@property(nonatomic,copy)NSString *good_id;
@property(nonatomic,weak)UILabel *infoLab;

@property(nonatomic,weak)UILabel *discountLab;// 折扣lab
@property(nonatomic,weak)UILabel *discountDesLab;// 限购lab
@property(nonatomic,weak)UILabel *oldPriceLab;

@end

@implementation WMGoodDetailCellOne

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
        make.right.offset=-10;
        make.height.offset=20;
    }];
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.font = FONT(16);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
    UILabel *desLab = [UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(titleLab.mas_bottom).offset = 10;
        make.width.lessThanOrEqualTo(@170);
        make.height.offset=20;
    }];
    desLab.textColor = HEX(@"999999", 1.0);
    desLab.font = FONT(12);
    desLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.desLab = desLab;
    
    UILabel *discountLab = [UILabel new];
    [self.contentView addSubview:discountLab];
    [discountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(desLab.mas_bottom).offset = 10;
        make.width.lessThanOrEqualTo(@35);
        make.height.offset=16;
    }];
    discountLab.textColor = [UIColor whiteColor];
    discountLab.font = FONT(12);
    discountLab.backgroundColor = HEX(@"ff4848", 1.0);
    discountLab.layer.cornerRadius=4;
    discountLab.clipsToBounds=YES;
    discountLab.textAlignment = NSTextAlignmentCenter;
    self.discountLab = discountLab;
    
    UILabel *discountDesLab = [UILabel new];
    [self.contentView addSubview:discountDesLab];
    [discountDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(discountLab.mas_right).offset=5;
        make.centerY.equalTo(discountLab.mas_centerY);
        make.right.offset = 0;
        make.height.offset=20;
    }];
    discountDesLab.textColor = HEX(@"666666", 1.0);
    discountDesLab.lineBreakMode = NSLineBreakByTruncatingTail;
    discountDesLab.font = FONT(12);
    self.discountDesLab = discountDesLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.height.offset= 20;
        make.top.equalTo(discountLab.mas_bottom).offset = 10;
    }];
    priceLab.textColor = HEX(@"ff6600", 1.0);
    priceLab.font = FONT(12);
    self.priceLab = priceLab;

    UILabel *oldPriceLab = [UILabel new];
    [self.contentView addSubview:oldPriceLab];
    [oldPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLab.mas_right).offset= 5;
        make.centerY.equalTo(priceLab.mas_centerY);
        make.height.offset=20;
    }];
    oldPriceLab.textColor = HEX(@"b3b3b3", 1.0);
    oldPriceLab.font = FONT(12);
    self.oldPriceLab = oldPriceLab;
    

    YFSteper *steper = [YFSteper new];
    [self.contentView addSubview:steper];
    [steper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(priceLab.mas_centerY).offset=0;
        make.width.offset=100;
        make.height.offset=40;
    }];
    steper.minCount = 0;
    steper.delegate = self;
    steper.subBtnImg = @"btn-num_subtraction";
    steper.addBtnImg = @"btn-num_addCart";
    self.steper = steper;
    
    UIButton *selectedTypeBtn = [UIButton new];
    [self.contentView addSubview:selectedTypeBtn];
    [selectedTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(priceLab.mas_centerY).offset=0;
        make.width.offset=60;
        make.height.offset=25;
    }];
    selectedTypeBtn.backgroundColor = HEX(@"4DC831", 1.0);
    selectedTypeBtn.titleLabel.font = FONT(11);
    selectedTypeBtn.layer.cornerRadius=12.5;
    selectedTypeBtn.clipsToBounds=YES;
    selectedTypeBtn.hidden = YES;
    [selectedTypeBtn setTitle:NSLocalizedString(@"选规格", nil) forState:UIControlStateNormal];
    [selectedTypeBtn addTarget:self action:@selector(chooseGoodType) forControlEvents:UIControlEventTouchUpInside];
    self.selectedTypeBtn = selectedTypeBtn;
    
    UILabel *guiCountLab = [UILabel new];
    [self.contentView addSubview:guiCountLab];
    [guiCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectedTypeBtn.mas_right).offset=5;
        make.top.equalTo(selectedTypeBtn.mas_top).offset=-5;
        make.height.offset = 10;
        make.width.greaterThanOrEqualTo(@18);
    }];
    guiCountLab.backgroundColor = HEX(@"ff2200", 1.0);
    guiCountLab.textColor = [UIColor whiteColor];
    guiCountLab.layer.cornerRadius=5;
    guiCountLab.font = FONT(10);
    guiCountLab.textAlignment = NSTextAlignmentCenter;
    guiCountLab.hidden = YES;
    guiCountLab.clipsToBounds=YES;
    
    self.guiCountLab = guiCountLab;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(priceLab.mas_bottom).offset=10;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    UILabel *lab = [UILabel new];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lineView.mas_bottom).offset=10;
        make.height.offset=15;
    }];
    lab.font = FONT(14);
    lab.text = NSLocalizedString(@"商品信息", nil);
    lab.textColor = HEX(@"999999", 1.0);
    
    UILabel *infoLab = [UILabel new];
    [self.contentView addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(lab.mas_bottom).offset=10;
        make.right.offset=-10;
        make.bottom.offset=-10;
    }];
    infoLab.font = FONT(13);
    infoLab.textColor = HEX(@"666666", 1.0);
    self.infoLab = infoLab;
    infoLab.numberOfLines = 0;
}

-(void)reloadCellWithModel:(WMShopGoodModel *)model{

    self.titleLab.text = model.title;
    NSString *intro;
    if (model.intro.length == 0) {
        intro = NSLocalizedString(@"       暂无商品信息", NSStringFromClass([self class]));
    }else intro = [@"       " stringByAppendingString:model.intro];
    
    self.infoLab.attributedText = [NSString getParagraphStyleAttributeStr:intro lineSpacing:5];
    self.desLab.text = [NSString stringWithFormat:NSLocalizedString(@"已售%@  赞%@", @"WMGoodDetailCellOne"),model.sales,model.good];
    NSString *str = model.price;
    if (model.unit.length != 0) {
        str = [NSString stringWithFormat:@"%@/%@",str,model.unit];
    }
    self.priceLab.attributedText = [NSString priceLabText:str attributeFont:16];
    self.steper.hidden = model.is_spec || model.is_specification;
    self.selectedTypeBtn.hidden = !model.is_spec && !model.is_specification;
    self.is_gui = model.is_spec;
    self.good_id = model.product_id;
    int count = [[WMShopDBModel shareWMShopDBModel] getShopGoodChoosedCountFromDB:model.product_id choosedSize_id:nil propretyStr:nil good:model];
    if (model.is_spec) {// 规格商品
        self.guiCountLab.text = [NSString stringWithFormat:@"%d",count];
        self.guiCountLab.hidden = count == 0 ? YES : NO;
        for (WMShopGoodSpecModel *spec in model.specs) {
            if ([model.choosedSize_id isEqualToString:spec.spec_id]) {
                self.steper.maxCount = count == 0 ? model.choosedSize_sale_ku :(model.remain_count+ count);//spec.sale_sku;
            }
        }
    }else if (model.is_specification) {// 非规格商品但是属性商品
        self.guiCountLab.text = [NSString stringWithFormat:@"%d",count];
        self.guiCountLab.hidden = count == 0 ? YES : NO;
        self.steper.maxCount = count == 0 ? model.sale_sku :(model.remain_count+ count);//model.sale_sku;
    }else{// 普通商品
        self.steper.maxCount = count == 0 ? model.sale_sku :(model.remain_count+ count);//model.sale_sku;
        self.steper.currentCount = count;
        self.guiCountLab.hidden = YES;
    }
    
    if (model.sale_sku == 0) {
        self.steper.hidden = YES;
        self.selectedTypeBtn.hidden = NO;
        self.selectedTypeBtn.userInteractionEnabled = NO;
        self.selectedTypeBtn.backgroundColor = LINE_COLOR;
        [self.selectedTypeBtn setTitle:NSLocalizedString(@"已售罄",nil) forState:UIControlStateNormal];
    }else{
        self.selectedTypeBtn.userInteractionEnabled = YES;
        self.selectedTypeBtn.backgroundColor = HEX(@"4DC831", 1.0);
        [self.selectedTypeBtn setTitle:NSLocalizedString(@"选规格", nil)  forState:UIControlStateNormal];
    }
    
    self.discountLab.hidden = !model.is_discount;
    self.discountDesLab.hidden = !model.is_discount;
    if (model.is_discount) {
        self.discountLab.text = model.disclabel;
        NSString *desStr = [NSString stringWithFormat: NSLocalizedString(@"%@  剩余%d份", NSStringFromClass([self class])),model.quotalabel,model.sale_sku];
        self.discountDesLab.attributedText = [NSString getAttributeString:desStr dealStr:model.quotalabel strAttributeDic:@{NSForegroundColorAttributeName: HEX(@"ff4848", 1.0)}];
        NSString *str = [ NSLocalizedString(@"¥ ", NSStringFromClass([self class])) stringByAppendingString:model.oldprice];
        self.oldPriceLab.attributedText = [NSString getAttributeString:str strAttributeDic:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName : HEX(@"b3b3b3", 1.0)}];
        [self.priceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.discountLab.mas_bottom).offset=10;
            make.left.offset=10;
            make.height.offset= 20;
        }];
    }else{
        self.oldPriceLab.attributedText = nil;
        [self.priceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.desLab.mas_bottom).offset=10;
            make.left.offset=10;
            make.height.offset= 20;
        }];
    }

}

#pragma mark ====== Functions =======
// 选择规格
-(void)chooseGoodType{
    
    if (self.chooseGoodSize) {
        self.chooseGoodSize();
    }
}

-(void)countChange:(int)count{
    if (count == 0) {
        [self.steper startAniamtion:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.steper.currentCount = 0;
        });
        return;
    }
    self.steper.currentCount = count;
}

#pragma mark ======YFSteperDelegate=======
-(void)addCount{
    if (self.productNumChange) {
        self.productNumChange(self.steper.addBtn);
    }
}

-(void)subCount:(int)count{
    if (self.productNumChange) {
        self.productNumChange(nil);
    }
}

@end
