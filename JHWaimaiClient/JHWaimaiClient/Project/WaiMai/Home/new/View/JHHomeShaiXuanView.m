//
//  JHHomeShaiXuanView.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/27.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeShaiXuanView.h"
#import "YFTypeBtn.h"

@implementation JHHomeShaiXuanView

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    if (self.filterView == nil) {
        self.filterView = [[YFWMFilterView alloc] initWithFrame:FRAME(0, 0, WIDTH, 44) titleArr:titleArr];
        //    filterView.firstSelectedType = _cate_id;
        [self addSubview:_filterView];
        [_filterView getData];
        __weak typeof(self) weakSelf=self;
        _filterView.chooseFilter = ^(NSString *cate_id,NSString *order,NSString *pei_filter,NSString *youhui_filter,
                                     NSString *feature_filter,int filterIndex,NSString *title1,NSString *title2,NSString *title3){
            if (filterIndex == 1) {
                weakSelf.filterDic[@"cate_id"] = cate_id;
                weakSelf.filterDic[@"title1"] = title1;
            }else if (filterIndex == 2){
                weakSelf.filterDic[@"order"] = order;
                weakSelf.filterDic[@"title2"] = title2;
            }else{
                weakSelf.filterDic[@"pei_filter"] = pei_filter;
                weakSelf.filterDic[@"youhui_filter"] = youhui_filter;
                weakSelf.filterDic[@"feature_filter"] = feature_filter;
            }
            //通知各处筛选条件发生改变
            [NoticeCenter postNotificationName:KNotification_Home_shaixuanChanged object:weakSelf.filterDic];
        };
    }else{
        [self.filterView updateTitle:titleArr];
    }
    
}
-(NSMutableDictionary *)filterDic{
    if (_filterDic==nil) {
        _filterDic=[[NSMutableDictionary alloc] init];
        _filterDic[@"cate_id"] = @"0";
        _filterDic[@"order"] = @"";
        _filterDic[@"pei_filter"] = @"";
        _filterDic[@"youhui_filter"] = @"";
        _filterDic[@"feature_filter"] = @"";
        _filterDic[@"page"] = @(1);
        _filterDic[@"title1"] = NSLocalizedString(@"全部分类   ",nil);
        _filterDic[@"title2"] = NSLocalizedString(@"排序   ",nil);
        _filterDic[@"title3"] = NSLocalizedString(@"筛选   ",nil);
    }
    return _filterDic;
}
@end
