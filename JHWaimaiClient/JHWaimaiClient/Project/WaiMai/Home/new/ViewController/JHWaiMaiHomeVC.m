
//****************************************
#import "JHWaiMaiHomeVC.h"

#import "XHMapKitHeader.h"
#import "JHHomeHeaderView.h"
#import "JHXuanTingView.h"
#import "JHHomeTitleCell.h"
#import "JHHomeShopShaiXuanCell.h"
#import "YFWMFilterView.h"
#import "JHHomeADImageCell.h"
#import "JHWaimaiHomeModel.h"
#import "AppDelegate.h"
#import "JHHomeShopCell.h"
#import "JHAddressMainVC.h"
#import "JHHomeDanmuView.h"
#import "JHHomeEmptyFoot.h"
#import "JHSkyHongBaoVC.h"
#import "ZQAppVersionTool.h"
#import "AppDelegate.h"
#import "JHJumpRouteModel.h"
#import "JHFastLoginVC.h"
#import "JHADWebVC.h"

@interface JHWaiMaiHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *homeTB;
@property(nonatomic,assign)NSUInteger page;
@property(nonatomic,strong)JHHomeHeaderView *headerV; //自定义表头
@property(nonatomic,strong)JHXuanTingView *xuanTingV; //上拉时显示的搜索和分类view
@property(nonatomic,strong)XHImageView *cartIV;      //购物车图片,按钮
@property(nonatomic,assign)BOOL cartIV_isAnimation;
@property(nonatomic,strong)JHHomeDanmuView *danmuV;   //弹幕
//
@property(nonatomic,strong)JHWaimaiHomeModel *waimaiHomeModel;
@property(nonatomic,strong)JHWaimaiHomeShopListAndHongbao *waimaiShopListAndHongbao;
@property(nonatomic,strong)NSArray *moduleDataSource;
@property(nonatomic,strong)NSMutableArray *shopDataSource;
@property(nonatomic,strong)NSMutableDictionary *filterDic;
@property(nonatomic,strong)JHHomeEmptyFoot *footV;
@property(nonatomic,assign)BOOL is_shaixuan;
@property(nonatomic,strong)UIView *refreshV;
@property(nonatomic,strong)NSMutableDictionary *heightIndexPath;
@property(nonatomic,strong)CALayer *bglayer;
@property(nonatomic,assign)BOOL firstLoad;
@property(nonatomic,strong)JHSkyHongBaoVC *hongbaoVC;
@property(nonatomic,strong)JHFastLoginVC *fastLoginVC;
@end

@implementation JHWaiMaiHomeVC

- (void)viewDidLoad{
    [super viewDidLoad];
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.waimaiHomeModel = app_delegate.homeConfig;
    // 赋值默认值,防止进入首页后table的cell高度出现错乱
    if (_waimaiHomeModel == nil) {
        self.waimaiHomeModel = [JHWaimaiHomeModel new];
    }
    [self.view addSubview:self.homeTB];
    [self addHeader_xuantingView];
    [self.view addSubview:self.refreshV];
    self.heightIndexPath = @{}.mutableCopy;
    self.firstLoad = YES;
    //
    [self filterDic];
    self.shopDataSource = @[].mutableCopy;
    //获取启动广告数据
    [[JHConfigurationTool shareJHConfigurationTool] getLaunchAds];
    //获取位置
    [self getLocation];
    [self cartIV];
    //获取到新地址
    [NoticeCenter addObserver:self
                     selector:@selector(getNoti_ChooseNewAddr:)
                         name:ChooseNewAddress_Notification
                       object:nil];
    //有新的链接
    [NoticeCenter addObserver:self
                     selector:@selector(jumpRouteWithLink:)
                         name:KNotification_Home_newLink
                       object:nil];
    //新的搜索界面
    [NoticeCenter addObserver:self
                     selector:@selector(gotoSearch:)
                         name:KNotification_Home_gotoSearch
                       object:nil];
    //筛选条件发生改变
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shaixuanChanged:)
                                                 name:KNotification_Home_shaixuanChanged
                                               object:nil];
    //通知弹出平台红包
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePlatFormHongbao:)
                                                 name:K_show_platform_hongbao object:nil];
    //
    [self dataHaveLoadedOrNot];
   
}

- (void)dataHaveLoadedOrNot{
    if (self.firstLoad == YES && self.waimaiHomeModel.theme.count > 0) {
        //更改表的背景
        [self changeBackground];
        [self loadData];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setCartNum];
    if (_shopDataSource.count) {
        [_homeTB reloadData];
    }
    [self version];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (JHUserModel.shareJHUserModel.hongbaoDic.count > 0) {
            [self showHongBaoWith:JHUserModel.shareJHUserModel.hongbaoDic];
            JHUserModel.shareJHUserModel.hongbaoDic = nil;
        }else{
            NSString *notiLink = JHUserModel.shareJHUserModel.notiLink;
            if (notiLink.length && [notiLink hasPrefix:@"http"]) {
                [self.navigationController pushViewController:[JHJumpRouteModel jumpWithLink:notiLink] animated:YES];
            }
            JHUserModel.shareJHUserModel.notiLink = @"";
        }
    });
}
-(void)version{
    if (![JHUserModel shareJHUserModel].isNotUpdate) {
        [ZQAppVersionTool postToSureThatIsNeedUpgradeVersion:@"magic/appver"];
    }
}
- (void)getHomeConfig{
    __weak typeof(self)ws = self;
    if (self.firstLoad == YES && self.waimaiHomeModel.theme.count > 0) {
        self.firstLoad = NO;
    }else{
        [HttpTool postWithAPI:@"client/waimai/index/index" withParams:@{}
                      success:^(id json) {
                          if (ERROR_O) {
                              ws.waimaiHomeModel.theme = json[@"data"][@"theme"];
                              [ws.waimaiHomeModel handleHomeConfig];
                              [JHConfigurationTool shareJHConfigurationTool].city_id = json[@"data"][@"city_id"];
                              [[JHConfigurationTool shareJHConfigurationTool] saveConfiguration];
                              [JHUserModel shareJHUserModel].shopHuodongType = ws.waimaiHomeModel.shopHuodongType;
                              //更改表的背景
                              [ws changeBackground];
                              [ws clearFenLeiTitle];
                              [ws addHeader_xuantingView];
                              _filterDic = nil;
                              [ws loadData];
                          }else{
                              [ws showToastAlertMessageWithTitle:json[@"message"]];
                          }
                      } failure:^(NSError *error) {
                      }];
    }
}
- (void)addHeader_xuantingView{
    if (_xuanTingV) {
        [_xuanTingV removeFromSuperview];
        _xuanTingV = nil;
    }
    self.homeTB.tableHeaderView = self.headerV;
    if ([JHConfigurationTool shareJHConfigurationTool].lastCommunity.length) {
        [NoticeCenter postNotificationName:ChooseNewAddress_only_show object:nil];
    }
    [self.view addSubview:self.xuanTingV];
}
- (void)clearFenLeiTitle{
    JHHomeShopShaiXuanCell *cell = [_homeTB dequeueReusableCellWithIdentifier:@"JHHomeShopShaiXuanCell"];
    if (cell) {
        cell = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - 表的代理和数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _waimaiHomeModel.vcNameArr.count;
    }else if (section == 1) {
        return 1;
    }else{
        return _shopDataSource.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = [self.heightIndexPath objectForKey:indexPath];
    if(height){
        return height.floatValue;
    }else{
        return 110;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSUInteger row = indexPath.row;
        NSArray<NSString *> *vcName = _waimaiHomeModel.vcNameArr;
        NSDictionary *dataDic = [_waimaiHomeModel getCurrentDataDic:row];
        Class cellClass =NSClassFromString(vcName[row]);
        NSString *cellID = [NSString stringWithFormat:@"homeCell_%@",vcName[row]];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil){
            cell = [[cellClass alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
        }
        [cell setValue:dataDic forKey:@"dataDic"];
        return cell;
    }else if (indexPath.section == 1){
        JHHomeShopShaiXuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHHomeShopShaiXuanCell"];
        if (cell == nil) {
            cell = [[JHHomeShopShaiXuanCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:@"JHHomeShopShaiXuanCell"];
            cell.shaiXuanV.filterView.targetVC = self;
        }
        return cell;
    }else{
        //店铺
        JHHomeShopCell *cell = [_homeTB dequeueReusableCellWithIdentifier:@"JHHomeShopCellID"];
        if (cell == nil) {
            cell = [[JHHomeShopCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                         reuseIdentifier:@"JHHomeShopCellID"];
        }
        cell.dataModel = _shopDataSource[indexPath.row];
        [cell.huodongCountBtn addTarget:self action:@selector(clickCellHuodongBtn:event:)
                       forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightIndexPath setObject:height forKey:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //跳转到商家
        JHWaimaiHomeShopModel *shopModel = _shopDataSource[indexPath.row];
        JHBaseVC* vc = [NSClassFromString(@"JHWaiMaiShopDetailVC") new];
        [vc setValue:shopModel.shop_id forKey:@"shop_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 滑动事件
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    __weak typeof(self)ws = self;
    if (decelerate == NO) {
        _cartIV_isAnimation = YES;
        [UIView animateWithDuration:0.5 delay:0.5 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            ws.cartIV.x = WIDTH-60;
            ws.cartIV.alpha = 1;
        } completion:^(BOOL finished) {
            ws.cartIV_isAnimation = NO;
        }];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    __weak typeof(self)ws = self;
    if (_cartIV_isAnimation == NO) {
        _cartIV_isAnimation = YES;
        [UIView animateWithDuration:0.5 delay:0.5 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            ws.cartIV.x = WIDTH-60;
            ws.cartIV.alpha = 1;
        } completion:^(BOOL finished) {
            ws.cartIV_isAnimation = NO;
        }];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    __weak typeof(self)ws = self;
    if (_cartIV_isAnimation == NO) {
        _cartIV_isAnimation = YES;
        [UIView animateWithDuration:0.5 animations:^{
            ws.cartIV.x = WIDTH-25;
            ws.cartIV.alpha = 0.2;
        } completion:^(BOOL finished) {
            ws.cartIV_isAnimation = NO;
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_y = scrollView.contentOffset.y;
    [_headerV changeStatusWithOffset_y:offset_y];
    //检测是否需要筛选view悬停
    CGPoint statusBottomPoint = [self.view convertPoint:CGPointMake(0, STATUS_HEIGHT) toView:_homeTB];
    NSIndexPath *indexPath_statusBottom = [_homeTB indexPathForRowAtPoint:statusBottomPoint];
    //indexpath.section >=1 时 展示分类
    CGRect cell_1_0_rect = [_homeTB rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    BOOL showFenlei = NO;
    if (offset_y > cell_1_0_rect.origin.y - STATUS_HEIGHT ) {
        showFenlei = YES;
    }
    [_xuanTingV changeStatusWithOffset_y:offset_y showFenLei:(indexPath_statusBottom.section >= 1 || showFenlei)];
    
    //滑动时,有条件的还原添加的footview
    if (_homeTB.tableFooterView) {
        [self resetHomeTB_sectionHeight];
    }
}
#pragma mark - 加载tableview
- (UITableView *)homeTB{
    if (_homeTB == nil) {
        _homeTB = ({
            CGFloat height_S = [UIScreen mainScreen].bounds.size.height;
            UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, height_S - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
            table.backgroundColor = [UIColor whiteColor];
            table.showsVerticalScrollIndicator = NO;
            table.delegate = self;
            table.dataSource = self;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.rowHeight = UITableViewAutomaticDimension;
            table.sectionHeaderHeight = 0.01;
            
            __weak typeof(self) ws =self;
            //--下拉加载
            [table bindHeadRefreshHandler:^{
                ws.page = 1;
                ws.filterDic[@"page"] = @(1);
                [ws loadData];
            }];
            //--上拉加载
            [table bindFootRefreshHandler:^{
                ws.page++;
                ws.filterDic[@"page"] = @(ws.page);
                [ws loadData];
            }];
            //---
            table;
        });
    }
    return _homeTB;
}
#pragma mark - 自定义表头
- (UIView *)headerV{
    CGFloat header_h = _waimaiHomeModel.header_height;
    _headerV = [[JHHomeHeaderView alloc] initWithFrame:FRAME(0,0,WIDTH,header_h) type:_waimaiHomeModel.type];
    [_headerV addrL_addTarget:self action:@selector(toChooseAddr)];
    [_headerV setDataDic:(NSDictionary *)_waimaiHomeModel.theme[1]];
    return _headerV;
}
#pragma mark - 悬停view
- (JHXuanTingView *)xuanTingV{
    if (_xuanTingV == nil) {
        _xuanTingV = [[JHXuanTingView alloc] initWithFrame:FRAME(0, 0, WIDTH, NAVI_HEIGHT+44)];
        if (_waimaiHomeModel.type != 2) {
            _xuanTingV.xuan_ting_type = E_XUANTING_TYPE_ONE;
        }else{
            _xuanTingV.xuan_ting_type = E_XUANTING_TYPE_TWO;
        }
        [_xuanTingV setDataDic:(NSDictionary *)_waimaiHomeModel.theme[1]];
        [_xuanTingV addrL_addTarget:self action:@selector(toChooseAddr)];
        _xuanTingV.hidden = YES;
    }
    return _xuanTingV;
}
#pragma mark - 获取位置
- (void)getLocation{
    [[XHPlaceTool sharePlaceTool] getCurrentPlaceWithSuccess:^(XHLocationInfo *model) {
        [self aroundSearch];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - 周边搜索
-(void)aroundSearch{
    __weak typeof(self)weakself = self;
    [[XHPlaceTool sharePlaceTool] aroundSearchWithSuccess:^(NSArray<XHLocationInfo *> *pois) {
        if (pois.count) {
            XHLocationInfo *model = pois[0];
            [JHConfigurationTool shareJHConfigurationTool].lastCommunity = model.name;
            [JHConfigurationTool shareJHConfigurationTool].cityCode = model.cityCode;
            [JHConfigurationTool shareJHConfigurationTool].lat = model.coordinate.latitude;
            [JHConfigurationTool shareJHConfigurationTool].lng = model.coordinate.longitude;
            [JHConfigurationTool shareJHConfigurationTool].cityName = model.city;
            [XHMapKitManager shareManager].currentCity = model.city;
        }else{
            [JHConfigurationTool shareJHConfigurationTool].lastCommunity = NSLocalizedString(@"选择位置", nil);
        }
        //更改标题&&刷新
        [weakself updateLocationTitle_and_refresh];
        
    } failure:^(NSString *error) {
        [JHConfigurationTool shareJHConfigurationTool].lastCommunity = NSLocalizedString(@"选择位置", nil);
        //更改标题&&刷新
        [weakself updateLocationTitle_and_refresh];
    }];
}
#pragma mark - 请求数据
- (void)loadData{
    SHOW_HUD
    CGFloat lat = [JHConfigurationTool shareJHConfigurationTool].lat;
    CGFloat lng = [JHConfigurationTool shareJHConfigurationTool].lng;
    self.filterDic[@"lat"] = @(lat).stringValue;
    self.filterDic[@"lng"] = @(lng).stringValue;
    //
    __weak typeof(self)ws = self;
    [HttpTool postWithAPI:@"client/waimai/shop/shoplist"
               withParams:_filterDic
                  success:^(id json) {
                      if (ERROR_O) {
                          NSLog(@"client/waimai/shop/shoplist----%@",json);
                          if (self.page == 1) {
                              [ws.shopDataSource removeAllObjects];
                          }
                          ws.waimaiShopListAndHongbao = [JHWaimaiHomeShopListAndHongbao mj_objectWithKeyValues:json[@"data"]];
                          [ws.shopDataSource addObjectsFromArray:ws.waimaiShopListAndHongbao.items];
                          if (ws.waimaiHomeModel.showDanmu) {
                              [ws showDanmu];
                          }
                          //点击分类时,修复显示高度, 或者商家数量为0
                          if (ws.shopDataSource.count == 0 || ws.is_shaixuan) {
                              [self fixHomeTB_sectionHeight];
                          }
                          //刷新
                          [ws.homeTB reloadData];
                          ws.is_shaixuan = NO;
                          //
                          if (ws.waimaiShopListAndHongbao.items.count == 0) {
                              [self showToastAlertMessageWithTitle:NSLocalizedString(@"没有更多数据", "")];
                          }
                          //天降红包
                          [self showHongBaoWith:ws.waimaiShopListAndHongbao.hongbao];
                      }
                      [ws.homeTB endRefresh];
                      HIDE_HUD
               } failure:^(NSError *error) {
                   [ws.homeTB endRefresh];
                   HIDE_HUD
               }];
}

- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    if (_homeTB.contentSize.height > _homeTB.bounds.size.height) {
        yOffset = _homeTB.contentSize.height - _homeTB.bounds.size.height;
    }
    [_homeTB setContentOffset:CGPointMake(0, yOffset) animated:YES];
}


- (void)clickFenlei:(UIButton *)sender{
    NSLog(@"点击了分类按钮");
    __weak typeof(self)ws = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = NO;
        [self fixHomeTB_sectionHeight];
        //
        //检测是否需要筛选view悬停
        CGPoint statusBottomPoint = [self.view convertPoint:CGPointMake(0, STATUS_HEIGHT) toView:ws.homeTB];
        NSIndexPath *indexPath_statusBottom = [ws.homeTB indexPathForRowAtPoint:statusBottomPoint];
        if (indexPath_statusBottom.section == 0) {
            //滚动到指定位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            CGRect cell_1_0_rect = [ws.homeTB rectForRowAtIndexPath:indexPath];
            CGFloat offset_y = cell_1_0_rect.origin.y - STATUS_HEIGHT;
            [ws.homeTB setContentOffset:CGPointMake(0, offset_y+5) animated:YES];
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                YFTypeBtn *clickedBtn = [_xuanTingV.shaiXuanV.filterView viewWithTag:sender.tag];
                [_xuanTingV.shaiXuanV.filterView clickTable:clickedBtn];
                ws.view.userInteractionEnabled = YES;
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                YFTypeBtn *clickedBtn = [_xuanTingV.shaiXuanV.filterView viewWithTag:sender.tag];
                [_xuanTingV.shaiXuanV.filterView clickTable:clickedBtn];
                ws.view.userInteractionEnabled = YES;
            });
        }
    });
}
- (XHImageView *)cartIV{
    if (_cartIV == nil) {
        _cartIV = [XHImageView new];
        [self.view addSubview:_cartIV];
        [_cartIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.width.height.offset = 50;
            make.bottom.offset = -20;;
        }];
        _cartIV.image = IMAGE(@"home_btn_cart");
        _cartIV.clipsToBounds = NO;
        [_cartIV addTarget:self action:@selector(clickCartIV)];
    }
    return _cartIV;
}
- (void)setCartNum{
    [[WMShopDBModel shareWMShopDBModel] getShopCartDataFormDB:^(NSArray * arr) {
        NSUInteger total_num = 0;
        for (WMShopDBModel *shop_db in arr) {
            total_num += (shop_db.shop_choosedCount);
        }
        self.cartIV.badgeNum = total_num;
    }];
}

#pragma mark - 点击了购物车
- (void)clickCartIV{
    NSLog(@"点击了购车");
    [self pushToNextVcWithVcName:@"JHWaiMaiShopCartVC"];
}
#pragma mark - 接收到选择新地址的通知
- (void)getNoti_ChooseNewAddr:(NSNotification *)noti{
    self.page = 1;
    _filterDic[@"page"] = @(1);
    [self getHomeConfig];
}
#pragma mark - 进入地址选择界面
- (void)toChooseAddr{
    [self presentToNextVcWithVcName:@"JHAddressMainVC"];
}
#pragma mark - 去搜索界面
- (void)gotoSearch:(NSNotification *)noti{
    NSString *searchStr = (NSString *)noti.object;
    Class searchClass = NSClassFromString(@"JHWMHomeSearchVC");
    UIViewController *searchVC = (UIViewController *)[[searchClass alloc] init];
    [searchVC setValue:searchStr forKey:@"searchStr"];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - 路由跳转
- (void)jumpRouteWithLink:(NSNotification *)noti{
    NSString *link = (NSString *)noti.object;
    __weak typeof(self)ws = self;
    [self pushToNextByRoute:link vc:ws];
}
#pragma mark - 筛选条件发生改变,更新title
- (void)shaixuanChanged:(NSNotification *)noti{
    _is_shaixuan = YES;
    //--重新添加上来加载
    __weak typeof(self)ws = self;
    [_homeTB bindFootRefreshHandler:^{
        ws.page++;
        ws.filterDic[@"page"] = @(ws.page);
        [ws loadData];
    }];
    //---
    self.page = 1;
    NSDictionary *tem_filterDic = (NSDictionary *)noti.object;
    [_filterDic setValuesForKeysWithDictionary:tem_filterDic];
    //
    [self loadData];
}
#pragma mark - 处理平台红包
- (void)handlePlatFormHongbao:(NSNotification *)noti{
    [self showHongBaoWith:noti.object];
}

#pragma mark - 弹出天降红包
-(void)showHongBaoWith:(NSDictionary *)hongbaoDic{

    if ([hongbaoDic[@"items"] count] == 0) {
        return;
    }
    __weak typeof(self)ws = self;
    [self.hongbaoVC dismissViewControllerAnimated:YES completion:nil];
    // 启动的时候广告页切换动画0.75后根视图切换,在之前present会导致白屏问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *type = hongbaoDic[@"type"];
        NSString *link_url = hongbaoDic[@"link_url"];
        
        self.hongbaoVC = [JHSkyHongBaoVC new];
        self.hongbaoVC.hongBaoDic = hongbaoDic;
        self.hongbaoVC.getBlock = ^{
            if ([type isEqualToString:@"1"]) {
                //天降红包

            }else if ([type isEqualToString:@"2"]){
                //新人红包,跳转到快速登录界面
                UIViewController *fastLoginVC = [NSClassFromString(@"JHFastLoginVC") new];
                [ws.navigationController pushViewController:fastLoginVC animated:YES];
            }else if ([type isEqualToString:@"3"]){
                //平台红包,此处3只是为了区分其他,实际上平台红包对应多种类型
                JHADWebVC *web = [JHADWebVC new];
                web.url = link_url;
                [ws.tabBarController.selectedViewController pushViewController:web animated:YES];
            }
        };
        [[self topViewController] presentViewController:self.hongbaoVC animated:YES completion:nil];
    });
}

-(NSMutableDictionary *)filterDic{
    if (_filterDic==nil) {
        CGFloat lat = [JHConfigurationTool shareJHConfigurationTool].lat;
        CGFloat lng = [JHConfigurationTool shareJHConfigurationTool].lng;
        _filterDic=[[NSMutableDictionary alloc] init];
        _filterDic[@"cate_id"] = @"0";
        _filterDic[@"order"] = @"";
        _filterDic[@"pei_filter"] = @"";
        _filterDic[@"youhui_filter"] = @"";
        _filterDic[@"feature_filter"] = @"";
        _filterDic[@"page"] = @(1);
        _filterDic[@"lat"] = @(lat).stringValue;
        _filterDic[@"lng"] = @(lng).stringValue;
        _filterDic[@"index"] = @(1);
    }
    return _filterDic;
}

#pragma mark - tableview 内容高度修改,在店铺数据较少时也可滚动到指定位置
- (void)fixHomeTB_sectionHeight{
    _footV = [[JHHomeEmptyFoot alloc] initWithFrame:FRAME(0,0, WIDTH, HEIGHT-NAVI_HEIGHT-TABBAR_HEIGHT-44) showEmpty:(_shopDataSource.count == 0)];
    _homeTB.tableFooterView = _footV;
    if (_shopDataSource.count == 0) {
        [_homeTB removeFootRefresh];
    }
}
    
#pragma mark - 还原真实的高度
- (void)resetHomeTB_sectionHeight{
    if (_shopDataSource.count > 0) {
        _footV = nil;
        _homeTB.tableFooterView = nil;
        
        //--重新添加上来加载
        __weak typeof(self)ws = self;
        [_homeTB bindFootRefreshHandler:^{
            ws.page++;
            ws.filterDic[@"page"] = @(ws.page);
            [ws loadData];
        }];
    }
}

#pragma mark - 展示弹幕
- (void)showDanmu{
    if (_danmuV == nil) {
        _danmuV = [[JHHomeDanmuView alloc] initWithFrame:FRAME(20, NAVI_HEIGHT + 80,194, 32) inView:self.view];
        [_danmuV getOrders];
    }
}
#pragma mark - 点击了cell内的展示活动按钮
- (void)clickCellHuodongBtn:(UIButton *)sender event:(UIEvent *)event{
    UITouch *onetouch = [event.allTouches anyObject];
    CGPoint touch_p = [onetouch locationInView:_homeTB];
    NSIndexPath *indexPath = [_homeTB indexPathForRowAtPoint:touch_p];
    //获取row
    JHWaimaiHomeShopModel *shopModel = _shopDataSource[indexPath.row];
    shopModel.showMoreHuodong = !shopModel.showMoreHuodong;
    //刷新cell
    [_homeTB reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark - 更改地址标题为选择位置,通知刷新界面
- (void)updateLocationTitle_and_refresh{
    [NoticeCenter postNotificationName:ChooseNewAddress_Notification object:nil];
}

#pragma mark - 更改背景色
- (void)changeBackground{
    //获取配置
    NSDictionary *bgDic = [_waimaiHomeModel.theme firstObject];
    //背景颜色,填充图片
    NSString *bgImg = bgDic[@"background"];
    NSString *bgColor = bgDic[@"background_color"];
    if (bgColor.length) {
        _homeTB.backgroundColor = HEX(bgColor, 1.0);
    }
    //
    UIImageView *bgImgv = [self.view viewWithTag:2000];
    if (bgImgv == nil) {
        bgImgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgImgv.tag = 2000;
        [self.view addSubview:bgImgv];
    }
    
    [self.bglayer removeFromSuperlayer];
    self.bglayer = nil;
    
    __weak typeof(self)ws = self;
    [bgImgv sd_setImageWithURL:[NSURL URLWithString:bgImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error == nil) {
            [ws addBgImg:image];
        }
    }];
}
- (void)addBgImg:(UIImage *)bgImg{
    CGSize imgSize = bgImg.size;
    CGFloat bg_h = imgSize.height*WIDTH/imgSize.width;

    
    self.bglayer = [CALayer layer];
    self.bglayer.frame = FRAME(0, 0, WIDTH, bg_h);
    self.bglayer.contents = (id)(bgImg.CGImage);
    self.bglayer.zPosition = -0.01;
    [_homeTB.layer addSublayer:self.bglayer];
    
    //删除多余的view
    UIView *bgImgV = [self.view viewWithTag:2000];
    [bgImgV removeFromSuperview];
    bgImgV = nil;
}

- (void)dealloc{
    NSLog(@"首页释放了");
}

@end

