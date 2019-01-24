//
//  JHAddrSearchBaseVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/1/8.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHAddrSearchBaseVC.h"

#import "XHMapKitHeader.h"
#import "GaoDe_Convert_BaiDu.h"

@interface JHAddrSearchBaseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;
@end

@implementation JHAddrSearchBaseVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.page = 1;
    [self setUpView];
    
}

-(void)setUpView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 50;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor=BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    if (![XHMapKitManager shareManager].is_International) {
        
        __weak typeof(self) weakSelf=self;
        //--下拉加载
        [tableView bindHeadRefreshHandler:^{
            weakSelf.page=1;
            [weakSelf getData];
        }];
        //--上拉加载
        [tableView bindFootRefreshHandler:^{
            weakSelf.page++;
            [weakSelf getData];
        }];
    }
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 40, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.textLabel.text = [self.dataSource[indexPath.row] name];
    cell.textLabel.font = FONT(14);
    cell.textLabel.textColor = HEX(@"333333", 1);
    cell.detailTextLabel.text = [self.dataSource[indexPath.row] street];
    cell.detailTextLabel.font = FONT(12);
    cell.detailTextLabel.textColor = HEX(@"999999", 1);
    cell.imageView.image = [UIImage imageNamed:@"mall_my_icon_location"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前的row
    XHLocationInfo *lastPOI = self.dataSource[indexPath.row];
    [JHConfigurationTool shareJHConfigurationTool].cityName = lastPOI.city;
    [JHConfigurationTool shareJHConfigurationTool].cityCode = lastPOI.cityCode;
    double lat = 0;
    double lng = 0;
    [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:lastPOI.coordinate.latitude
                                                 WithGD_lon:lastPOI.coordinate.longitude
                                                 WithBD_lat:&lat
                                                 WithBD_lon:&lng];
    
    [JHConfigurationTool shareJHConfigurationTool].lat = lat;
    [JHConfigurationTool shareJHConfigurationTool].lng = lng;
    [JHConfigurationTool shareJHConfigurationTool].lastCommunity = [lastPOI name];
    // 保存地址选择
    [[JHConfigurationTool shareJHConfigurationTool] saveConfiguration];
    [NoticeCenter postNotificationName:ChooseNewAddress_Notification object:nil];
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ====== Functions =======
// 刷新数据
-(void)reloadData{
    self.page = 1;
    [self getData];
}

-(void)getData{
    
    SHOW_HUD
    NSString *type = @"";
    switch (self.index) {
        case 0:
            type = NSLocalizedString(@"小区|学校|写字楼|医院|商圈|超市|百货商场|办公楼|街区|", nil);// 
            break;
        case 1:
            type =  NSLocalizedString(@"商务写字楼|商务写字楼", NSStringFromClass([self class]));
            break;
        case 2:
            type =  NSLocalizedString(@"商务住宅|住宅区|住宅小区", NSStringFromClass([self class]));
            break;
        case 3:
            type = NSLocalizedString(@"学校", NSStringFromClass([self class]));
            break;
        default:
            break;
    }
    [[XHPlaceTool sharePlaceTool] keywordsSearchWithKeyString:@"" page:self.page type:type city:self.city success:^(NSArray<XHLocationInfo *> *pois) {
        HIDE_HUD
        [self.tableView endRefresh];
        if (self.page == 1) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:pois];
        }else{
            [self.dataSource addObjectsFromArray:pois];
        }
        [self.tableView reloadData];
        
    } failure:^(NSString *error) {
        HIDE_HUD
        [self.tableView endRefresh];
        [self.superVC showToastAlertMessageWithTitle:error.description];
    }];
}

#pragma mark ====== 懒加载 =======
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end
