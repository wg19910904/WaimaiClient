//
//  YFBaseSheetView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/30.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseSheetView.h"
#import "AppDelegate.h"

@interface YFBaseSheetView()
@property(nonatomic,assign)NSInteger selectedRow;
@end

@implementation YFBaseSheetView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [control addTarget:self action:@selector(yf_sheetHiddenAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    self.control=control;
    
    UIView *backView = [UIView new];
    [control addSubview:backView];
    self.backView = backView;
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 300) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [backView addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark ====== 子类可重写的方法 =======
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark ====== Functions =======
// 弹出
-(void)yf_sheetShowAnimation{
    
    [self.control layoutIfNeeded];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.control];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.control.alpha=1;
    }];
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.y = HEIGHT - _backViewHeight;
    }];

}

// 消失
-(void)yf_sheetHiddenAnimation{
    
    [UIView animateWithDuration:0.15 animations:^{
        self.control.alpha=0.0;
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.y = HEIGHT + _backViewHeight;
        [self.control layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [self.tableView reloadData];
}


@end
