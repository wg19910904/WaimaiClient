//
//  JHHomeHeaderView.h
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/7/23.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHHomeHeaderView.h"

@interface JHHomeHeaderViewOne : JHHomeHeaderView<UITextFieldDelegate>
@property(nonatomic,strong)id dataModel;


//数据
@property(nonatomic,copy)NSDictionary *dataDic;

@end
