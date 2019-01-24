//
//  JHWaiMaiMySelfCellOne.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/24.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHWaiMaiMySelfCellOne.h"
#import <UIImageView+WebCache.h>
@interface JHWaiMaiMySelfCellOne(){
    UIImageView * imageV;
    UILabel * nameL;
    UILabel * desL;
    UIButton *qianDaoBtn;
}

@end

@implementation JHWaiMaiMySelfCellOne

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
    imageV = [[UIImageView alloc]init];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset = 16;
        make.width.height.offset = 64;
        make.bottom.offset = -16;
    }];
    imageV.layer.cornerRadius = 32;
    imageV.layer.masksToBounds = YES;
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [imageV addGestureRecognizer:tap1];
    
    nameL = [[UILabel alloc]init];
    [self addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 25;
        make.left.equalTo(imageV.mas_right).offset = 20;
        make.right.offset = -80;
        make.height.offset = 25;
    }];
    nameL.textColor = HEX(@"333333", 1);
    nameL.font = B_FONT(18);
    nameL.text = NSLocalizedString(@"立即登录", nil);
    nameL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [nameL addGestureRecognizer:tap];
    
    desL = [[UILabel alloc]init];
    [self addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom).offset = 4;
        make.left.equalTo(nameL.mas_left).offset = 0;
        make.right.offset = -80;
        make.height.offset = 17;
    }];
    desL.textColor = HEX(@"999999", 1);
    desL.font = FONT(12);
    desL.text = NSLocalizedString(@"登录后享受更多特权", nil);
    desL.userInteractionEnabled = YES;
     UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [desL addGestureRecognizer:tap2];
    
    qianDaoBtn = [[UIButton alloc]init];
    [self addSubview:qianDaoBtn];
    [qianDaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 34;
        make.right.offset =0;
        make.height.offset = 32;
        make.width.offset = 70;
    }];
    [qianDaoBtn setBackgroundImage:IMAGE(@"btn_qiandao") forState:0];
    [qianDaoBtn addTarget:self action:@selector(qianDaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)setUserModel:(JHUserModel *)userModel{
    _userModel = userModel;

     if ([JHUserModel shareJHUserModel].token.length > 0) {
         nameL.text = userModel.nickname;
         desL.text = userModel.mobile;
         [imageV sd_setImageWithURL:[NSURL URLWithString:userModel.face] placeholderImage:IMAGE(@"pic_headermoren")];
     }else{
         imageV.image = IMAGE(@"pic_headermoren");
         nameL.text = NSLocalizedString(@"立即登录", nil);
         desL.text = NSLocalizedString(@"登录后享受更多特权", nil);
     }

    qianDaoBtn.hidden = [[JHUserModel shareJHUserModel].have_signin isEqualToString:@"0"];
    
}
-(void)qianDaoBtnClick{
    if (self.clickBlock) {
        self.clickBlock(100);//签到
    }
    
}
-(void)click{
    if ([JHUserModel shareJHUserModel].token){
        if (self.clickBlock) {
            self.clickBlock(40);//跳到设置界面
        }
    }else{
        if (self.clickBlock) {
            self.clickBlock(50);//登录
        }
    }
}

@end
