//
//  JHMyMessageCell.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHMyMessageCell.h"
#import "NSString+Tool.h"
@interface JHMyMessageCell(){
    
    UIImageView *leftImageV;
    UIView *redV;
    UILabel *titleL;
    UILabel *desL;
    UILabel *timeL;
    
}

@end

@implementation JHMyMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)creatUI{
    leftImageV = [[UIImageView alloc]init];
    [self addSubview:leftImageV];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 20;
        make.left.offset = 15;
        make.bottom.offset = -20;
        make.height.width.offset = 48;
    }];
    
    redV = [[UIView alloc]init];
    [self addSubview:redV];
    [redV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImageV.mas_top).offset = -5;
        make.right.equalTo(leftImageV.mas_right).offset = 5;
        make.height.width.offset = 10;
    }];
    redV.backgroundColor = HEX(@"FF2800", 1);
    redV.layer.cornerRadius = 5;
    redV.layer.masksToBounds = YES;
    
    titleL = [[UILabel alloc]init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImageV.mas_top).offset = 0;
        make.left.equalTo(leftImageV.mas_right).offset = 16;
        make.height.offset =22;
    }];
    titleL.font = FONT(16);
    titleL.textColor = HEX(@"333333", 1);
    
    desL= [[UILabel alloc]init];
    [self addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(leftImageV.mas_bottom).offset = 0;
        make.left.equalTo(leftImageV.mas_right).offset = 16;
        make.height.offset =20;
        make.right.offset = -17;
    }];
    desL.font = FONT(14);
    desL.textColor = HEX(@"999999", 1);
    
    
    timeL= [[UILabel alloc]init];
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 22;
        make.height.offset =17;
        make.right.offset = -15;
    }];
    timeL.font = FONT(12);
    timeL.textColor = HEX(@"999999", 1);
    
    
    UIView *lineV = [[UIView alloc]init];
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.offset = 0;
        make.height.offset = 1;
    }];
    lineV.backgroundColor = HEX(@"f5f5f5", 1);
    
}
-(void)setDic:(NSDictionary *)dic{
    leftImageV.image = IMAGE(dic[@"image"]);
    titleL.text = dic[@"title"];
}
-(void)setModel:(JHMyMessageModel *)model{
    
    redV.hidden = [model.is_read isEqualToString:@"0"];
    desL.text = model.content;
    if (model.dateline.length>0) {
        timeL.text =[NSString formateDate:@"yyyy-MM-dd HH:mm" dateline:[model.dateline integerValue]];
    }else{
        timeL.text =@"";
    }
    
}

@end
