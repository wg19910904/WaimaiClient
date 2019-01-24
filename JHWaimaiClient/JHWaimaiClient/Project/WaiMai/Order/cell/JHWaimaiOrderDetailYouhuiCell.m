//
//  JHWaimaiOrderDetailYouhuiCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailYouhuiCell.h"
@interface JHWaimaiOrderDetailYouhuiCell()
@property(nonatomic,strong)UIView *bottomLine;//底部的线
@property(nonatomic,strong)NSMutableArray *infoArr;
@end
@implementation JHWaimaiOrderDetailYouhuiCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self bottomLine];
        _infoArr = @[].mutableCopy;
    }
    return self;
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
    [self creatYouhui];
}
#pragma mark = 创建优惠的方案
-(void)creatYouhui{
    for (UILabel *lab  in _infoArr) {
        [lab removeFromSuperview];
    }
    [_infoArr removeAllObjects];
    for (int i = 0; i < _arr.count; i++) {
        NSDictionary *dic = _arr[i];
        //显示优惠方式的
        UILabel *label = [[UILabel alloc]init];
        label.textColor = HEX(@"333333", 1);
        label.text = dic[@"title"];
        label.font = FONT(14);
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 32;
            make.height.offset = 16;
            make.top.offset = 13+(16+10)*i;
            if (i == _arr.count-1) {
                 make.bottom.offset = -13;
            }
        }];
        //显示优惠图标
        UILabel *imgL = [[UILabel alloc]init];
        imgL.backgroundColor = HEX(dic[@"color"], 1);
        imgL.text = dic[@"word"];
        imgL.textColor = HEX(@"ffffff", 1);
        imgL.font = FONT(10);
        imgL.layer.cornerRadius = 2;
        imgL.layer.masksToBounds = YES;
        imgL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:imgL];
        [imgL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 13;
            make.height.offset = 14;
            make.width.offset = 14;
            make.top.offset = 14+(14+12)*i;

        }];
        
        //显示优惠的金额的
        UILabel *priceL = [[UILabel alloc]init];
//        if([dic[@"title"] isEqualToString: NSLocalizedString(@"购买会员卡", NSStringFromClass([self class]))]){
//            priceL.text = [NSString stringWithFormat:NSLocalizedString(@"¥%@", nil),dic[@"amount"]];
//        }else{
//            priceL.text = [NSString stringWithFormat:NSLocalizedString(@"-¥%@", nil),dic[@"amount"]];
//        }
        priceL.text = [NSString stringWithFormat:NSLocalizedString(@"%@%@", nil),dic[@"addSub"],dic[@"amount"]];
        
        priceL.textColor = HEX(@"ff6600", 1);
        priceL.font = FONT(14);
        [self addSubview:priceL];
        [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -13;
            make.height.offset = 16;
            make.top.offset = 13+(16+10)*i;
        }];
        [_infoArr addObject:label];
        [_infoArr addObject:imgL];
        [_infoArr addObject:priceL];
        
    }
}
@end
