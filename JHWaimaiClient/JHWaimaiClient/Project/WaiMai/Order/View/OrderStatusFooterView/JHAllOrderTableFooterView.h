//
//  JHGroupOrderDetailFooterView.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderStatusActionProtocol.h"

@interface JHAllOrderTableFooterView : UITableViewHeaderFooterView

@property(nonatomic,weak)id<JHOrderStatusActionProtocol> delegate;

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier btnMasRect:(JHAllOrderFooterBtnMasRect)btnMasRect;

-(void)reloadViewWith:(id)model;

@end
