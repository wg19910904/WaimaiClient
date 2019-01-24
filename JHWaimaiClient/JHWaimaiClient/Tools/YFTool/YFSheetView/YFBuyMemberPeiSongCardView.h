//
//  YFBuyMemberPeiSongCardView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/30.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseSheetView.h"

typedef void(^ChoosedCardBlock)(NSDictionary *cardInfo);

@interface YFBuyMemberPeiSongCardView : YFBaseSheetView
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,copy)ChoosedCardBlock choosedCardBlock;
@property(nonatomic,copy)NSString *choosed_card_id;
//is_buy 是否已经买过会员卡了
-(instancetype)initWithFrame:(CGRect)frame is_bug:(BOOL)is_buy;

@end
