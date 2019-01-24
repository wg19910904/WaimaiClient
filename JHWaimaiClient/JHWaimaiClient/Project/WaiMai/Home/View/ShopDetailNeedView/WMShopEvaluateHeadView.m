//
//  WMShopEvaluateHeadView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopEvaluateHeadView.h"
#import "YFStartView.h"
#import "UIImage+Extension.h"
#import "YFTypeBtn.h"

#define btn_tag 200

@interface WMShopEvaluateHeadView ()
@property(nonatomic,weak)UILabel *scoreLab;
@property(nonatomic,weak)UILabel *prettyLab;
@property(nonatomic,weak)YFStartView *shopStarView;
@property(nonatomic,weak)YFStartView *sendStarView;
@property(nonatomic,weak)UILabel *shopStarScoreLab;
@property(nonatomic,weak)UILabel *sendStarScoreLab;
@property(nonatomic,weak)UIButton *selectedBtn;
@property(nonatomic,weak)YFTypeBtn *showBtn;
@end

@implementation WMShopEvaluateHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    self.backgroundColor = BACK_COLOR;
    [self createTopView];
    [self createBottomView];
    
}

-(void)createTopView{
    UIView *scoreView = [UIView new];
    [self addSubview:scoreView];
    [scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=10;
        make.right.offset=0;
        make.height.offset=80;
    }];
    scoreView.backgroundColor = [UIColor whiteColor];
    
    UILabel *scoreLab = [UILabel new];
    [scoreView addSubview:scoreLab];
    [scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=15;
        make.width.offset=120;
        make.height.offset=20;
    }];
    scoreLab.textAlignment = NSTextAlignmentCenter;
    scoreLab.textColor = HEX(@"ff3300", 1.0);
    scoreLab.font = FONT(20);
    self.scoreLab = scoreLab;
    
    UILabel *lab = [UILabel new];
    [scoreView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(scoreLab.mas_bottom).offset=0;
        make.width.offset=120;
        make.height.offset=20;
    }];
    lab.font = FONT(14);
    lab.textColor = TEXT_COLOR;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = NSLocalizedString(@"综合评分", @"WMShopEvaluateHeadView");
    
    UILabel *prettyLab = [UILabel new];
    [scoreView addSubview:prettyLab];
    [prettyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(lab.mas_bottom).offset=0;
        make.width.offset=120;
        make.height.offset=20;
    }];
    prettyLab.textColor = HEX(@"666666", 1.0);
    prettyLab.font = FONT(12);
    prettyLab.textAlignment = NSTextAlignmentCenter;
    self.prettyLab = prettyLab;
    
    UIView *lineView=[UIView new];
    [scoreView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=121.5;
        make.top.offset=10;
        make.width.offset=1;
        make.bottom.offset=-10;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    NSArray * arr = @[NSLocalizedString(@"服务态度", @"WMShopEvaluateHeadView"),NSLocalizedString(@"配送评分", @"WMShopEvaluateHeadView")];
    for (NSInteger i=0; i<arr.count; i++) {
       
        UILabel *lab = [UILabel new];
        [scoreView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineView.mas_right).offset=10;
            make.top.offset=15 + (20 + 10) * i;
            make.width.offset=50;
            make.height.offset=20;
        }];
        lab.font = FONT(12);
        lab.textColor = TEXT_COLOR;
        lab.text = arr[i];
        
        YFStartView *starView = [YFStartView new];
        [scoreView addSubview:starView];
        [starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab.mas_right).offset=10;
            make.centerY.equalTo(lab.mas_centerY).offset=0;
            make.height.offset = 12;
            make.width.offset = 70;
        }];
        starView.interSpace = 2.5;
        starView.fullStarNum = 5;
        starView.currentStarScore = 0.0;
        starView.starType = YFStarViewFloat;
        starView.imgSize = CGSizeMake(12, 12);
        starView.userInteractionEnabled = NO;
        
        UILabel *scoreL= [UILabel new];
        [scoreView addSubview:scoreL];
        [scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(starView.mas_right).offset= 5;
            make.centerY.equalTo(starView.mas_centerY).offset = 0;
            make.height.offset=20;
        }];
        scoreL.font = FONT(12);
        scoreL.textColor = HEX(@"ff9900", 1.0);
        
        if (i == 0) {
            self.shopStarScoreLab = scoreL;
            self.shopStarView = starView;
        }else{
            self.sendStarScoreLab = scoreL;
            self.sendStarView = starView;
        }
        
    }
    
}

-(void)createBottomView{
 
    UIView *chooseView = [UIView new];
    [self addSubview:chooseView];
    chooseView.backgroundColor = [UIColor whiteColor];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=100;
        make.right.offset=0;
        make.height.offset=115;
    }];
    
    int x = 0;
    int y = 0;
    CGFloat btnW = (WIDTH -40)/3.0;
    CGFloat btnH = 30;
    for (int i=0; i<5; i++) {
        
        x = i % 3;
        y = i / 3;
       
        UIButton *btn = [UIButton new];
        [chooseView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset= 10 + (btnW + 10) * x;
            make.top.offset= 10 + (btnH + 10) * y;
            make.width.offset=btnW;
            make.height.offset=btnH;
        }];
        btn.layer.cornerRadius=4;
        btn.clipsToBounds=YES;
        btn.layer.borderColor=HEX(@"e6eaed", 1.0).CGColor;
        btn.layer.borderWidth=0.5;
        btn.titleLabel.font = FONT(14);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:HEX(@"ffffff", 1.0) forState:UIControlStateSelected];
        [btn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        btn.tag = btn_tag + i;
        if (i == 0) {
            self.selectedBtn = btn;
            btn.selected = YES;
            btn.backgroundColor = THEME_COLOR_Alpha(1.0);
        }
        [btn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    YFTypeBtn *showContentEvaluateBtn = [YFTypeBtn new];
    [chooseView addSubview:showContentEvaluateBtn];
    [showContentEvaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.bottom.offset=-5;
        make.height.offset=20;
    }];
    showContentEvaluateBtn.titleLabel.font = FONT(12);
    showContentEvaluateBtn.btnType = LeftImage;
    showContentEvaluateBtn.titleMargin = 5;
    showContentEvaluateBtn.selected = NO;
    
    [showContentEvaluateBtn setTitle:NSLocalizedString(@"只看有内容的评价", @"WMShopEvaluateHeadView") forState:UIControlStateNormal];
    [showContentEvaluateBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [showContentEvaluateBtn setImage:IMAGE(@"btn_weixuanzhong") forState:UIControlStateNormal];
    [showContentEvaluateBtn setImage:IMAGE(@"btn_xuanzhong") forState:UIControlStateSelected];
    [showContentEvaluateBtn addTarget:self action:@selector(showContentEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    _showBtn = showContentEvaluateBtn;

}

#pragma mark ====== Functions =======
-(void)reloadViewWithEvaluate:(NSDictionary *)dic type:(NSArray *)typeArr{
    
    self.scoreLab.text = dic[@"avg_score"];
    
    self.prettyLab.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"商家好评率", @"WMShopEvaluateHeadView"),dic[@"avg_good"],@"%"];
    self.shopStarView.currentStarScore = [dic[@"avg_score"] floatValue];
    self.shopStarScoreLab.text = [NSString stringWithFormat:@"%@%@",dic[@"avg_score"],NSLocalizedString(@"分",nil)];
    self.sendStarView.currentStarScore = [dic[@"avg_peisong"] floatValue];
    self.sendStarScoreLab.text = [NSString stringWithFormat:@"%@%@",dic[@"avg_peisong"],NSLocalizedString(@"分", nil)];
    
    for (NSInteger i=0; i<typeArr.count; i++) {
        NSDictionary *dic = typeArr[i];
        NSString *str = [NSString stringWithFormat:@"%@(%@)",dic[@"name"],dic[@"num"]];
        UIButton *btn = [self viewWithTag:btn_tag + i];
        [btn setTitle:str forState:UIControlStateNormal];
    }
    
}

// 选择什么样的评价
-(void)chooseType:(UIButton *)btn{
    
    if (self.selectedBtn == btn) return;
    btn.selected = YES;
    self.selectedBtn.selected = NO;
    btn.backgroundColor = THEME_COLOR_Alpha(1.0);
    self.selectedBtn.backgroundColor = [UIColor whiteColor];

    self.selectedBtn = btn;
    
    if (self.chooseShowEvaluateType) {
        self.chooseShowEvaluateType(self.selectedBtn.tag - btn_tag,_showBtn.selected);
    }
}

// 只看有内容的评价
-(void)showContentEvaluate:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    
    if (self.chooseShowEvaluateType) {
        self.chooseShowEvaluateType(self.selectedBtn.tag - btn_tag,btn.selected);
    }
}

@end
