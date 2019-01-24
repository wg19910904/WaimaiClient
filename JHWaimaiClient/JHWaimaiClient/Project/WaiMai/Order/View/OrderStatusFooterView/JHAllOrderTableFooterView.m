//
//  JHGroupOrderDetailFooterView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHAllOrderTableFooterView.h"
#import "JHWaiMaiOrderListModel.h"
#import "JHWaimaiOrderDetailModel.h"
#import "YFTimerManager.h"

@interface JHAllOrderTableFooterView()<YFTimerDelegate>

@property(nonatomic,strong)id model;
@property(nonatomic,assign)JHAllOrderFooterBtnMasRect btnMasRect;
@property(nonatomic,assign)NSInteger pay_left_time;// 支付剩余时间
@property(nonatomic,weak)UIButton *pay_btn;
@property(nonatomic,copy)NSString *normal_pay_title;// 去支付
@end

@implementation JHAllOrderTableFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier btnMasRect:(JHAllOrderFooterBtnMasRect)btnMasRect
{
    _btnMasRect = btnMasRect;
    return [self initWithReuseIdentifier:reuseIdentifier];
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIButton *beforeBtn = nil;
    for (NSInteger i=0; i<4; i++) {
        
        UIButton *action_btn = [UIButton new];
        [self.contentView addSubview:action_btn];

        [action_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (beforeBtn) {
                make.right.equalTo(beforeBtn.mas_left).offset(-_btnMasRect.btn_margin);
            }else{
                make.right.offset=-(_btnMasRect.right_margin + (_btnMasRect.width_margin + _btnMasRect.btn_margin)* i);
            }
            make.top.offset(_btnMasRect.top_margin);
            make.bottom.offset(-(_btnMasRect.bottom_margin + 10));
            make.width.greaterThanOrEqualTo(@(_btnMasRect.width_margin));
        }];
        beforeBtn = action_btn;
        action_btn.layer.cornerRadius = 4;
        action_btn.layer.masksToBounds = YES;
        action_btn.layer.borderColor = LINE_COLOR.CGColor;
        action_btn.layer.borderWidth = 0.5;
        action_btn.titleLabel.font = FONT(14);
        action_btn.tag = 100 + i;
        action_btn.layer.borderWidth=1;
        [action_btn setTitleColor:HEX(@"ff6600", 1.0) forState:UIControlStateSelected];
        [action_btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        [action_btn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        action_btn.hidden = YES;
    }
    
    UIView *view = [UIView new];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(0);
        make.right.offset(0);
        make.height.offset(10);
    }];
    view.backgroundColor = BACK_COLOR;
    
}

#pragma mark ====== Functions =======
-(void)reloadViewWith:(id )model{
    _model = model;
   
    
    NSInteger dao_time = [(JHWaiMaiOrderListModel *)model dao_time];
    NSDictionary *dic = [(JHWaiMaiOrderListModel *)model show_btn];

    self.pay_left_time = dao_time;

    NSArray *titleArr = [self getBtnTitleArr:dic];
    
    for (NSInteger i=0; i<4; i++) {
        
        UIButton *btn = [self.contentView viewWithTag:100 + i];

        if (i < titleArr.count) {
            NSString *title = titleArr[titleArr.count - 1 - i];
            btn.hidden = NO;
            btn.selected = NO;
            btn.layer.borderColor = [title isEqualToString: NSLocalizedString(@"去支付", NSStringFromClass([self class]))] ? HEX(@"ff6600", 1.0).CGColor : LINE_COLOR.CGColor;
            
            if ([title isEqualToString: NSLocalizedString(@"去支付", NSStringFromClass([self class]))]) {
                self.pay_btn = btn;
                self.normal_pay_title = title;
                [self toDoThingsWhenTimeCome:1.0];
                btn.selected = YES;
            }else{
                [btn setTitle:title forState:UIControlStateNormal];
                [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.greaterThanOrEqualTo(@(_btnMasRect.width_margin + 10));
                }];
            }
           
        }else btn.hidden = YES;
        
        
    }
 
}

-(void)clickActionBtn:(UIButton *)btn{
    
    Ivar order_id_var = class_getInstanceVariable([self.model class], "_order_id");
    NSString *order_id = (NSString *)object_getIvar(self.model, order_id_var);
    
    Ivar amount_var = class_getInstanceVariable([self.model class], "_amount");
    NSString *amount = (NSString *)object_getIvar(self.model, amount_var);

    NSInteger dao_time  = 0;
    if ([self.model isKindOfClass:[JHWaiMaiOrderListModel class]]) {
        dao_time = [(JHWaiMaiOrderListModel *)self.model dao_time];
    }
    if ([self.model isKindOfClass:[JHWaimaiOrderDetailModel class]]) {
        dao_time = [(JHWaimaiOrderDetailModel *)self.model dao_time];
    }
    
    NSString *action_name = btn.currentTitle;
    if ([action_name isEqualToString:NSLocalizedString(@"申请客服介入", NSStringFromClass([self class]))]) {     // 申请客服介入
        if (RespondsSelector(self.delegate, @selector(applyForCustomerServicesWithOrder_id:))) {
            [self.delegate applyForCustomerServicesWithOrder_id:order_id];
        }
    }else if ([action_name isEqualToString:NSLocalizedString(@"取消订单", NSStringFromClass([self class]))]) {  // 取消订单
        if (RespondsSelector(self.delegate, @selector(cancleOrderWithOrder_id:is_timer:))) {
            [self.delegate cancleOrderWithOrder_id:order_id is_timer:NO];
        }
    }else if ([action_name isEqualToString:NSLocalizedString(@"申请退款", NSStringFromClass([self class]))]) {  // 退款
        if (RespondsSelector(self.delegate, @selector(refundOrderWithOrder_id:phone:))) {
            
            Ivar phone_var = class_getInstanceVariable([self.model class], "_phone");
            NSString *phone = (NSString *)object_getIvar(self.model, phone_var);
            
            [self.delegate refundOrderWithOrder_id:order_id phone:phone];
        }
    }else if ([action_name containsString:NSLocalizedString(@"去支付", NSStringFromClass([self class]))]) {     // 去支付
        if (RespondsSelector(self.delegate, @selector(payOrderWithOrder_id:amount:dateline:))) {
            [self.delegate payOrderWithOrder_id:order_id amount:amount dateline:dao_time];
        }
    }else if ([action_name isEqualToString:NSLocalizedString(@"去评论", NSStringFromClass([self class]))]) { // 去评价
        if (RespondsSelector(self.delegate, @selector(commentOrderWithOrder:))) {
            [self.delegate commentOrderWithOrder:self.model];
        }
    }else if ([action_name isEqualToString:NSLocalizedString(@"再来一单", NSStringFromClass([self class]))]) {   // 再来一单
        if (RespondsSelector(self.delegate, @selector(againOrderWithOrder:))) {
            [self.delegate againOrderWithOrder:self.model];
        }
    }else if ([action_name isEqualToString:NSLocalizedString(@"催单", NSStringFromClass([self class]))]) {     // 催单
        if (RespondsSelector(self.delegate, @selector(cuiOrderWithOrder_id:))) {
            [self.delegate cuiOrderWithOrder_id:order_id];
        }
    }else if ([action_name isEqualToString:NSLocalizedString(@"确认自提", nil)] || [action_name isEqualToString:NSLocalizedString(@"确认送达", nil)]) { // 确认送达  确认自提
        if (RespondsSelector(self.delegate, @selector(confirmOrderWithOrder_id:))) {
            [self.delegate confirmOrderWithOrder_id:order_id];
        }
    }else if ([action_name isEqualToString:NSLocalizedString(@"查看评价", NSStringFromClass([self class]))]) {  // 查看评价
        if (RespondsSelector(self.delegate, @selector(viewCommentWithOrder:))) {
            [self.delegate viewCommentWithOrder:self.model];
        }
    }

}

#pragma mark ====== 支付倒计时处理 =======
-(void)setPay_left_time:(NSInteger)pay_left_time{
    _pay_left_time = pay_left_time - [[NSDate date] timeIntervalSince1970];
    if (_pay_left_time <=0) {
        return;
    }
    [YFTimerManager addTimerWithTimeInterval:1.0];
    [YFTimerManager addTimerDelegate:self forTimeInterval:1.0];
}

#pragma mark ====== YFTimerDelegate =======
-(void)toDoThingsWhenTimeCome:(NSTimeInterval)interval{
    
    NSTimeInterval dateline = _pay_left_time;

    int hour = (int)(dateline/3600);
    int min = (int)(dateline-3600*hour)/60;
    int sec = (int)(dateline-3600*hour - 60 * min);
    
    hour = MAX(MIN(hour, 59), 0);
    min = MAX(MIN(min, 59), 0);
    sec = MAX(MIN(sec, 59), 0);
    
    _pay_left_time -= 1;
    
    NSString *str = @"";
    if (dateline > 0) {
        if (min == 0 ) {
            str = [NSString stringWithFormat: NSLocalizedString(@"剩余%02d秒", NSStringFromClass([self class])),sec];
        }else{
            str = [NSString stringWithFormat: NSLocalizedString(@"剩余%02d分%02d秒", NSStringFromClass([self class])),min,sec];
        }
        
        NSString *title = [NSString stringWithFormat:@"  %@(%@)  ",_normal_pay_title ,str];
        [self.pay_btn setTitle:title forState:UIControlStateNormal];
        
    }else{
        [self.pay_btn setTitle:_normal_pay_title forState:UIControlStateNormal];
        [self.pay_btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(_btnMasRect.width_margin);
        }];
    }
    
    if (dateline <= 0) {
        [YFTimerManager deleteTimerDelegate:self forTimeInterval:1.0];
        Ivar order_id_var = class_getInstanceVariable([self.model class], "_order_id");
        NSString *order_id = (NSString *)object_getIvar(self.model, order_id_var);
        if (RespondsSelector(self.delegate, @selector(cancleOrderWithOrder_id:is_timer:))) {
            [self.delegate cancleOrderWithOrder_id:order_id is_timer:YES];
        }
    }
    
}


/*
 显示按钮(有值且为1时显示相应按钮)：
 endtime倒计时,
 pay去支付,
 comment评论,
 again再来一单,
 canel取消,
 cui催单,
 confirm 确认送达,
 payback申请退款,
 see查看评价,
 admin申请客服,
 waiting等待处理结果
 */

-(NSArray *)getBtnTitleArr:(NSDictionary *)show_btn{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([show_btn.allKeys containsObject:@"pay"]) {
        [arr insertObject:NSLocalizedString(@"去支付", NSStringFromClass([self class])) atIndex:0];
    }
    
    if ([show_btn.allKeys containsObject:@"canel"]) {
        [arr insertObject:NSLocalizedString(@"取消订单", NSStringFromClass([self class])) atIndex:0];
    }
    
    if ([show_btn.allKeys containsObject:@"again"]) {
        [arr insertObject:NSLocalizedString(@"再来一单", NSStringFromClass([self class])) atIndex:0];
    }
    
    if ([show_btn.allKeys containsObject:@"cui"]) {
        [arr insertObject:NSLocalizedString(@"催单", NSStringFromClass([self class])) atIndex:0];
    }
    
    if ([show_btn.allKeys containsObject:@"payback"]) {
        [arr insertObject:NSLocalizedString(@"申请退款", NSStringFromClass([self class])) atIndex:0];
    }
    
    if ([show_btn.allKeys containsObject:@"comment"]) {
        [arr insertObject:NSLocalizedString(@"去评论", NSStringFromClass([self class])) atIndex:0];
    }
    
    if ([show_btn.allKeys containsObject:@"confirm"]) {
        Ivar pei_type_var = class_getInstanceVariable([self.model class], "_pei_type");
        NSString *pei_type = (NSString *)object_getIvar(self.model, pei_type_var);
        
       NSString *str = [pei_type integerValue] == 3? NSLocalizedString(@"确认自提", nil):NSLocalizedString(@"确认送达", nil);
       [arr insertObject:str atIndex:0];
    }
    
    if ([show_btn.allKeys containsObject:@"see"]) {
        [arr insertObject:NSLocalizedString(@"查看评价", NSStringFromClass([self class])) atIndex:0];
    }
    if ([show_btn.allKeys containsObject:@"admin"]) {
        [arr insertObject:NSLocalizedString(@"申请客服介入", NSStringFromClass([self class])) atIndex:0];
    }
    return  arr.copy;
}

@end
