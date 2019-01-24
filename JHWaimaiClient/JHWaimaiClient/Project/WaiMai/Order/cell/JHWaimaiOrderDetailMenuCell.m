//
//  JHWaimaiOrderDetailMenuCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailMenuCell.h"
#import "NSString+Tool.h"

@interface JHWaimaiOrderDetailMenuCell()
@property(nonatomic,strong)UIView *topLine;//顶部的线
@property(nonatomic,strong)UIView *bottomLine;//底部的线
@property(nonatomic,strong)NSMutableArray *subViewArr;
@end
@implementation JHWaimaiOrderDetailMenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //顶部的线
        [self topLine];
        //底部的线
        [self bottomLine];
        _subViewArr = @[].mutableCopy;
    }
    return self;
}
#pragma mark - 顶部的线
-(UIView *)topLine{
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = LINE_COLOR;
        [self addSubview:_topLine];
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.offset = 0;
            make.height.offset = 0.5;
        }];
    }
    return _topLine;
}
#pragma mark - 底部的线
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = LINE_COLOR;
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.offset = 0;
            make.height.offset = 0.5;
        }];
    }
    return _bottomLine;

}
-(void)setArr:(NSArray *)arr{
    _arr = arr;
    //创建的菜单
    [self creatMenu];
}
#pragma mark - 创建菜单
-(void)creatMenu{
    for (UILabel *labe in _subViewArr) {
        [labe removeFromSuperview];
    }
    [_subViewArr removeAllObjects];
    for (int i = 0; i < self.arr.count; i++) {
        NSArray *basketArr = self.arr[i][@"product"];
        for (int i = 0; i < basketArr.count; i++) {
             NSDictionary *dic = basketArr[i];
            //菜单的名字
            UILabel *nameL = [[UILabel alloc]init];
            nameL.numberOfLines = 0;
            nameL.textColor = HEX(@"666666", 1);
            nameL.font = FONT(12);
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
                nameL.attributedText = [NSString addParagraphStyleAttributeStrWithAttributeStr:attStr lineSpacing:3];
                
            }else{
                nameL.text = str;
            }
            
            [self addSubview:nameL];
            [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset = 13;
                make.top.offset = 15+(30+10)*i;
                make.height.offset = 30;
                make.width.lessThanOrEqualTo(@220);
                if (i == basketArr.count-1) {
                    make.bottom.offset = -15;
                }
                
            }];
            //显示份数的
            UILabel *numL = [[UILabel alloc]init];
            numL.text = [NSString stringWithFormat:@"x%@",dic[@"product_number"]];
            numL.font = FONT(12);
            numL.textColor = HEX(@"333333", 1);
            [self addSubview:numL];
            [numL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset = 40;
                make.centerY.mas_equalTo(nameL.mas_centerY);
                make.height.offset = 15;
                make.left.mas_equalTo(nameL.mas_right).offset = 5;
            }];
            //显示价格的的
            UILabel *priceL = [[UILabel alloc]init];
            //        NSInteger num = [dic[@"product_number"]  integerValue];
            //        CGFloat price = [dic[@"product_price"] doubleValue];
            //        CGFloat price_all = num * price;
            priceL.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"¥", nil),dic[@"product_prices"]];
            priceL.font = FONT(12);
            priceL.textColor = HEX(@"333333", 1);
            [self addSubview:priceL];
            [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset = -12;
                make.centerY.mas_equalTo(nameL.mas_centerY);
                make.height.offset = 15;
                
            }];
            
            if (![dic[@"product_prices"] isEqualToString:dic[@"product_oldprices"]]) {
                UILabel *oldPricesLab = [UILabel new];
                [self addSubview:oldPricesLab];
                [oldPricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(priceL.mas_left).offset=-10;
                    make.centerY.mas_equalTo(nameL.mas_centerY);
                    make.height.offset=20;
                }];
                oldPricesLab.textAlignment = NSTextAlignmentRight;
                oldPricesLab.font = FONT(10);
                oldPricesLab.textColor = HEX(@"b3b3b3", 1.0);
                
                NSString *oldPrice = [ NSLocalizedString(@"¥ ", NSStringFromClass([self class])) stringByAppendingString:dic[@"product_oldprices"]];
                oldPricesLab.attributedText = [NSString getAttributeString:oldPrice strAttributeDic:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName : HEX(@"b3b3b3", 1.0)}];
                [_subViewArr addObject:oldPricesLab];
            }
            [_subViewArr addObject:nameL];
            [_subViewArr addObject:numL];
            [_subViewArr addObject:priceL];
        }
        
    }
}
@end
