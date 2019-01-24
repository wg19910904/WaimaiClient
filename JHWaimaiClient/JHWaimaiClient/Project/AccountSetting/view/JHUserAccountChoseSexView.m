//
//  JHUserAccountChoseSexView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHUserAccountChoseSexView.h"
#import "JHUserAccountChoseSexCell.h"
@interface JHUserAccountChoseSexView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *myTableView;
@end
@implementation JHUserAccountChoseSexView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}
//基础配置
-(void)config{
    self.backgroundColor = HEX(@"000000", 0.4);
    self.alpha = 0;
    [self addTarget:self action:@selector(clickRemove) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
    [self myTableView];
    [self showAnimation];
}
-(void)showSexView{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}
//移除
-(void)clickRemove{
    [self removeAnimaiton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });

}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, HEIGHT-100, WIDTH, 100) style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.scrollEnabled = NO;
            table.backgroundColor = [UIColor whiteColor];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self addSubview:table];
            table;
        });
    }
    return _myTableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *str = @"JHUserAccountChoseSexCell";
    JHUserAccountChoseSexCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[JHUserAccountChoseSexCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.leftTitle = indexPath.row == 0?NSLocalizedString(@"男", nil):NSLocalizedString(@"女", nil);
    cell.isHid = indexPath.row == 0?NO:YES;
    cell.isSelector = _sex?(indexPath.row==[_sex integerValue]?YES:NO):NO;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _sex = @(indexPath.row).stringValue;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clickRemove];
    });
    if (self.myBlock) {
        self.myBlock(indexPath.row);
    }
}
#pragma mark - 出现的动画
-(void)showAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    animation.duration = 0.2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(HEIGHT+50),@(HEIGHT - 50)];
    [_myTableView.layer addAnimation:animation forKey:nil];
}
#pragma mark - 消失的动画
-(void)removeAnimaiton{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    animation.duration = 0.2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(HEIGHT - 50),@(HEIGHT + 50)];
    [_myTableView.layer addAnimation:animation forKey:nil];
}
@end
