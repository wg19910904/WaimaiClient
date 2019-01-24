//
//  YFCollectionReusableView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "YFCollectionReusableView.h"
#import "YFTypeBtn.h"

@interface YFCollectionReusableView ()
@property(nonatomic,weak)YFTypeBtn *titleBtn;
@property(nonatomic,weak)YFTypeBtn *deleteBtn;
@end

@implementation YFCollectionReusableView

-(instancetype)init{
    if (self = [super init]) {
        [self configUI];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       [self configUI];
    }
    return self;
}

-(void)configUI{
    YFTypeBtn *titleLabBtn = [YFTypeBtn new];
    [self addSubview:titleLabBtn];
    [titleLabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.height.offset=20;
    }];

    [titleLabBtn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
    titleLabBtn.titleLabel.font = FONT(12);
    titleLabBtn.userInteractionEnabled = NO;
    titleLabBtn.btnType = LeftImage;
    titleLabBtn.titleMargin = 5;
    self.titleBtn = titleLabBtn;
    
    //delete_all
    YFTypeBtn *btn = [YFTypeBtn new];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.offset=0;
        make.height.offset=40;
    }];
    
    btn.titleLabel.font = FONT(12);
    btn.btnType = LeftImage;
    btn.titleMargin = 5;
    btn.imageMargin = -5;
    [btn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:NSLocalizedString(@"清除", nil) forState:UIControlStateNormal];
    self.deleteBtn = btn;
    
}

-(void)setTitleStr:(NSString *)titleStr{
    [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
}

-(void)setTitleImg:(NSString *)titleImg{
    [self.titleBtn setImage:[UIImage imageNamed:titleImg] forState:UIControlStateNormal];
}

-(void)clickDelete{
    if (self.deleteHistory) {
        self.deleteHistory();
    }
}

-(void)setHidden_delete:(BOOL)hidden_delete{
    _hidden_delete = hidden_delete;
    self.deleteBtn.hidden = hidden_delete;
}

@end
