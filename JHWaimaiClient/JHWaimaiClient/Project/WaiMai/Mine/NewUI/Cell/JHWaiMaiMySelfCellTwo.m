//
//  JHWaiMaiMySelfCellTwo.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/24.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHWaiMaiMySelfCellTwo.h"

@interface JHWaiMaiMySelfCellTwo(){

}


@end

@implementation JHWaiMaiMySelfCellTwo

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.backgroundColor =HEX(@"ffffff", 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)creatUI{
    NSArray *titleArr = @[NSLocalizedString(@"余额", nil),NSLocalizedString(@"红包", nil),NSLocalizedString(@"优惠劵", nil),NSLocalizedString(@"积分", nil)];

    for (int i = 0; i<4; i++) {
        
        UIView *bgV = [[UIView alloc]init];//WithFrame:CGRectMake(i*WIDTH/4, 155*SCALE, WIDTH/4, 85*SCALE)];
        [self addSubview:bgV];
        [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 0;
            make.height.offset = 64;
            make.left.offset =i*WIDTH/4;
            make.width.offset = WIDTH/4;
            make.bottom.offset = 0;
        }];
        bgV.backgroundColor = [UIColor clearColor];
        bgV.tag = i+50;
        bgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [bgV addGestureRecognizer:tap];
        
        UILabel*titleL = [[UILabel alloc]init];//WithFrame:CGRectMake(5, 20*SCALE, bgV.width-10, 20*SCALE)];
        [bgV addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 15;
            make.height.offset = 20;
            make.left.right.offset =0;
        }];
        titleL.font = FONT(18);
        titleL.text = @"0";
        titleL.tag = 100+i;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = HEX(@"333333", 1);
        titleL.adjustsFontSizeToFitWidth = YES;
//        titleL.textColor = [UIColor whiteColor];
//        NSMutableAttributedString *atti = [[NSMutableAttributedString alloc]initWithString:titleL.text];
//        [atti addAttributes:@{NSFontAttributeName:FONT(12)} range:[titleL.text rangeOfString:danWeiArr[i]]];
//        titleL.attributedText = atti;
        
        
        UILabel *desL = [[UILabel alloc]init];//WithFrame:CGRectMake(0,50*SCALE, bgV.width, 16*SCALE)];
            [bgV addSubview:desL];
        [desL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleL.mas_bottom).offset = 0;
            make.height.offset = 16;
            make.left.right.offset =0;
        }];
        desL.font = FONT(12);
        desL.textAlignment = NSTextAlignmentCenter;
        desL.text = titleArr[i];
        desL.textColor =HEX(@"999999", 1);
    
        
    }
}
-(void)click:(UIGestureRecognizer *)tap{
    UIView *view = tap.view;
    if (self.clickBlock) {
        self.clickBlock(view.tag);//红包等
    }
}
-(void)setUserModel:(JHUserModel *)userModel{
_userModel = userModel;
       NSMutableArray *tempArr = @[].mutableCopy;
    if (![JHUserModel shareJHUserModel].token) {
       NSArray *arr = @[@"0",@"0",@"0",@"0"];
        [tempArr addObjectsFromArray:arr];
    }else{
         NSArray *arr = @[_userModel.money,_userModel.hongbao_count,_userModel.coupon_count,_userModel.jifen];
           [tempArr addObjectsFromArray:arr];
    };
 
   
    for (NSInteger i=0; i<4; i++) {
        UIView *view = [self viewWithTag:i+50];
        for (UILabel * numL in view.subviews) {
            if (numL.tag == i+100) {
                numL.text = tempArr[i];
            }
        }
    }
    
}
@end
