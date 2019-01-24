//
//  ShopDetailYouHuiView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ShopDetailYouHuiView.h"
#import "YFTypeBtn.h"

#define cellHeight 18

@interface ShopDetailYouHuiView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,weak)YFTypeBtn *countBtn;
@end

@implementation ShopDetailYouHuiView

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH,0) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self addSubview:tableView];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=0;
        make.right.offset=-10;
        make.bottom.offset=0;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"ShoperActivityCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(0, 0, 13, 13)];
        [cell addSubview:lab];
        lab.centerY = cellHeight/2.0;
        lab.layer.cornerRadius=3;
        lab.clipsToBounds=YES;
        lab.font = FONT(10);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.tag = 101;
        
        UILabel *desLab = [UILabel new];
        [cell addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=25;
            make.centerY.offset=0;
            make.right.offset=-60;
            make.height.offset=13;
        }];
        desLab.lineBreakMode = NSLineBreakByTruncatingTail;
        desLab.font = FONT(11);
        desLab.textColor = [UIColor whiteColor];
        desLab.tag = 102;
        
        if (indexPath.row == 0) {
            YFTypeBtn *countBtn = [YFTypeBtn new];
            [cell addSubview:countBtn];
            [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset=0;
                make.right.offset=-10;
                make.height.offset=15;
            }];
            countBtn.btnType = RightImage;
            countBtn.titleMargin = -5;
            countBtn.imageMargin = 5;
            countBtn.titleLabel.font = FONT(10);
            [countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [countBtn setImage:IMAGE(@"index_arrow_down_white") forState:UIControlStateNormal];
            [countBtn addTarget:self action:@selector(clickShowMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
            self.countBtn = countBtn;
        }
        
    }
    
    UILabel *typeLab = [cell viewWithTag:101];
    UILabel *desLab = [cell viewWithTag:102];
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    typeLab.backgroundColor = HEX(dic[@"color"], 1.0);
    typeLab.text = dic[@"word"];
    desLab.text = dic[@"title"];
    
    
    [self.countBtn setTitle:[NSString stringWithFormat:@"%ld%@",self.dataSource.count,NSLocalizedString(@"个活动", nil)] forState:UIControlStateNormal];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

#pragma mark ====== Functions =======
// 刷新view
-(void)reloadViewWithArr:(NSArray *)youHuiArr{
    self.dataSource = youHuiArr;
    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset=youHuiArr.count * cellHeight + 2;
    }];
    
}

// 显示跟多的优惠信息出来
-(void)clickShowMoreBtn:(UIButton *)btn{
    if (self.dataSource.count <= 1) {
        return;
    }
//    btn.selected = !btn.selected;
    if (self.clickShowMore) {
        self.clickShowMore(!btn.selected);
//        [self starAnimationWithSelected:btn.selected];
    }
}

// 改变cell的透明度
-(void)setTopOffset:(float)topOffset{
    _topOffset = topOffset;

    if (topOffset >= self.tableView.maxY) {
        if (!self.countBtn.selected) {
            [self starAnimationWithSelected:YES];
            self.countBtn.selected= YES;
        }
    }else{
        if (self.countBtn.selected) {
            [self starAnimationWithSelected:NO];
            self.countBtn.selected= NO;
        }
    }
    
    float alpha = 0;
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        if (cell.maxY < topOffset) {
            alpha = 1.0;
        }else if (cell.maxY >= topOffset && cell.y <= topOffset){
            alpha = (topOffset - cell.y)/cellHeight;
        }else{
            alpha = 0;
        }
        [UIView animateWithDuration:0.25 animations:^{
            cell.alpha = alpha;
        }];
    }
    
}

// 按钮的动画
-(void)starAnimationWithSelected:(BOOL)selected{
    
    if (self.dataSource.count <= 1) {
        return;
    }
    
    CALayer *layer = self.countBtn.imageView.layer;
    layer.bounds = self.countBtn.imageView.bounds;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (selected) {
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat: M_PI];
    }else{
        animation.fromValue = [NSNumber numberWithFloat:M_PI];
        animation.toValue = [NSNumber numberWithFloat:0.0];
    }
    animation.duration = 0.35;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:nil];
   
}

@end
