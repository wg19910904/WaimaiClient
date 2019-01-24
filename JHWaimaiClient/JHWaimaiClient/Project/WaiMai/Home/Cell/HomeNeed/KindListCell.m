//
//  JHKindListCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/4/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "KindListCell.h"
#import "YFKindItemCollectionView.h"

@interface KindListCell()
@property(nonatomic,weak)YFKindItemCollectionView *kindItemCollection;
@end

@implementation KindListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    YFKindItemCollectionView *kindItemCollection = [YFKindItemCollectionView new];
    [self.contentView addSubview:kindItemCollection];
    // 确定高度可以直接写，不确定的可以在刷新中重新update约束
    [kindItemCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 175;
        make.edges.offset = 0;
    }];
    kindItemCollection.colOrLineItems = 5;
    self.kindItemCollection = kindItemCollection;
}

-(void)reloadCellWithArr:(NSArray *)kindItemArr{
    [self.kindItemCollection mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset = kindItemArr.count >= 5 ? 175 : 90;
    }];
    self.kindItemCollection.dataSource = kindItemArr;
}

-(void)setClickKindItem:(ClickKindItem)clickKindItem{
    self.kindItemCollection.clickKindItem = clickKindItem;
}

-(void)setLineOfItems:(int)lineOfItems{
    _lineOfItems = lineOfItems;
    self.kindItemCollection.colOrLineItems = lineOfItems;
}

@end
