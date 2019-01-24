//
//  JHWaiMaiMySelfCellThree.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/24.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHWaiMaiMySelfCellThree.h"

@interface JHWaiMaiMySelfCellThree(){
    UILabel * titleL;

}


@end

@implementation JHWaiMaiMySelfCellThree

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
    titleL = [[UILabel alloc]init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 16;
        make.top.offset = 0;
        make.height.offset = 48;
    }];
    titleL.textColor = HEX(@"333333", 1);
    titleL.font = FONT(16);
    titleL.text = @"我的功能";
    
    NSArray *titleArr = @[NSLocalizedString(@"收货地址", nil),NSLocalizedString(@"我的收藏", nil),NSLocalizedString(@"邀请好友", nil),NSLocalizedString(@"我的消息", nil)];
    NSArray *imageArr = @[@"nav_01",@"nav_02",@"nav_03",@"nav_04"];
    
    
    for (int i = 0; i<4; i++) {
        
        UIView *bgV = [[UIView alloc]init];//WithFrame:CGRectMake(i*WIDTH/4, 155*SCALE, WIDTH/4, 85*SCALE)];
        [self addSubview:bgV];
        [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 48;
            make.height.offset = 74;
            make.left.offset =i*WIDTH/4;
            make.width.offset = WIDTH/4;
            make.bottom.offset = 0;
        }];
        bgV.backgroundColor = [UIColor clearColor];
        bgV.tag = i;
        bgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [bgV addGestureRecognizer:tap];
        
        UIImageView*imageV = [[UIImageView alloc]init];//WithFrame:CGRectMake(5, 20*SCALE, bgV.width-10, 20*SCALE)];
        [bgV addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset = 12;
            make.centerX.offset = 0;
            make.height.width.offset = 28;
    
        }];
        imageV.image = IMAGE(imageArr[i]);
        //        titleL.adjustsFontSizeToFitWidth = YES;
        //        titleL.textColor = [UIColor whiteColor];
        //        NSMutableAttributedString *atti = [[NSMutableAttributedString alloc]initWithString:titleL.text];
        //        [atti addAttributes:@{NSFontAttributeName:FONT(12)} range:[titleL.text rangeOfString:danWeiArr[i]]];
        //        titleL.attributedText = atti;
        
        
        UILabel *desL = [[UILabel alloc]init];//WithFrame:CGRectMake(0,50*SCALE, bgV.width, 16*SCALE)];
        [bgV addSubview:desL];
        [desL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageV.mas_bottom).offset = 8;
            make.height.offset = 16;
            make.left.right.offset =0;
        }];
        desL.font = FONT(12);
        desL.textAlignment = NSTextAlignmentCenter;
        desL.text = titleArr[i];
        desL.textColor =HEX(@"666666", 1);
        
        
    }
   
    
}

-(void)click:(UIGestureRecognizer *)tap{
    UIView *view = tap.view;
    if (self.clickBlock) {
        self.clickBlock(view.tag);//红包等
    }
}
@end
