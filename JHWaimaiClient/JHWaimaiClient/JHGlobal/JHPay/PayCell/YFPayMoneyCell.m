//
//  YFPayMoneyCell.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/25.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFPayMoneyCell.h"
#import "YFTimerManager.h"

@interface YFPayMoneyCell ()<YFTimerDelegate>
@property(nonatomic,weak)UILabel *moneyLab;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,assign)NSInteger dateline;
@end

@implementation YFPayMoneyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *moneyLab = [UILabel new];
    [self.contentView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(20);
        make.height.offset(40);
        make.bottom.offset(-40);
    }];
    moneyLab.font = FONT(36);
    moneyLab.textColor = HEX(@"333333", 1.0);
    self.moneyLab = moneyLab;
    
    UILabel *desLab = [UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(moneyLab.mas_bottom).offset(0);
        make.height.offset(20);
    }];
    desLab.font = FONT(14);
    desLab.textColor = HEX(@"666666", 1.0);
    self.desLab = desLab;
    
    [YFTimerManager addTimerWithTimeInterval:1.0];

}

-(void)reloadCellWithMoney:(NSString *)money dateline:(NSInteger)dateline{
    
    self.dateline = dateline;
    NSInteger time_enough = dateline - [[NSDate date] timeIntervalSince1970];
    if (time_enough > 0) {
        [self toDoThingsWhenTimeCome:1.0];
        [YFTimerManager addTimerDelegate:self forTimeInterval:1.0];
    }else{
        [YFTimerManager deleteTimerDelegate:self forTimeInterval:1.0];
    }
    
    self.moneyLab.text = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),money];
    if (time_enough > 0) {
        [self.moneyLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(20);
            make.height.offset(40);
            make.bottom.offset(-40);
        }];
    }else{
        [self.moneyLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(30);
            make.height.offset(40);
            make.bottom.offset(-30);
        }];
    }

}

#pragma mark ====== YFTimerDelegate =======
-(void)toDoThingsWhenTimeCome:(NSTimeInterval)interval{
    
    CGFloat mul = interval < 1 ? 1000 : 1;
    
    NSTimeInterval dateline = self.dateline * mul - [[NSDate date] timeIntervalSince1970] * mul;
    
    int hour = (int)(dateline/3600/mul);
    int min = (int)(dateline-3600*hour * mul)/60/mul;
    int sec = (int)(dateline-3600*hour * mul - 60 * min * mul)/mul;

    hour = MAX(MIN(hour, 59), 0);
    min = MAX(MIN(min, 59), 0);
    sec = MAX(MIN(sec, 59), 0);

    if (min == 0) {
        self.desLab.text = [NSString stringWithFormat: NSLocalizedString(@"(支付剩余%02d秒)", NSStringFromClass([self class])),sec];
    }else{
        self.desLab.text = [NSString stringWithFormat: NSLocalizedString(@"(支付剩余%02d分%02d秒)", NSStringFromClass([self class])),min,sec];
    }
    
    if (dateline <= 0) {
        [YFTimerManager deleteTimerDelegate:self forTimeInterval:1.0];
        YF_SAFE_BLOCK(self.timeOverBlock,NO,@"");
    }
    
}

@end
