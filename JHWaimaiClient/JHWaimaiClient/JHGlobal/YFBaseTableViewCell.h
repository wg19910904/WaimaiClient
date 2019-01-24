//
//  YFBaseTableViewCell.h
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"

@interface YFBaseTableViewCell : UITableViewCell
@property(nonatomic,weak)JHBaseVC *superVC;
@property(nonatomic,weak)UIView *topLineView;
@property(nonatomic,assign)BOOL is_need_hidden_line;

+(instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

// 刷新cell
-(void)reloadCellWithModel:(id)model;

// 获取cell对应的tableView
-(UITableView *)getCellTableView;

// 添加手势
-(void)addTapGesture;
// 移除点击手势
-(void)removeTapGesture;
// 点击cell需要做的事
-(void)didSelectedCell;

// cell添加边框
-(void)addTopBorderLayer;
-(void)addBottomBorderLayer;
-(void)addLeftBorderLayer;
-(void)addRightBorderLayer;

@end
