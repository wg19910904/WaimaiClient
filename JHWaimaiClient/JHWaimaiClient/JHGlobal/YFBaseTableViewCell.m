//
//  YFBaseTableViewCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "YFBaseTableViewCell.h"

@interface YFBaseTableViewCell ()<UIGestureRecognizerDelegate>
@property(nonatomic,weak)UIView *bottomLineView;
@property(nonatomic,weak)UIView *leftLineView;
@property(nonatomic,weak)UIView *rightLineView;
@property(nonatomic,weak)UIGestureRecognizer *tap;
@end

@implementation YFBaseTableViewCell

+(instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier{
    Class class = [self class];
    YFBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[class alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(void)reloadCellWithModel:(id)model{}

-(void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedCell)];
    [self addGestureRecognizer:tap];
    self.tap = tap;
}

-(void)didSelectedCell{}

// 移除点击手势
-(void)removeTapGesture{
    [self.tap removeTarget:self action:@selector(didSelectedCell)];
    [self removeGestureRecognizer:self.tap];
}

-(UITableView *)getCellTableView{
    
    UIView *superView = self.superview;
    while (1) {
        if ([superView isKindOfClass:[UITableView class]]) {
            return (UITableView *)superView;
        }else{
            if (!superView.superview) {
                return nil;
            }
            superView = superView.superview;
        }
    }
}

-(void)addTopBorderLayer{
    UIView *topLineView=[UIView new];
    [self.contentView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset=0;
        make.top.offset=0.5;
        make.height.offset=0.5;
    }];
    topLineView.backgroundColor = CELL_BORDER_COLOR;
    self.topLineView = topLineView;
}

-(void)addBottomBorderLayer{
    UIView *bottomLineView=[UIView new];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset=0;
        make.bottom.offset=-0.5;
        make.height.offset=0.5;
    }];
    bottomLineView.backgroundColor = CELL_BORDER_COLOR;
    self.bottomLineView = bottomLineView;
}

-(void)addLeftBorderLayer{
    UIView *leftLineView=[UIView new];
    [self.contentView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0.5;
        make.width.offset = 0.5;
        make.top.bottom.offset=0;
    }];
    leftLineView.backgroundColor = CELL_BORDER_COLOR;
    self.leftLineView = leftLineView;
}

-(void)addRightBorderLayer{
    UIView *rightLineView=[UIView new];
    [self.contentView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-0.5;
        make.width.offset = 0.5;
        make.top.bottom.offset=0;
    }];
    rightLineView.backgroundColor = CELL_BORDER_COLOR;
    self.rightLineView = rightLineView;
}

-(void)setIs_need_hidden_line:(BOOL)is_need_hidden_line{
    _is_need_hidden_line = is_need_hidden_line;
    self.topLineView.hidden = is_need_hidden_line;
    self.bottomLineView.hidden = is_need_hidden_line;
    self.leftLineView.hidden = is_need_hidden_line;
    self.rightLineView.hidden = is_need_hidden_line;
}

@end
