//
//  JHSkyHongBaoVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHSkyHongBaoVC.h"
#import "JHSkyHongBaoCell.h"
#import "PresentAnimationTransition.h"

@interface JHSkyHongBaoVC ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIImageView *topIV;
@property(nonatomic,weak)UIButton *closeBtn;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UIButton *getBtn;

@end

@implementation JHSkyHongBaoVC

-(instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView{

    UIView *bgV = [UIView new];
    [self.view addSubview:bgV];
    bgV.layer.cornerRadius=4;
    bgV.clipsToBounds=YES;
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset= -10;
        make.width.offset = 320;
    }];
    bgV.contentMode = UIViewContentModeScaleAspectFill;
    bgV.userInteractionEnabled = YES;
    self.backView = bgV;
    //
    UIImageView *topIV = [UIImageView new];
    [bgV addSubview:topIV];
    [topIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset = 0;
        make.width.offset = 320;
        make.height.offset = 150;
    }];
    topIV.contentMode = UIViewContentModeScaleAspectFill;
    topIV.clipsToBounds = YES;
    topIV.backgroundColor = [UIColor clearColor];
    self.topIV = topIV;

    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [bgV addSubview:tableView];
    tableView.backgroundColor= [UIColor clearColor];
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=150;
        make.right.offset=0;
        make.height.offset= (72 + 10) * 1 + 10;
        make.bottom.offset = 0;
    }];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    UIButton *getBtn = [UIButton new];
    [self.view addSubview:getBtn];
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.top.mas_equalTo(bgV.mas_bottom).offset = 20;
        make.width.offset=236;
        make.height.offset=51;
    }];
    [getBtn setTitle:NSLocalizedString(@"立即领取", nil) forState:(UIControlStateNormal)];
    [getBtn setBackgroundImage:IMAGE(@"lingqu") forState:UIControlStateNormal];
    [getBtn setTitleColor:HEX(@"F0021D", 1.0) forState:(UIControlStateNormal)];
    getBtn.titleLabel.font = FONT(16);
    [getBtn addTarget:self action:@selector(getHongBao) forControlEvents:(UIControlEventTouchUpInside)];
    self.getBtn = getBtn;
    //
    [self addCloseBtn];
}

- (void)addCloseBtn{
    UIButton *closeBtn = [UIButton new];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 28;
        make.height.offset = 66;
        make.right.equalTo(self.backView);
        make.top.equalTo(self.backView).offset = -48;
    }];
    [closeBtn setImage:IMAGE(@"hongbao_close") forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeHongBao) forControlEvents:(UIControlEventTouchUpInside)];
    self.closeBtn = closeBtn;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"JHSkyHongBaoCell";
    JHSkyHongBaoCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[JHSkyHongBaoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    JHSkyHongBaoModel *model = self.dataSource[indexPath.section];
    [cell reloadCellWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
  
    return  [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypeShowHongBao];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return  [[PresentAnimationTransition alloc] initWithTransitionType:YFPresentTransitionTypeDismissHongBao];
    
}

#pragma mark ====== Functions =======
-(void)setHongBaoDic:(NSDictionary *)hongBaoDic{
    _hongBaoDic = hongBaoDic;
    self.dataSource = [JHSkyHongBaoModel mj_objectArrayWithKeyValuesArray:hongBaoDic[@"items"]];
    [self.tableView reloadData];
    NSInteger count = self.dataSource.count;
    
    self.tableView.scrollEnabled = count > 3 ? YES : NO;
    count = count > 3 ? 3 : count;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset=(72 + 10) * count + 10;
    }];

    //更新背景图
    __weak typeof(self)ws = self;
    NSString *bgImg = hongBaoDic[@"background"];
    [self.topIV sd_setImageWithURL:[NSURL URLWithString:bgImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            ws.topIV.backgroundColor = [UIColor redColor];
        }
    }];
    //更新背景色
    NSString *bgColor = hongBaoDic[@"background_color"];
    bgColor = bgColor.length == 6 ? bgColor : @"e13337";
    _tableView.backgroundColor = HEX(bgColor, 1.0);
    
    //
    NSString *type = _hongBaoDic[@"type"];
    switch (type.integerValue) {
            case 1: //天降红包
                [self.getBtn setTitle:NSLocalizedString(@"立即使用", nil) forState:(UIControlStateNormal)];
                break;
            case 2: //新人红包
                [self.getBtn setTitle:NSLocalizedString(@"立即领取", nil) forState:(UIControlStateNormal)];
                break;
            case 3: //平台红包
                [self.getBtn setTitle:NSLocalizedString(@"立即查看", nil) forState:(UIControlStateNormal)];
                break;
            default:
                break;
    }
}

// 领取红包
-(void)getHongBao{
    
    [self closeHongBao];
    
    if (self.getBlock) {
        self.getBlock();
    }
}

// 关闭界面
-(void)closeHongBao{
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
}

@end
