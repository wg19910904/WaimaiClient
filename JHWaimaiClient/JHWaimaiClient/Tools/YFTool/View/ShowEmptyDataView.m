//
//  ShowEmptyDataView.m
//  JHLive
//
//  Created by jianghu3 on 16/8/31.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "ShowEmptyDataView.h"

@interface ShowEmptyDataView ()
@property(nonatomic,weak)UIImageView *imageView;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UIButton *statusBtn;
@end

@implementation ShowEmptyDataView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=HEX(@"ffffff", 1.0);
        [self createUISubview];
    }
    return self;
    
}

-(void)createUISubview{

    UIImageView * imageView = [UIImageView new];
    [self addSubview:imageView];
    self.imageView=imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=-50;
    }];
//    imageView.image = [UIImage imageNamed:@"icon_wu"];

    UILabel *desLab=[UILabel new];
    [self addSubview:desLab];
     desLab.frame = FRAME(0, 300, WIDTH, 20);
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.equalTo(imageView.mas_bottom).offset=20;
    }];
    desLab.font = FONT(16);
    desLab.numberOfLines = 0;
    desLab.textColor = HEX(@"666666", 1.0);
    desLab.textAlignment = NSTextAlignmentCenter;
    self.desLab=desLab;
 
    UIButton *btn=[UIButton new];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.equalTo(desLab.mas_bottom).offset=20;
        make.width.greaterThanOrEqualTo(@120);
        make.height.offset=40;
    }];
    btn.layer.cornerRadius=4;
    btn.clipsToBounds=YES;
    btn.layer.borderColor= HEX(@"C9EFC0", 1.0).CGColor;
    btn.layer.borderWidth=1.0;
    btn.titleLabel.font = FONT(16);
    [btn setTitleColor:HEX(@"4DC831", 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    self.statusBtn=btn;
    btn.hidden=YES;
    
}

-(void)clickBtn{
    if (self.clickStatusBtn)  self.clickStatusBtn();
}

-(void)setIs_showBtn:(BOOL)is_showBtn{
    _is_showBtn=is_showBtn;
    self.statusBtn.hidden=!is_showBtn;
}

-(void)setStatusBtnTitle:(NSString *)statusBtnTitle{
    _statusBtnTitle=statusBtnTitle;
    [self.statusBtn setTitle:statusBtnTitle forState:UIControlStateNormal];
//    CGFloat w = getSize(statusBtnTitle, 40, 20).width;
//    [self.statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.offset =  w;
//    }];
    if ([statusBtnTitle isEqualToString:@"历史消息"]) {
            [self.statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset=0;
                make.bottom.offset=-150;
                make.width.greaterThanOrEqualTo(@120);
                make.height.offset=40;
            }];
        self.statusBtn.layer.cornerRadius=4;
        self.statusBtn.clipsToBounds=YES;
        self.statusBtn.layer.borderColor= HEX(@"ffffff", 1.0).CGColor;
        self.statusBtn.layer.borderWidth=1.0;
        self.statusBtn.titleLabel.font = FONT(10);
        [self.statusBtn setTitleColor:HEX(@"999999", 1.0) forState:UIControlStateNormal];
        
    }
}

-(void)setBtnColor:(UIColor *)btnColor{
    _btnColor=btnColor;
    [self.statusBtn setTitleColor:btnColor forState:UIControlStateNormal];
}

-(void)setEmptyImg:(NSString *)emptyImg{
    _emptyImg = emptyImg;
    if (emptyImg  && emptyImg.length>0){
       self.imageView.image = [UIImage imageNamed:emptyImg];
    }
}

-(void)setDesStr:(NSString *)desStr{
    self.desLab.text = desStr;
}

-(void)setDesAttrStr:(NSAttributedString *)desAttrStr{
    self.desLab.attributedText = desAttrStr;
}

@end
