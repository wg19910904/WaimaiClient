//
//  JHWaimaiOrderDetailFooterView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/25.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailFooterView.h"
@interface JHWaimaiOrderDetailFooterView()
@property(nonatomic,strong)UILabel *leftLabel;//左边的按钮
@property(nonatomic,strong)UILabel *rightLabel;//右边的按钮
@end
@implementation JHWaimaiOrderDetailFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self leftLabel];
        [self rightLabel];
    }
    return self;
}
#pragma mark - 这是左边的按钮
-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.textColor = HEX(@"333333", 1);
        _leftLabel.font = FONT(14);
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 13;
            make.top.offset = 10;
            make.height.offset = 20;

        }];
    }
    return _leftLabel;
}
-(void)setModel:(JHWaimaiOrderDetailModel *)model{
    _model = model;
    float youhui = 0;
    for (NSDictionary *dic in model.youhui) {
        if(![dic[@"title"] isEqualToString: NSLocalizedString(@"购买会员卡", NSStringFromClass([self class]))]){
            youhui = youhui + [dic[@"amount"] floatValue];
        }
        
    }
    if (youhui == 0) {
         _leftLabel.text = [NSString stringWithFormat:NSLocalizedString(@"总计 ¥%@", nil),model.total_price];
    }else{
         _leftLabel.text = [NSString stringWithFormat:NSLocalizedString(@"总计 ¥%@  优惠 ¥%g", nil),model.total_price,youhui];
    }
    //判断显示实付还是货到付款
    if (model.pei_type.integerValue == 1 && [model.online_pay isEqualToString:@"0"]) {
        _rightLabel.text = [NSString stringWithFormat:NSLocalizedString(@"需货到付款 ¥%@", nil),model.amount];
    }else{
        _rightLabel.text = [NSString stringWithFormat:NSLocalizedString(@"实付 ¥%@", nil),model.amount];
    }
    
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc]initWithString:_rightLabel.text];
    [mutableStr addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1)} range:[_rightLabel.text rangeOfString:NSLocalizedString(@"实付", nil)]];
    _rightLabel.attributedText = mutableStr;

}
#pragma mark - 这是右边的按钮
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.textColor = HEX(@"ff6600", 1);
        _rightLabel.font = FONT(14);
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -13;
            make.top.offset = 10;
            make.height.offset = 20;
        }];
    }
    return _rightLabel;
}
@end
