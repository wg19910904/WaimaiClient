//
//  OrderGoodCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "OrderGoodCell.h"
#import "NSString+Tool.h"

@interface OrderGoodCell()
@property(nonatomic,weak)UILabel *leftLab;
@property(nonatomic,weak)UILabel *rightLab;
@property(nonatomic,weak)UILabel *centerLab;
@property(nonatomic,weak)UILabel *oldPricesLab;// 按原价算的价格
@end

@implementation OrderGoodCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
        self.backgroundColor = BACK_COLOR;
    }
    return self;
}

-(void)configUI{
    
    UILabel *leftLab = [UILabel new];
    [self.contentView addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=5;
        make.width.lessThanOrEqualTo(@170);
        make.height.greaterThanOrEqualTo(@30);
        make.bottom.offset = -5;
    }];
    leftLab.numberOfLines = 0;
    leftLab.font = FONT(12);
    leftLab.textColor = TEXT_COLOR;
    self.leftLab = leftLab;
    
    UILabel *centerLab = [UILabel new];
    [self.contentView addSubview:centerLab];
    [centerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=40;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    centerLab.textAlignment = NSTextAlignmentCenter;
    centerLab.font = FONT(12);
    centerLab.textColor = TEXT_COLOR;
    self.centerLab = centerLab;
    
    UILabel *rightLab = [UILabel new];
    [self.contentView addSubview:rightLab];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = FONT(12);
    rightLab.textColor = TEXT_COLOR;
    self.rightLab = rightLab;
    
    UILabel *oldPricesLab = [UILabel new];
    [self.contentView addSubview:oldPricesLab];
    [oldPricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightLab.mas_left).offset=-10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];
    oldPricesLab.textAlignment = NSTextAlignmentRight;
    oldPricesLab.font = FONT(10);
    oldPricesLab.textColor = HEX(@"b3b3b3", 1.0);
    self.oldPricesLab = oldPricesLab;
  
}

-(void)reloadCellWithGoodInfo:(NSDictionary *)dic{
    NSString *str = dic[@"title"];
    if ([dic[@"spec_name"] length] != 0) {
        str  = [NSString stringWithFormat:@"%@(%@)",dic[@"title"],dic[@"spec_name"]];
    }
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
        self.leftLab.attributedText = [NSString addParagraphStyleAttributeStrWithAttributeStr:attStr lineSpacing:3];
        
    }else{
        self.leftLab.text = str;
    }

    self.oldPricesLab.hidden = [dic[@"prices"] isEqualToString:dic[@"oldprices"]];
    NSString *oldPrice = [ NSLocalizedString(@"¥ ", NSStringFromClass([self class])) stringByAppendingString:dic[@"oldprices"]];
    self.oldPricesLab.attributedText = [NSString getAttributeString:oldPrice strAttributeDic:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName : HEX(@"b3b3b3", 1.0)}];
    self.rightLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"¥", nil),dic[@"prices"]];
    self.centerLab.text = [NSString stringWithFormat:@"x%@",dic[@"num"]];
}

//-(void)reloadCell:(NSString *)leftStr rightStr:(NSString *)rightStr count:(NSString *)count{
//    self.leftLab.text = leftStr;
//    self.rightLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"¥", nil),rightStr];
//    self.centerLab.text = [NSString stringWithFormat:@"x%@",count];
//}

@end
