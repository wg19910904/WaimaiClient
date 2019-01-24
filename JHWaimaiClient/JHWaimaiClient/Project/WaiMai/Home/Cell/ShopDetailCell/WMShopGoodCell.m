//
//  WMShopGoodCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopGoodCell.h"
#import "YFSteper.h"
#import <UIImageView+WebCache.h>
#import "NSString+Tool.h"

@interface WMShopGoodCell ()<YFSteperDelegate>
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UILabel *saleCountLab;
@property(nonatomic,weak)UILabel *discountLab;// 折扣lab

@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *oldPriceLab;

@property(nonatomic,weak)YFSteper *steper;
@property(nonatomic,weak)UIButton *selectedTypeBtn;
@property(nonatomic,weak)UILabel *guiCountLab;// 规格商品选择的总数
@property(nonatomic,copy)NSString *good_id;

@end

@implementation WMShopGoodCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.width.offset=95;
        make.height.offset=95;
    }];
    self.iconImgView = iconImgView;
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.clipsToBounds = YES;
    iconImgView.layer.cornerRadius=2;
    iconImgView.clipsToBounds=YES;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.font = B_FONT(16);
    titleLab.numberOfLines = 2;
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
    UILabel *desLab = [UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.equalTo(titleLab.mas_bottom).offset = 5;
        make.height.offset = 20;
        make.right.offset=-10;
    }];
    desLab.textColor = HEX(@"999999", 1.0);
    desLab.font = FONT(12);
    desLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.desLab = desLab;
    
    UILabel *saleCountLab = [UILabel new];
    [self.contentView addSubview:saleCountLab];
    [saleCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.equalTo(desLab.mas_bottom).offset = 5;
        make.right.offset=-40;
        make.height.offset=20;
    }];
    saleCountLab.textColor = HEX(@"999999", 1.0);
    saleCountLab.font = FONT(12);
    saleCountLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.saleCountLab = saleCountLab;
    
    UILabel *discountLab = [UILabel new];
    [self.contentView addSubview:discountLab];
    [discountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.equalTo(saleCountLab.mas_bottom).offset = 5;
        make.width.greaterThanOrEqualTo(@50);
        make.height.offset=16;
    }];
    discountLab.textColor = HEX(@"FB604C", 1.0);
    discountLab.font = FONT(12);
    discountLab.backgroundColor = HEX(@"FFF2F0", 1);
    discountLab.layer.cornerRadius=4;
    discountLab.clipsToBounds=YES;
    discountLab.textAlignment = NSTextAlignmentCenter;
    self.discountLab = discountLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.equalTo(discountLab.mas_bottom).offset = 5;
        make.height.offset=20;
    }];
    priceLab.textColor = HEX(@"ff6600", 1.0);
    priceLab.font = FONT(12);
    self.priceLab = priceLab;
    
    UILabel *oldPriceLab = [UILabel new];
    [self.contentView addSubview:oldPriceLab];
    [oldPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLab.mas_centerY).offset=0;
        make.left.equalTo(priceLab.mas_right).offset=5;
        make.height.offset=20;
    }];
    oldPriceLab.textColor = HEX(@"b3b3b3", 1.0);
    oldPriceLab.font = FONT(12);
    self.oldPriceLab = oldPriceLab;

    YFSteper *steper = [YFSteper new];
    [self.contentView addSubview:steper];
    [steper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(oldPriceLab.mas_centerY);
        make.width.offset=80;
        make.height.offset=40;
    }];
    steper.minCount = 0;
    steper.delegate = self;
    steper.subBtnImg = @"btn-num_subtraction";
    steper.addBtnImg = @"btn-num_addCart";
    self.steper = steper;
    steper.layer.cornerRadius=20;
    steper.clipsToBounds=YES;
    
//    UIButton *selectedTypeBtn = [UIButton new];
//    [self.contentView addSubview:selectedTypeBtn];
//    [selectedTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset=-10;
//        make.centerY.equalTo(steper.mas_centerY);
//        make.width.offset=70;
//        make.height.offset=25;
//    }];
//    selectedTypeBtn.backgroundColor = HEX(@"4DC831", 1.0);
//    selectedTypeBtn.titleLabel.font = FONT(11);
//    selectedTypeBtn.layer.cornerRadius=12.5;
//    selectedTypeBtn.clipsToBounds=YES;
//    selectedTypeBtn.hidden = YES;
//    
//    [selectedTypeBtn setTitle:NSLocalizedString(@"选规格", @"WMShopGoodCell") forState:UIControlStateNormal];
//    [selectedTypeBtn addTarget:self action:@selector(chooseGoodType) forControlEvents:UIControlEventTouchUpInside];
//    self.selectedTypeBtn = selectedTypeBtn;
    
    UIButton *selectedTypeBtn = [UIButton new];
    [self.contentView addSubview:selectedTypeBtn];
    [selectedTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(steper.mas_centerY);
        make.width.offset=22;
        make.height.offset=22;
    }];
    selectedTypeBtn.titleLabel.font = FONT(11);
    selectedTypeBtn.layer.cornerRadius=11;
    selectedTypeBtn.clipsToBounds=YES;
    selectedTypeBtn.hidden = YES;
    [selectedTypeBtn setTitle:NSLocalizedString(@"选", @"WMShopGoodCell") forState:UIControlStateNormal];
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
    
    
}

-(void)reloadCellWithModel:(WMShopGoodModel *)model{
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.photo)] placeholderImage:IMAGE(@"product60_default")];
    self.titleLab.text = model.title;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( self.iconImgView.mas_right).offset=10;
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.offset=-10;
    }];
    self.saleCountLab.text = [NSString stringWithFormat:@"%@%@   %@%@", NSLocalizedString(@"已售", nil),model.sales, NSLocalizedString(@"赞", @"WMShopGoodCell"),model.good];
    NSString *str = model.price;
    if (model.unit.length != 0) {
        str = [NSString stringWithFormat:@"%@/%@",str,model.unit];
    }
    self.priceLab.attributedText = [NSString priceLabText:str attributeFont:14];

    self.steper.hidden = model.is_spec || model.is_specification;
    self.selectedTypeBtn.hidden = !model.is_spec && !model.is_specification;
    
    self.good_id = model.product_id;
    int count = [[WMShopDBModel shareWMShopDBModel] getShopGoodChoosedCountFromDB:model.product_id choosedSize_id:nil propretyStr:nil good:model];
    if (model.is_spec) {// 规格商品
        self.guiCountLab.text = [NSString stringWithFormat:@"%d",count];
        self.guiCountLab.hidden = count == 0 ? YES : NO;
        for (WMShopGoodSpecModel *spec in model.specs) {
            if ([model.choosedSize_id isEqualToString:spec.spec_id]) {
                self.steper.maxCount = spec.sale_sku;
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
        [self.selectedTypeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset= 0;
            make.centerY.equalTo(self.steper.mas_centerY);
            make.width.offset=50;
            make.height.offset=25;
        }];
        self.steper.hidden = YES;
        self.selectedTypeBtn.hidden = NO;
        self.selectedTypeBtn.userInteractionEnabled = NO;
        self.selectedTypeBtn.backgroundColor = [UIColor clearColor];
        [self.selectedTypeBtn setTitle:NSLocalizedString(@"已售罄", nil) forState:UIControlStateNormal];
        [self.selectedTypeBtn setTitleColor:HEX(@"999999", 1.0) forState:UIControlStateNormal];
    }else{
        [self.selectedTypeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-10;
            make.centerY.equalTo(self.steper.mas_centerY);
            make.width.offset=22;
            make.height.offset=22;
        }];
        self.selectedTypeBtn.userInteractionEnabled = YES;
        self.selectedTypeBtn.backgroundColor = HEX(@"4DC831", 1.0);
        [self.selectedTypeBtn setTitle:NSLocalizedString(@"选", @"WMShopGoodCell") forState:UIControlStateNormal];
        [self.selectedTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }

    self.discountLab.hidden = !model.is_discount;
    
    self.desLab.text = model.intro;
    self.desLab.hidden = model.intro.length == 0;
    if (model.intro.length == 0) {
        [self.saleCountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).offset=10;
            make.top.equalTo(self.titleLab.mas_bottom).offset = 5;
            make.right.offset=-40;
            make.height.offset=20;
        }];
    }else{
        [self.saleCountLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).offset=10;
            make.top.equalTo(self.desLab.mas_bottom).offset(5);
            make.right.offset=-40;
            make.height.offset=20;
        }];
    }

    if (model.is_discount) {
        if (model.quotalabel.length == 0) {
            self.discountLab.text = model.disclabel;
        }else{
            self.discountLab.text = [model.disclabel stringByAppendingString:[NSString stringWithFormat:@",%@",model.quotalabel]];
        }
        
        NSString *str = [ NSLocalizedString(@"¥ ", NSStringFromClass([self class])) stringByAppendingString:model.oldprice];
        self.oldPriceLab.attributedText = [NSString getAttributeString:str strAttributeDic:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName : HEX(@"b3b3b3", 1.0)}];
        [self.priceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).offset=10;
            make.top.equalTo(self.discountLab.mas_bottom).offset = 5;
            make.height.offset=20;
        }];
    }else{
        self.oldPriceLab.attributedText = nil;
        if (model.intro.length == 0) {// 没有折扣,也没有描述
            [self.priceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconImgView.mas_right).offset=10;
                make.height.offset=20;
                make.bottom.offset = -15;
            }];
        }else{
            [self.priceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconImgView.mas_right).offset=10;
                make.top.equalTo(self.saleCountLab.mas_bottom).offset = 5;
                make.height.offset=20;
            }];
        }
        
    }

}

-(void)reloadCellWithModel:(WMShopGoodModel *)model keyword:(NSString *)keyword{
    
    NSRange range = [model.title rangeOfString:keyword];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.title];
    [attStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR_Alpha(1.0) range:range];
    self.titleLab.attributedText = attStr;
    
    [self reloadCellWithModel:model];
    
    
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

-(void)countNumChange:(int)count{
    
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    CGPoint pt = [self convertPoint:point toView:self.contentView];
    CGRect rect = FRAME(self.steper.x - 10, self.steper.y - 10, self.steper.width + 20 , self.steper.height + 20);
    BOOL contains = CGRectContainsPoint(rect, pt);

    UIView *view = [super hitTest:point withEvent:event];
    if (contains) {
        if ([view isKindOfClass:[UIButton class]]) {
            return view;
        }
        return nil;
    }
    return [super hitTest:point withEvent:event];

}

@end
