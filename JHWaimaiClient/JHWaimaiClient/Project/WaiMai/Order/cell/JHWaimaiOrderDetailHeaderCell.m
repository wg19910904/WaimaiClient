//
//  JHWaimaiOrderDetailHeaderCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailHeaderCell.h"
#import "YFTypeBtn.h"
#import "JHAllOrderDetailStatusView.h"

@interface JHWaimaiOrderDetailHeaderCell(){
    NSString *oldTimer;
    NSInteger time;
}
@property(nonatomic,strong)YFTypeBtn *headerBtn;//顶部的按钮
@property(nonatomic,strong)UILabel *labelStatus;//展示提示语的
@property(nonatomic,weak)JHAllOrderDetailStatusView *statusView;
@end
@implementation JHWaimaiOrderDetailHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self headerBtn];
        [self labelStatus];

        JHAllOrderDetailStatusView *statusView = [JHAllOrderDetailStatusView new];
        [self.contentView addSubview:statusView];
        self.statusView = statusView;
    }
    return self;
}
#pragma mark - 顶部的按钮
-(YFTypeBtn *)headerBtn{
    if (!_headerBtn) {
        _headerBtn = [[YFTypeBtn alloc]init];
        _headerBtn.btnType = RightImage;
        _headerBtn.imageMargin = 5;
        _headerBtn.tag = 0;
        [_headerBtn setTitleColor:HEX(@"333333", 1) forState:UIControlStateNormal];
        _headerBtn.titleLabel.font = FONT(16);
        [_headerBtn setImage:IMAGE(@"icon-arrowR_white") forState:UIControlStateNormal];
        [self.contentView addSubview:_headerBtn];
        [_headerBtn addTarget:self action:@selector(clickToSeeOrderProgress) forControlEvents:UIControlEventTouchUpInside];
        [_headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 15;
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.offset = 20;
        }];
        
    }
    return _headerBtn;
}
#pragma mark - 点击去查看订单进度的
-(void)clickToSeeOrderProgress{
    YF_SAFE_BLOCK(self.showOrderScheduleBlock,YES,nil);
}
#pragma mark - 展示提示语的
-(UILabel *)labelStatus{
    if (!_labelStatus) {
        _labelStatus = [[UILabel alloc]init];
        _labelStatus.textColor = HEX(@"333333", 1);
        _labelStatus.font = FONT(12);
        [self.contentView addSubview:_labelStatus];
    }
    return _labelStatus;
}

-(void)setModel:(JHWaimaiOrderDetailModel *)model{
    
    _model = model;
    self.statusView.delegate = self.delegate;
    self.statusView.hidden = model.show_btn.count == 0 ;
    [self.statusView reloadViewWith:model];
    
    if(model.show_btn.count == 0 ){

        [_labelStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerBtn.mas_bottom).offset = 12;
            make.height.offset = 14;
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.offset = -12;
        }];
        
    }else{
        [_labelStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headerBtn.mas_bottom).offset = 12;
            make.height.offset = 14;
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    
    [self.statusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = (model.show_btn.count == 0 ? 0 : 60);
        make.bottom.offset = 0;
        make.left.offset(0);
        make.top.equalTo(self.labelStatus.mas_bottom);
        make.right.offset(0);
    }];

    [_headerBtn setTitle:model.order_status_label forState:UIControlStateNormal];
    //待评价
    if ([model.order_status integerValue] == 8 && [model.comment_status integerValue] == 0) {
        self.status = EWaimaiOrderStatus_waitToEvaluate;
        return;
    }
    //已评价
    if ([model.order_status integerValue] == 8 && [model.comment_status integerValue] == 1) {
        self.status = EWaimaiOrderStatus_hadEavaluate;
        return;
    }
    //退款中
    if ([model.refund integerValue] == 0) {
        self.status = EWaimaiOrderStatus_refunding;
        return;
    }
    //退款已拒绝
    if ([model.refund integerValue] == 2) {
        self.status = EWaimaiOrderStatus_hadNotRefund;
        return;
    }
    //客服介入中
    if ([model.refund integerValue] == 3) {
        self.status = EWaimaiOrderStatus_customering;
        return;
    }
    //已退款
    if ([model.order_status integerValue] == -2) {
        self.status = EWaimaiOrderStatus_hadRefund;
    }
    //取消
    if ([model.order_status integerValue] == -1) {
        self.status = EWaimaiOrderStatus_hadCancel;
    }
    //未支付的状态
    if ([model.order_status integerValue] == 0 && [model.pay_status integerValue] == 0&&[model.online_pay integerValue]==1) {
        NSInteger dateline = model.dao_time - [[NSDate date] timeIntervalSince1970];
        time = dateline;
        self.status = EWaimaiOrderStatus_waitToPay;
    }
    //等待商户接单的状态
    if ([model.order_status integerValue] == 0 && ([model.pay_status integerValue] == 1 || [model.online_pay integerValue] == 0)) {
        self.status = EWaimaiOrderStatus_waitShopGetOrder;
    }
    //商户已接单
    if ([model.order_status integerValue] == 1 || ([model.order_status integerValue] == 2 && [model.staff_id integerValue] <= 0)) {
        self.status = EWaimaiOrderStatus_ShopHadGetOrder;
    }
    //配送中
    if ([model.order_status integerValue] == 3 ||([model.order_status integerValue] == 2 && [model.staff_id integerValue] > 0)) {
        self.status = EWaimaiOrderStatus_distributing;
    }
    //配送完成
    if ([model.order_status integerValue] == 4) {
        self.status = EWaimaiOrderStatus_hadDistributed;
    }
    
    
}
-(void)setStatus:(NSInteger)status{
    _status = status;
    NSString *btnTitle = @"";
    if (_status == 0) {
        btnTitle = oldTimer;
    }else if (_status == 1){
        btnTitle = NSLocalizedString(@"请耐心等待,商家稍后会处理", nil);
    }else if (_status == 2){
        if ([_model.pei_type isEqualToString:NSLocalizedString(@"平台送", nil)]) {
            btnTitle = NSLocalizedString(@"等待配送员接单", nil);
        }else if ([_model.pei_type isEqualToString:NSLocalizedString(@"商家送", nil)]) {
            btnTitle = NSLocalizedString(@"请耐心等待送达", nil);
        }else{
            btnTitle = NSLocalizedString(@"等待自提中...", nil);
        }
    }else if (_status == 3 && [_model.order_status integerValue] == 2){
        btnTitle = NSLocalizedString(@"骑手正在取餐", nil);
    }else if (_status == 3 && [_model.order_status integerValue] == 3){
        if ([_model.pei_type isEqualToString:NSLocalizedString(@"平台送", nil)]) {
            btnTitle = NSLocalizedString(@"骑手正在送餐", nil);
        }else if ([_model.pei_type isEqualToString:NSLocalizedString(@"商家送", nil)]) {
            btnTitle = NSLocalizedString(@"商家正在送餐", nil);
        }else{
            btnTitle = NSLocalizedString(@"正在自提中...", nil);
        }
    }else if (_status == 4){
        btnTitle = NSLocalizedString(@"外卖已送达", nil);
    }else if (_status == 5){
        btnTitle = NSLocalizedString(@"说说你对该单评价", nil);
    }else if (_status == 6){
        btnTitle = NSLocalizedString(@"订单已结束", nil);
    }else if (_status == 7){
        btnTitle = NSLocalizedString(@"耐心等待商家处理", nil);
    }else if (_status == 8){
        btnTitle = NSLocalizedString(@"退款已被商家拒绝", nil);
    }else if (_status == -1){
        btnTitle = NSLocalizedString(@"订单已取消", nil);
    }else if (_status == 9){
        btnTitle = NSLocalizedString(@"客服正在紧张的处理您的问题...", nil);
    }
    else{
        btnTitle = NSLocalizedString(@"订单已成功退款", nil);
    }
    _labelStatus.text = _model.expect_show.integerValue == 1?_model.expect_msg:btnTitle;
    
    if (_status == 0 && !oldTimer){
        [self countDown];
    }

}

//处理倒计时支付的
-(void)countDown{
    if ([_model.order_status integerValue] != 0 || [_model.pay_status integerValue] == 1) {
        return;
    }
    time--;
    if (time <= 0) {
        time = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancleOrderWithOrder_id:is_timer:)]) {
            [self.delegate cancleOrderWithOrder_id:_model.order_id is_timer:YES];
        }
        return;
    }
    NSString * min = @(time/60).stringValue;
    if (min.length == 1) {
        min = [@"0" stringByAppendingString:min];
    }
    NSString * seconder = @(time%60).stringValue;
    if (seconder.length == 1) {
        seconder = [@"0" stringByAppendingString:seconder];
    }
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"请于%@分%@秒内付款,超时订单自动关闭", nil),min,seconder];
    oldTimer = str;
    _labelStatus.text = str;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self countDown];
    });
}

@end
