//
//  JHWMShopNoticeVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/22.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMShopNoticeVC.h"
#import "PresentAnimationTransition.h"
#import "YFStartView.h"
#import "NSString+Tool.h"

@interface JHWMShopNoticeVC ()<UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UILabel *statusLab;
@property(nonatomic,weak)YFStartView *starView;
@property(nonatomic,weak)UILabel *titleLab;
@end

@implementation JHWMShopNoticeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.statusLab.text = self.shopModel.status == 1 ? NSLocalizedString(@"营业中",nil) : NSLocalizedString(@"已打烊",nil);
    self.starView.currentStarScore = self.shopModel.avg_score;
    self.titleLab.text = self.shopModel.title;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 30;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    
    [self createHeaderView];
    
    UIButton *closeBtn = [UIButton new];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.bottom.offset=-30;
        make.width.offset=40;
        make.height.offset=40;
    }];
    [closeBtn setImage:IMAGE(@"index_btn_closeBig") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 140)];
    
    UILabel *titleLab = [UILabel new];
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=60;
        make.right.offset=0;
        make.height.offset=20;
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
    
    UILabel *statusLab = [UILabel new];
    [view addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset= 0;
        make.top.equalTo(titleLab.mas_bottom).offset=10;
        make.width.greaterThanOrEqualTo(@40);
        make.height.offset=15;
    }];
    statusLab.font = FONT(10);
    statusLab.textColor = [UIColor whiteColor];
    statusLab.layer.cornerRadius=4;
    statusLab.clipsToBounds=YES;
    statusLab.textAlignment = NSTextAlignmentCenter;
    statusLab.backgroundColor = THEME_COLOR_Alpha(1.0);
    self.statusLab = statusLab;
    
    YFStartView *starView = [YFStartView new];
    [view addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset= 0;
        make.top.equalTo(statusLab.mas_bottom).offset=10;
        make.height.offset = 12;
        make.width.offset = 70;
    }];
    starView.interSpace = 2.5;
    starView.fullStarNum = 5;
    starView.starType = YFStarViewFloat;
    starView.userInteractionEnabled = NO;
    starView.imgSize = CGSizeMake(12, 12);
    starView.backgroundColor = [UIColor clearColor];
    self.starView = starView;
    
    self.tableView.tableHeaderView = view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.shopModel.huodong.count== 0 ? 1 : 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.shopModel.huodong.count == 0 ? 1 : self.shopModel.huodong.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && self.shopModel.huodong.count != 0) {
        static NSString *ID=@"ShoperActivityCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            UILabel *lab = [UILabel new];
            [cell.contentView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=30;
                make.top.offset=2.5;
                make.width.offset= 13;
                make.height.offset = 13;
                make.bottom.offset=-2.5;
            }];
            lab.layer.cornerRadius=3;
            lab.clipsToBounds=YES;
            lab.font = FONT(10);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor whiteColor];
            lab.tag = 101;
            
            
            UILabel *desLab = [UILabel new];
            [cell addSubview:desLab];
            [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=56;
                make.centerY.offset=0;
                make.right.offset=-30;
//                make.height.offset=13;
            }];
            desLab.lineBreakMode = NSLineBreakByTruncatingTail;
            desLab.font = FONT(11);
            desLab.textColor = [UIColor whiteColor];
            desLab.tag = 102;
            desLab.numberOfLines = 0;
            
        }
        
        UILabel *typeLab = [cell viewWithTag:101];
        UILabel *desLab = [cell viewWithTag:102];
        NSDictionary *dic = self.shopModel.huodong[indexPath.row];
        typeLab.backgroundColor = HEX(dic[@"color"], 1.0);
        typeLab.text = dic[@"word"];
        desLab.text = dic[@"title"];
        return cell;

    }
    
    static NSString *ID=@"tablevi";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UILabel *desLab = [UILabel new];
        [cell addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=30;
            make.top.offset=0;
            make.right.offset=-30;
            make.bottom.offset = 0;
        }];
        desLab.numberOfLines = 7;
        desLab.lineBreakMode = NSLineBreakByTruncatingTail;
        desLab.font = FONT(13);
        desLab.textColor = [UIColor whiteColor];
        desLab.tag = 102;
    }
    UILabel *desLab = [cell viewWithTag:102];
    NSString *notice = self.shopModel.delcare.length == 0 ? NSLocalizedString(@"暂无公告", nil) : self.shopModel.delcare;
    desLab.attributedText = [NSString getParagraphStyleAttributeStr:notice lineSpacing:3.0];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];

    UILabel *titleLab =[UILabel new];
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=0;
        make.width.offset=90;
        make.height.offset=20;
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    if (section == 0) {
        titleLab.text = self.shopModel.huodong.count == 0 ? NSLocalizedString(@"商家公告", @"JHWMShopNoticeVC") : NSLocalizedString(@"商家活动", @"JHWMShopNoticeVC") ;
    }else{
        titleLab.text = NSLocalizedString(@"商家公告", @"JHWMShopNoticeVC");
    }
    
    UIView *lineViewL=[UIView new];
    [view addSubview:lineViewL];
    [lineViewL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset=0;
        make.left.offset= 30;
        make.right.equalTo(titleLab.mas_left).offset=0;
        make.height.offset = 1;
    }];
    lineViewL.backgroundColor= [UIColor whiteColor];
    
    UIView *lineViewR=[UIView new];
    [view addSubview:lineViewR];
    [lineViewR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset=0;
        make.left.equalTo(titleLab.mas_right).offset= 0;
        make.right.offset=-30;
        make.height.offset = 1;
    }];
    lineViewR.backgroundColor= [UIColor whiteColor];
    return view;
}

#pragma mark ======动画的实现=======
-(instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = HEX(@"000000", 0.9);
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

//非手势的动画实现
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [PresentAnimationTransition transitionWithTransitionType:YFPresentTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [PresentAnimationTransition transitionWithTransitionType:YFPresentTransitionTypeDismiss];
}


- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ======拦截点击事件=======
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
}

@end
