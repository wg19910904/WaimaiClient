//
//  JHAllOrderDetailBottomView.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderStatusActionProtocol.h"

@interface JHAllOrderDetailStatusView : UIView

@property(nonatomic,weak)id<JHOrderStatusActionProtocol> delegate;

-(void)reloadViewWith:(id )model;

@end
