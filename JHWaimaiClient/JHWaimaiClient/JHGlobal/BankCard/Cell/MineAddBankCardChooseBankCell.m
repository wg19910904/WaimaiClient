//
//  MineAddBankCardChooseBankCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "MineAddBankCardChooseBankCell.h"

@implementation MineAddBankCardChooseBankCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *lab = [UILabel new];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.width.offset = 50;
        make.height.offset=20;
    }];
    lab.font = FONT(14);
    lab.textColor = HEX(@"333333", 1.0);
    lab.text = NSLocalizedString(@"卡类型", NSStringFromClass([self class]));
    
    NSArray *arr = @[@{@"normal":@"card_visa",@"selected":@"card_visa_pre"},
                     @{@"normal":@"card_master",@"selected":@"card_master_pre"},
                     @{@"normal":@"card_ae",@"selected":@"card_ae_pre"}];
    
    CGFloat btnW = 44;
    CGFloat btnH = 28;
    CGFloat margin = 10;
    for (NSInteger i=0; i<arr.count; i++) {
        
        UIButton *btn = [UIButton new];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab.mas_right).offset= margin + (btnW + margin) * i;
            make.centerY.offset=0;
            make.width.offset=btnW;
            make.height.offset=btnH;
        }];
        [btn setImage:IMAGE(arr[i][@"normal"]) forState:UIControlStateNormal];
        [btn setImage:IMAGE(arr[i][@"selected"]) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(chooseCardType:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = i == 0;
        btn.tag = 100 + i;
    }
}

-(void)reloadCellWithCartType:(int)type is_edit:(BOOL)is_edit{
    
    for (NSInteger i=0; i<3; i++) {
        UIButton *btn = [self viewWithTag:100 + i];
        btn.selected = NO;
        btn.hidden = is_edit;
    }
    if (is_edit) {
        UIButton *btn = [self viewWithTag:100];
        btn.hidden = NO;
        NSString *str = @"card_visa_pre";
        str = type == 2 ?  @"card_master_pre" : (type == 3 ? @"card_ae_pre" : str);
        [btn setImage:IMAGE(str) forState:UIControlStateNormal];
        return;
    }
    if (type == 1) {
        UIButton *btn = [self viewWithTag:100];
        btn.selected = YES;
    }else if (type == 2) {
        UIButton *btn = [self viewWithTag:101];
        btn.selected = YES;
    }else{
        UIButton *btn = [self viewWithTag:102];
        btn.selected = YES;
    }
}

-(void)chooseCardType:(UIButton *)btn{
    YF_SAFE_BLOCK(self.clickIndex,btn.tag - 100);
}

@end
