//
//  ReplayView.m
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/30.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "ReplyView.h"

@interface ReplyView ()
@property(nonatomic,weak)UILabel *replyLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UIImageView *bgImgView;
@end

@implementation ReplyView

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(instancetype)init{
    if (self=[super init]) {
        [self configUI];
    }
    return self;
}


-(void)configUI{
    UIImageView *imageView=[UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
    }];
    imageView.image=[UIImage imageNamed:@"order_box"];
    self.bgImgView=imageView;
    
    UILabel *lab=[UILabel new];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=0;
        make.right.offset=-10;
        make.bottom.offset=-25;
    }];
    lab.lineBreakMode=NSLineBreakByCharWrapping;
    lab.numberOfLines=0;
    lab.textColor=HEX(@"333333", 1.0);
    lab.font=FONT(12);
    self.replyLab=lab;
    
    UILabel *timeLab=[UILabel new];
    [self addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.bottom.offset=-5;
        make.height.offset=20;
    }];
    timeLab.textColor=HEX(@"868686", 1.0);
    timeLab.font=FONT(11);
    timeLab.textAlignment=NSTextAlignmentRight;
    self.timeLab=timeLab;
    
}

-(void)setTimeStr:(NSString *)timeStr{
    _timeStr=timeStr;
    self.timeLab.text=timeStr;
}

-(void)setReplyStr:(NSString *)replyStr{
    _replyStr=replyStr;
    NSString *str=replyStr;
    NSInteger pre=0;
    if (self.is_shoper) {
        str=[NSString stringWithFormat:NSLocalizedString(@"商家回复:%@", nil),replyStr];
        pre=5;
    }
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR_Alpha(1.0) range:NSMakeRange(0, pre)];
    self.replyLab.attributedText=attStr;

}

-(void)setNumberOfLines:(NSInteger)numberOfLines{
    
    _numberOfLines=numberOfLines;
    self.replyLab.numberOfLines=numberOfLines;
    
    if (numberOfLines==0) self.replyLab.lineBreakMode=NSLineBreakByCharWrapping;
    else self.replyLab.lineBreakMode=NSLineBreakByTruncatingTail;
    
}

@end
