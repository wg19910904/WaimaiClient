//
//  YFBaseSheetView.h
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/30.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBaseSheetView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)CGFloat backViewHeight;// 展示的view的高度

-(void)yf_sheetShowAnimation;

-(void)yf_sheetHiddenAnimation;


@end
