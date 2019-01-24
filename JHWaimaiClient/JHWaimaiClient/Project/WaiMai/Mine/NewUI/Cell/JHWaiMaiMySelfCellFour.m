//
//  JHWaiMaiMySelfCellFour.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/24.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHWaiMaiMySelfCellFour.h"


@interface JHWaiMaiMySelfCellFour(){
    UIImageView * imageV;
    UILabel * titleL;
    UILabel * desL;
    UIImageView *leftImageV;
    UIView *linev;
}


@end

@implementation JHWaiMaiMySelfCellFour

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
        make.top.left.offset = 11;
        make.width.height.offset = 28;
        make.bottom.offset = -11;
    }];
  
    
    titleL = [[UILabel alloc]init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.equalTo(imageV.mas_right).offset = 12;
        make.height.offset = 18;
    }];
    titleL.textColor = HEX(@"333333", 1);
    titleL.font = FONT(13);

    
    desL = [[UILabel alloc]init];
    [self addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;

        make.right.offset = -30;
        make.height.offset = 17;
    }];
    desL.textColor = HEX(@"cccccc", 1);
    desL.font = FONT(12);
    
    
    leftImageV = [[UIImageView alloc]init];
    [self addSubview:leftImageV];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.offset =-16;
        make.height.offset = 11;
        make.width.offset = 6;
    }];
    leftImageV.image = IMAGE(@"dakai copy");
    
    linev = [[UIView alloc]init];
    [self addSubview:linev];
    [linev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset =0;
        make.height.offset = 1;
    }];
    linev.backgroundColor = HEX(@"f5f5f5", 1);
   
}
-(void)setDic:(NSDictionary *)dic
{
    if (dic) {
        titleL.text = dic[@"title"];
        desL.text = dic[@"intro"]?dic[@"intro"]:@"";
        [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:nil];
    }
   
    
    
}
@end
