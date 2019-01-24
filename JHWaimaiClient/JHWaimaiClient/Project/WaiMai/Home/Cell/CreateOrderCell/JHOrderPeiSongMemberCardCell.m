//
//  JHOrderBuyHongBaoCardCell.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHOrderPeiSongMemberCardCell.h"
#import "YFTypeBtn.h"

@interface JHOrderPeiSongMemberCardCell()
@property(nonatomic,weak)YFTypeBtn *titleBtn;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *moneyLab;
@property(nonatomic,weak)YFTypeBtn *chooseBtn;
@end

@implementation JHOrderPeiSongMemberCardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *backView = [UIView new];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(5);
        make.right.offset(-10);
        make.height.offset(80);
        make.bottom.offset(-5);
    }];
    backView.backgroundColor = HEX(@"f5f5f5", 1.0);
    backView.layer.cornerRadius=4;
    backView.clipsToBounds=YES;
    
    YFTypeBtn *titleBtn = [YFTypeBtn new];
    [backView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(5);
        make.height.offset(40);
    }];
    titleBtn.btnType = RightImage;
    titleBtn.imageMargin = 5;
    titleBtn.titleLabel.font = FONT(16);
    [titleBtn setImage:IMAGE(@"btn_arrow_right_small") forState:UIControlStateNormal];
    [titleBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(clickShowPeiSongList) forControlEvents:UIControlEventTouchUpInside];
    self.titleBtn = titleBtn;
    
    UILabel *timeLab = [UILabel new];
    [backView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-10);
        make.height.offset(20);
    }];
    timeLab.font = FONT(12);
    timeLab.textColor = HEX(@"999999", 1.0);
    self.timeLab = timeLab;
    
    YFTypeBtn *chooseBtn = [YFTypeBtn new];
    [backView addSubview:chooseBtn];
    [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.offset(2);
        make.height.offset(40);
    }];
    chooseBtn.btnType = RightImage;
    chooseBtn.titleMargin = -10;
    chooseBtn.imageMargin = 10;
    chooseBtn.titleLabel.font = FONT(16);
    [chooseBtn setImage:IMAGE(@"icon_radio") forState:UIControlStateNormal];
    [chooseBtn setImage:IMAGE(@"icon_radio_selected_new") forState:UIControlStateSelected];
    [chooseBtn setTitleColor:HEX(@"FA4C34", 1.0) forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(clickChooesed:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseBtn = chooseBtn;
    
    
}

/*
 "card_id": "5",
 "title": "60天卡",
 "days": "60",      会员卡有效期限
 "amount": "60.00", 会员卡购买金额
 "limits": "2",     单日可使用次数
 "reduce": "1.00",  每单可减免金额
 */
-(void)reloadCellWithInfo:(NSDictionary *)cardInfo selected:(BOOL)is_select{
    
    NSString *title = [NSString stringWithFormat: NSLocalizedString(@"%@,每单立减¥%@配送费", NSStringFromClass([self class])),cardInfo[@"title"],cardInfo[@"reduce"]];
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
    self.timeLab.text = [NSString stringWithFormat: NSLocalizedString(@"有效期限%@天", NSStringFromClass([self class])),cardInfo[@"days"]];
    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"¥ %@", NSStringFromClass([self class])),cardInfo[@"amount"]];
    [self.chooseBtn setTitle:str forState:UIControlStateNormal];
    self.chooseBtn.selected = is_select;
}

-(void)clickChooesed:(UIButton *)btn{
    YF_SAFE_BLOCK(self.chooesedBlock,!btn.selected,@"");
}

-(void)clickShowPeiSongList{
    YF_SAFE_BLOCK(self.showPeiSongList,NO,@"");
}

@end
