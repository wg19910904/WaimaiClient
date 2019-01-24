//
//  JHShopDetailVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/5.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHShopDetailVC.h"
#import "WMShopDetailCellOne.h"
#import "WMShopDetailCellTwo.h"
#import "WMShopDetailCellThree.h"
#import "JHShowShopLocationVC.h"
#import "WMShopModel.h"

@interface JHShopDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)WMShopModel *shop;
@end

@implementation JHShopDetailVC

-(void)loadView{
    [super loadView];
    [self setUpView];
     [NoticeCenter addObserver:self selector:@selector(tableViewScrollsToTop) name:ScrollToTop object:nil];
}
-(void)dealloc{
    Remove_Notice
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.shop) {
        [self showEmptyViewWithImgName:@"icon_wu" desStr:nil btnTitle:nil inView:self.view];
         return 0;
    }else{
        [self hiddenEmptyView];
    }
    return self.shop.huodong.count == 0 ? 2 : 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        if (self.shop.huodong.count == 0 ) {
            return 2;
        }else{
            return self.shop.huodong.count;
        }
    }else {
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *ID=@"WMShopDetailCellOne";
        WMShopDetailCellOne *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WMShopDetailCellOne alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (indexPath.row < 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        NSString *img = @"";
        NSString *title = @"";
        switch (indexPath.row) {
            case 0:
                img = @"index_icon_shopDes_call";
                title = self.shop.phone;
                break;
            case 1:
                img = @"index_icon_shopDes_location_ray";
                title = self.shop.addr;
                break;
            case 2:
                img = @"index_icon_shopDes_time";
                
                title = [NSString stringWithFormat: @"%@ %@",NSLocalizedString(@"营业时间:", @"JHShopDetailVC"),self.shop.yy_time];
                break;
            case 3:
                img = @"index_icon_shopDes_peison";
                NSString *str = self.shop.pei_type == 1 ? NSLocalizedString(@"平台专送", @"JHShopDetailVC") : NSLocalizedString(@"商家配送", @"JHShopDetailVC");
                title = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"配送服务: ", @"JHShopDetailVC"),str];
                break;
        }
        [cell reloadCellWith:img title:title];
        return cell;
    }else if (indexPath.section == 1){
        if (self.shop.huodong.count == 0) {
            static NSString *ID=@"WMShopDetailCellThree";
            WMShopDetailCellThree *cell=[tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell=[[WMShopDetailCellThree alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            
            NSString *title= @"";
            NSArray *imgArr;
            if (indexPath.row == 0) {
                title= NSLocalizedString(@"商家资质", @"JHShopDetailVC");
                imgArr = self.shop.verify;
            }else{
                title= NSLocalizedString(@"商家实景", @"JHShopDetailVC");
                imgArr = self.shop.album;
            }
            
            [cell reloadCellWith:title imgArr:imgArr];
            return cell;

        }else{
            static NSString *ID=@"WMShopDetailCellTwo";
            WMShopDetailCellTwo *cell=[tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell=[[WMShopDetailCellTwo alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            NSDictionary *dic = self.shop.huodong[indexPath.row];
            [cell reloadCellWithDic:dic];
            return cell;
        }
    }else {
        static NSString *ID=@"WMShopDetailCellThree";
        WMShopDetailCellThree *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[WMShopDetailCellThree alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.superVC = self.superVC;
        }
        
        NSString *title= @"";
        NSArray *imgArr;
        if (indexPath.row == 0) {
            title= NSLocalizedString(@"商家资质", @"JHShopDetailVC");
            imgArr = self.shop.verify;
        }else{
            title= NSLocalizedString(@"商家实景", @"JHShopDetailVC");
            imgArr = self.shop.album;
        }
        
        [cell reloadCellWith:title imgArr:imgArr];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){
        if (self.shop.huodong.count == 0) {
            return 120;
        }else{
            return 45;
        }
    }else {
        return 120;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    // 通过最后一个 Footer 来补高度
//    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
//        return [self automaticHeightForTableView:tableView];
//    }
//    return 0.0001;
    return CGFLOAT_MIN;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor yellowColor];
//    return view;
//}

#pragma mark ====== Functions =======

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self.superVC callWithPhone:self.shop.phone];
                break;
            case 1:
            {
                JHShowShopLocationVC *locationVC = [[JHShowShopLocationVC alloc]init];
                locationVC.lat = self.shop.lat;
                locationVC.lng = self.shop.lng;
                locationVC.shopName = self.shop.title;
                locationVC.title = @"";
                [self.superVC.navigationController pushViewController:locationVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

-(void)getData{
    if (self.shop) {
        return;
    }
    SHOW_HUD_INVIEW(self.superVC.view)
    [WMShopModel getShopDetailInfoWith:self.shop_id block:^(WMShopModel* model, NSString *msg) {
        HIDE_HUD_FOR_VIEW(self.superVC.view);
        if (model) {
            self.shop = model;
            [self.tableView reloadData];
        }else{
            [self.superVC showToastAlertMessageWithTitle:msg];
        }
    }];
}

// 通知的方法
-(void)tableViewScrollsToTop{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

//// 计算tableView需要补齐的高度
//- (CGFloat)automaticHeightForTableView:(UITableView *)tableView{
//    
//    CGFloat height = tableView.contentSize.height;
//    
//    if (height >= tableView.frame.size.height) {
//        return 0.0001;
//    }
//    
//    return tableView.frame.size.height - height;
//}


@end
