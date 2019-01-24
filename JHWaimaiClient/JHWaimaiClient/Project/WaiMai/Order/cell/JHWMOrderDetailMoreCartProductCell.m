//
//  JHWMOrderDetailMoreCartProductCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/8/9.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWMOrderDetailMoreCartProductCell.h"
#import "NSString+Tool.h"
#import <UIImageView+WebCache.h>

@interface JHWMOrderDetailMoreCartProductCell ()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *oldpriceLab;
@end

@implementation JHWMOrderDetailMoreCartProductCell

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
        make.centerY.offset(0);
        make.left.offset(40);
        make.width.lessThanOrEqualTo(@120);
        make.height.offset(20);
        make.top.offset(5);
        make.bottom.offset(-5);
    }];
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.font = FONT(14);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-130);
        make.height.offset(20);
    }];
    countLab.textColor = HEX(@"333333", 1.0);
    countLab.font = FONT(14);
    countLab.textAlignment = NSTextAlignmentCenter;
    self.countLab = countLab;
    
    UILabel *oldpriceLab = [UILabel new];
    [self.contentView addSubview:oldpriceLab];
    [oldpriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-80);
        make.height.offset(20);
    }];
    oldpriceLab.textColor = HEX(@"999999", 1.0);
    oldpriceLab.font = FONT(12);
    self.oldpriceLab = oldpriceLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-10);
        make.height.offset(20);
    }];
    priceLab.textColor = HEX(@"333333", 1.0);
    priceLab.font = FONT(14);
    self.priceLab = priceLab;
    
}

-(void)reloadCellWithModel:(NSDictionary *)dic{

    self.titleLab.text = dic[@"product_name"];
    self.countLab.text = [NSString stringWithFormat:@"x%@",dic[@"product_number"]];
    self.priceLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"¥", nil),dic[@"product_prices"]];
    if (![dic[@"product_prices"] isEqualToString:dic[@"product_oldprices"]]) {
        NSString *oldPrice = [ NSLocalizedString(@"¥ ", NSStringFromClass([self class])) stringByAppendingString:dic[@"product_oldprices"]];
        self.oldpriceLab.attributedText = [NSString getAttributeString:oldPrice strAttributeDic:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName : HEX(@"b3b3b3", 1.0)}];
    }else{
        self.oldpriceLab.attributedText = nil;
    }
    
    NSString *str = dic[@"product_name"];
    NSArray *arr = dic[@"specification"];
    if (arr.count > 0) {
        NSString * propretyStr;
        for (NSDictionary *dic in arr) {
            if (propretyStr.length == 0) {
                propretyStr = [NSString stringWithFormat:@"\n%@",dic[@"val"]];
            }else{
                propretyStr = [NSString stringWithFormat:@"%@ + %@",propretyStr,dic[@"val"]];
            }
        }
        str = [str stringByAppendingString:propretyStr];
        NSAttributedString *attStr = [NSString getAttributeString:str dealStr:propretyStr strAttributeDic:@{NSFontAttributeName : FONT(10),NSForegroundColorAttributeName : HEX(@"666666", 1.0)}];
        self.titleLab.attributedText = [NSString addParagraphStyleAttributeStrWithAttributeStr:attStr lineSpacing:3];
        
    }else{
        self.titleLab.text = str;
    }
}

@end

