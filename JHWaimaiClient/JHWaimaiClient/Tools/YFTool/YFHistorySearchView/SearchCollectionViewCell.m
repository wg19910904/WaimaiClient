//
//  SearchCollectionViewCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import "Masonry.h"

@interface SearchCollectionViewCell ()

@end

@implementation SearchCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
    }];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = HEX(@"666666", 1.0);
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
    titleLab.layer.cornerRadius=3;
    titleLab.clipsToBounds=YES;
    titleLab.backgroundColor = HEX(@"f7f7f7", 1.0);
}

-(void)reloadCellWith:(NSString *)title{
    self.titleLab.text = title;
}


@end
