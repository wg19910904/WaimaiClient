//
//  JHAllOrderDetailBottomView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHAllOrderDetailStatusView.h"
#import "JHWaiMaiOrderListModel.h"
#import "JHWaimaiOrderDetailModel.h"

@interface JHAllOrderDetailStatusView()
@property(nonatomic,strong)id model;
@property(nonatomic,weak)UIButton *left_btn;
@property(nonatomic,weak)UIButton *center_btn;
@property(nonatomic,weak)UIButton *right_btn;
@property(nonatomic,copy)NSString *normal_pay_title;// 去支付
@property(nonatomic,weak)UIButton *pay_btn;
@end

@implementation JHAllOrderDetailStatusView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    self.backgroundColor = [UIColor whiteColor];
    for (NSInteger i=0; i<3; i++) {
        
        UIButton *action_btn = [UIButton new];
        [self addSubview:action_btn];
        action_btn.layer.cornerRadius = 4;
        action_btn.layer.masksToBounds = YES;
        action_btn.layer.borderColor = LINE_COLOR.CGColor;
        action_btn.layer.borderWidth = 0.5;
        action_btn.titleLabel.font = FONT(14);
        action_btn.tag = 100 + i;
        action_btn.layer.borderWidth=1;
        [action_btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        [action_btn addTarget:self action:@selector(clickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        action_btn.hidden = YES;
        if (i == 2) self.left_btn = action_btn;
        if (i == 1) self.center_btn = action_btn;
        if (i == 0) self.right_btn = action_btn;
    }
    
}

#pragma mark ====== Functions =======
-(void)reloadViewWith:(id )model{
    _model = model;

    Ivar show_btn_var = class_getInstanceVariable([self.model class], "_show_btn");
    NSDictionary *dic = (NSDictionary *)object_getIvar(self.model, show_btn_var);

    NSArray *titleArr = [self getBtnTitleArr:dic];
    
    for (NSInteger i=0; i<3; i++) {
        UIButton *btn = [self viewWithTag:100 + i];
        if (i < titleArr.count) {
            NSString *title = titleArr[titleArr.count - 1 - i];
            [btn setTitle:title forState:UIControlStateNormal];
        }
        btn.hidden = NO;
    }
    
    if (titleArr.count > 2) {
        CGFloat margin = (WIDTH - 300 *SCALE)/4;
        [self.left_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.left.offset = margin;
            make.width.greaterThanOrEqualTo(@(100*SCALE + 10));
            make.height.offset = 40*SCALE;
        }];
        
        [self.right_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.right.offset = -margin;
            make.width.greaterThanOrEqualTo(@(100*SCALE + 10));
            make.height.offset = 40*SCALE;
        }];
        
        [self.center_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.centerX.offset = 0;
            make.width.greaterThanOrEqualTo(@(100*SCALE + 10));
            make.height.offset = 40*SCALE;
        }];
        
        
        
    }else if(titleArr.count == 2){
        self.left_btn.hidden = YES;
        CGFloat margin = (WIDTH - 200 *SCALE)/3;
        [self.right_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.right.offset = -margin;
            make.width.greaterThanOrEqualTo(@(100*SCALE + 10));
            make.height.offset = 40*SCALE;
        }];
        
        [self.center_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.left.offset = margin;
            make.width.greaterThanOrEqualTo(@(100*SCALE + 10));
            make.height.offset = 40*SCALE;
        }];
    }else if(titleArr.count == 1){
        self.left_btn.hidden = YES;
        self.right_btn.hidden = YES;
        [self.center_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.centerX.offset = 0;
            make.width.greaterThanOrEqualTo(@(100*SCALE + 10));
            make.height.offset = 40*SCALE;
        }];
        
         [self.center_btn setTitle:titleArr.firstObject forState:UIControlStateNormal];
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

