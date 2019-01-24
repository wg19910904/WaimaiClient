//
//  JHNewWaiMaiMySelfVC.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/24.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHNewWaiMaiMySelfVC.h"
#import "JHUserModel.h"
#import "JHWaimaiMineViewModel.h"
#import "JHWaiMaiMySelfCellTwo.h"
#import "JHWaiMaiMySelfCellOne.h"
#import "JHWaiMaiMySelfCellThree.h"
#import "JHWaiMaiMySelfCellFour.h"
@interface JHNewWaiMaiMySelfVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView * _centertable;
        JHUserModel *userModel;
    NSMutableArray * itemsArr;
}

@end

@implementation JHNewWaiMaiMySelfVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView{
    self.view.backgroundColor  = BACK_COLOR;
    
    itemsArr = @[].mutableCopy;
    [self creatTableView];
    
    self.naviColor = HEX(@"ffffff", 1);
    NSDictionary *dic =   [UserDefaults objectForKey:@"appInfo"];
    NSArray *tempArr =dic[@"customModule"];
    [itemsArr addObjectsFromArray:tempArr];
    [self addRightBtnWith:@"nav_btn_set" sel:@selector(setBtnClick)];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([JHUserModel shareJHUserModel].token) {
        [self loadData];
    }else{
        [_centertable reloadData];
    }
    [self.navigationController.navigationBar yf_setLineAlpha:0];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar yf_setLineAlpha:1];
}

#pragma mark =================UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3+itemsArr.count-1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section <3) {
        return 1;
    }else{
        for (NSInteger i=1; i<itemsArr.count; i++) {
            if (section == 3+i-1) {
                NSArray * arr = itemsArr[i];
                return arr.count;
            }
        }
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section>1) {
        return 8;
    }
    return CGFLOAT_MIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak typeof(self) weakSelf = self;
    switch (indexPath.section) {
        case 0:
        {
            JHWaiMaiMySelfCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"JHWaiMaiMySelfCellOne"];
            if (!cell) {
                cell = [[JHWaiMaiMySelfCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHWaiMaiMySelfCellOne"];
            }
            cell.userModel = userModel;
            cell.clickBlock = ^(NSInteger index) {
               [weakSelf cellOneClick:index];
            };
            return cell;
            
        }
            break;
        case 1:
        {
            JHWaiMaiMySelfCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"JHWaiMaiMySelfCellTwo"];
            if (!cell) {
                cell = [[JHWaiMaiMySelfCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHWaiMaiMySelfCellTwo"];
            }
            cell.userModel = userModel;
            cell.clickBlock = ^(NSInteger index) {
                [weakSelf cellTwoClick:index];
            };
            return cell;
            
        }
            break;
        case 2:
        {
            JHWaiMaiMySelfCellThree *cell = [tableView dequeueReusableCellWithIdentifier:@"JHWaiMaiMySelfCellThree"];
            if (!cell) {
                cell = [[JHWaiMaiMySelfCellThree alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHWaiMaiMySelfCellThree"];
            }
            cell.clickBlock = ^(NSInteger index) {
            [weakSelf cellThreeClick:index];
            };
            return cell;
            
        }
            break;
            
        default:{
            
            JHWaiMaiMySelfCellFour *cell = [tableView dequeueReusableCellWithIdentifier:@"JHWaiMaiMySelfCellFour"];
            if (!cell) {
                cell = [[JHWaiMaiMySelfCellFour alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHWaiMaiMySelfCellFour"];
            }
            NSDictionary *dic = itemsArr[indexPath.section-3+1][indexPath.row];
            cell.dic = dic;
            return cell;
            
        }
            break;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        __weak typeof (self)weakSelf = self;
    if (indexPath.section>2) {
        NSDictionary *dic = itemsArr[indexPath.section-3+1][indexPath.row];
        if (indexPath.section == 4) {
            if ([dic[@"phone"] length]) {
                [self callWithPhone:dic[@"phone"]];
                return;
            }
             [self pushToNextByRoute:dic[@"link"] vc:weakSelf];
            
        }else{
           if (![JHUserModel shareJHUserModel].token) {
               [self showToastAlertMessageWithTitle:@"请先登录!"];
               return;
           }
            [self pushToNextByRoute:dic[@"link"] vc:weakSelf];
        }
    }

}


#pragma mark ====== Functions =======
-(void)loadData{
    if ([JHUserModel shareJHUserModel].token.length == 0) {
        [_centertable endRefresh];
        return;
    }
    SHOW_HUD
    [JHWaimaiMineViewModel postToGetUserInfoWithBlock:^(NSString *error) {
        [_centertable endRefresh];
        HIDE_HUD
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
            userModel = [JHUserModel shareJHUserModel];
            [_centertable reloadData];
        }
    }];
}

// 设置按钮点击
-(void)setBtnClick{
    if ([JHUserModel shareJHUserModel].token.length > 0) {
        [self pushToNextVcWithVcName:@"JHUserAccountSetVC"];
    }else{
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先登录!", nil)];
    }
}

// cellone中的点击事件
-(void)cellOneClick:(NSInteger )index{
    if (index == 100) {//签到
        if ([JHUserModel shareJHUserModel].token.length > 0) {
              [self pushToNextVcWithVcName:@"JHADWebVC" params:@{@"url":[JHUserModel shareJHUserModel].signin_link}];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先登录!", nil)];
        }
    }else if(index == 50){//未登录时 立即登录
        [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
    }else if(index == 40){//登录后跳到设置界面
        [self setBtnClick];
    }
}
// cellTwo中的点击事件
-(void)cellTwoClick:(NSInteger )index{
    if (![JHUserModel shareJHUserModel].token) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先登录!", nil)];
        return;
    }
    
    NSString * str;
    switch (index-50) {
        case 0:
            str = @"JHWaimaiMyBalanceVC";
            break;
        case 1:
            str = userModel.hongbao_url;
            break;
            
        case 2:
            str = userModel.coupon_url;
            break;
            
            
        case 3:
            str = userModel.jifen_url;
            break;
            
        default:
            break;
    }
    
    if ([str isEqualToString:@"JHWaimaiMyBalanceVC"]) {
        [self pushToNextVcWithVcName:@"JHWaimaiMyBalanceVC" params:nil];
    }else{
        
        if (str.length==0) {
            return;
        }
        
        [self pushToNextVcWithVcName:@"JHADWebVC" params:@{@"url":str}];
        
    }
}
// cellThree 中的点击事件
-(void)cellThreeClick:(NSInteger )index{
    if (![JHUserModel shareJHUserModel].token) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先登录!", nil)];
        return;
    }
    NSArray *tempArr = itemsArr[0];
    NSString * str;
    switch (index) {
        case 0:
            str = @"JHWaiMaiAddressVC";
            break;
            
        case 1:{
            NSDictionary * dic = tempArr[1];
            str = dic[@"link"];
        }
            break;
            
        case 2:
        {
            NSDictionary * dic = tempArr[2];
            str = dic[@"link"];
        }
            break;
            
        case 3:
            str = @"JHMyMessageVC";
            break;
            
        default:
            break;
    }
    
    if ([str isEqualToString:@"JHMyMessageVC"]) {
        [self pushToNextVcWithVcName:@"JHMyMessageVC" params:nil];
    }else if([str isEqualToString:@"JHWaiMaiAddressVC"]){
        [self pushToNextVcWithVcName:@"JHWaiMaiAddressVC" params:nil];
        
    }else{
        if (str.length==0) {
            return;
        }
        
        [self pushToNextVcWithVcName:@"JHADWebVC" params:@{@"url":str}];
        
    }
}

-(void)creatTableView{
    if (!_centertable) {
        
        _centertable = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT-TABBAR_HEIGHT)
                                                    style:(UITableViewStylePlain)];
        [self.view addSubview:_centertable];
        _centertable.delegate = self;
        _centertable.showsVerticalScrollIndicator = NO;
        _centertable.showsHorizontalScrollIndicator = NO;
        _centertable.dataSource = self;
        _centertable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _centertable.backgroundColor = HEX(@"ffffff", 1);
        _centertable.estimatedRowHeight = 100;
        _centertable.rowHeight = UITableViewAutomaticDimension;
        __weak typeof(self) weakSelf = self;
        //--下拉加载
        [_centertable bindHeadRefreshHandler:^{
            [weakSelf loadData];
        }];
    }
}

@end
