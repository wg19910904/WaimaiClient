//
//  WMShopDetailCellTwo.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopDetailCellTwo.h"

@interface WMShopDetailCellTwo ()
@property(nonatomic,weak)UILabel *kindLab;
@property(nonatomic,weak)UILabel *desLab;
@end

@implementation WMShopDetailCellTwo

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *kindLab = [UILabel new];
    [self.contentView addSubview:kindLab];
    [kindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.width.offset=16;
        make.height.offset=16;
    }];
    kindLab.layer.cornerRadius=4;
    kindLab.clipsToBounds=YES;
    kindLab.font = FONT(12);
    kindLab.textAlignment = NSTextAlignmentCenter;
    kindLab.textColor = [UIColor whiteColor];
    self.kindLab = kindLab;
    
    UILabel *desLab = [UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=36;
        make.centerY.offset=0;
        make.right.offset=-10;
        make.height.offset=20;
    }];
    desLab.lineBreakMode = NSLineBreakByTruncatingTail;
    desLab.font = FONT(14);
    desLab.textColor = HEX(@"666666", 1.0);
    self.desLab = desLab;
}

-(void)reloadCellWithDic:(NSDictionary *)dic{
    
    self.kindLab.backgroundColor = HEX(dic[@"color"], 1.0);
    self.kindLab.text = dic[@"word"];
    self.desLab.text = dic[@"title"];
}

@end
