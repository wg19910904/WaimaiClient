//
//  JHHomeCateCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeCateCellFour.h"
#import "YFKindItemCollectionView.h"
#import "XHImageView.h"
@interface JHHomeCateCellFour()
@property(nonatomic,weak)YFKindItemCollectionView *kindItemCollection;
@end

@implementation JHHomeCateCellFour
{
    XHImageView *bgIV;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self configUI];
    }
    return self;
}

-(void)configUI{
    //
    bgIV = [XHImageView new];
    [self.contentView addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset = 0;
        make.width.offset = WIDTH;
        make.height.offset = 205*KUI_SCALE;
    }];
    bgIV.backgroundColor = [UIColor clearColor];
    //
    YFKindItemCollectionView *kindItemCollection = [YFKindItemCollectionView new];
    [self.contentView addSubview:kindItemCollection];
    // 确定高度可以直接写，不确定的可以在刷新中重新update约束
    [kindItemCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 205*KUI_SCALE;
        make.left.right.top.offset = 0;
        make.bottom.offset = 0;
    }];
    kindItemCollection.colOrLineItems = 4;
    [kindItemCollection setClickKindItem:^(NSInteger index) {
        NSDictionary *clickDic = (NSDictionary *)_dataDic[@"content"][index];
        NSString *link = clickDic[@"link"];
        [NoticeCenter postNotificationName:KNotification_Home_newLink object:link];
    }];
    
    self.kindItemCollection = kindItemCollection;
}

-(void)reloadCellWithArr:(NSArray *)kindItemArr{
    [self.kindItemCollection mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = kindItemArr.count >= 4 ? 205*KUI_SCALE : 96;
        make.bottom.offset = 0;
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
//设置数据
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    //
    NSString *background_color = dataDic[@"background_color"];
    if (background_color.length) {
        bgIV.backgroundColor = HEX(background_color, 1.0);
    }
    //
    NSArray *content = dataDic[@"content"];
    NSMutableArray *dataArr = @[].mutableCopy;
    for(NSDictionary *contentDic in content){
        NSDictionary *itemDic = @{@"title":contentDic[@"title"],
                                  @"icon":contentDic[@"photo"]
                                  };
        [dataArr addObject:itemDic];
    }
    if(dataArr.count){
        [self reloadCellWithArr:dataArr];
    }
}


@end
