//
//  JHWMChooseRedBagOrQuanVC.h
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/11/20.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHWMChooseRedBagOrQuanVC : JHBaseVC
@property(nonatomic,assign)BOOL is_redbag;      // 使用红包还是优惠劵
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,copy)ClickIndexBlock clickIndexBlock;   // 选择了第几个
@property(nonatomic,copy)NSString *chooesed_id;// 选择的红包或优惠劵id
@end

