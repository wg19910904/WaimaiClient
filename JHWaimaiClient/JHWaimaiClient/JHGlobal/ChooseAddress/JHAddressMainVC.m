//
//  JHAddressMainVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAddressMainVC.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JHConfigurationTool.h"
#import "JHChooseCityVC.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHMyaddressCell.h"
#import "YFTypeBtn.h"
#import "JHWaimaiMineViewModel.h"
#import "XHMapKitHeader.h"

@interface JHAddressMainVC ()<UITableViewDelegate,UITableViewDataSource,
                              UITextFieldDelegate,MAMapViewDelegate,AMapSearchDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *infoArr;
@property(nonatomic,copy)NSString *temp_city_id;
@end

@implementation JHAddressMainVC
{

    UIButton *backBtn_custom;
    UILabel *title_;
    //搜索框
    UITextField *_searchField;
    //显示当前城市按钮
    YFTypeBtn *cityBtn;
    //statusLabel
    UILabel *_statusLabel;
    //保存后台请求的城市列表
    NSDictionary *_cityDic;
    //当前定位或者选择的城市
    NSString *currentCity;
    //周边搜索和关键字搜索
    AMapLocationManager *locationManager;//一次性定位
    AMapSearchAPI * _search;//搜索需要的
    //周边搜索回调的地址数组
    NSArray *addressArray;
    //关键字搜索的数组
    NSArray *keyAddressArray;
    BOOL isKeySearch;
    UIView *backView;
    UIButton *rightBtn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _infoArr = @[].mutableCopy;
    self.navigationItem.title = NSLocalizedString(@"选择地址", @"JHAddressMainVC");
    [self addLeftBtnWith:@"icon_close" sel:@selector(clickBackBtn)];
    self.temp_city_id = [JHConfigurationTool shareJHConfigurationTool].city_id;
    //添加右上角地址管理
    [self addAddressManager];
    //处理当前城
    [self handleCurrentCity];

    //添加搜索框
    [self createSearchField];
    //创建表视图
    [self createMainTableView];
    //后台请求城市列表
    [self performSelectorInBackground:@selector(getCities) withObject:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([JHUserModel shareJHUserModel].token && !IsTuanGou) {
        [self getMyAddress];
    }
}
//添加地址管理
- (void)addAddressManager{
    UIButton *addrManagerBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 64, 44)];
    [addrManagerBtn setTitle:NSLocalizedString(@"地址管理", nil) forState:0];
    [addrManagerBtn setTitleColor:HEX(@"333333", 1.0) forState:0];
    addrManagerBtn.titleLabel.font = FONT(16);
    addrManagerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addrManagerBtn addTarget:self action:@selector(clickAddrManager:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addrManagerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)getMyAddress{
    SHOW_HUD
    [JHWaimaiMineViewModel postToGetMyAddressWithDic:@{} is_paotui:NO  block:^(JHWaimaiMineAddressListModel * model, NSString *error) {
        HIDE_HUD
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
            [_infoArr removeAllObjects];
            [_infoArr addObjectsFromArray:model.items];
            [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];

}
#pragma mark - 处理当前的城市
- (void)handleCurrentCity
{
    currentCity = [JHConfigurationTool shareJHConfigurationTool].cityName;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.temp_city_id.integerValue == 0 && IsHaveFenZhan) {
//        [self showToastAlertMessageWithTitle: NSLocalizedString(@"该地址所在城市暂未开通,请选择其他地址", NSStringFromClass([self class]))];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self clickHandSearch:cityBtn];
//        });
//        return;
//    }
    if (addressArray.count == 0) {
        [self creatSurrondSearch];
    }
}
#pragma mark - createSearchField
- (void)createSearchField
{
    //添加子控件
    if (!_searchField) {
       backView = [[UIView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, 44)];
        backView.backgroundColor = HEX(@"ffffff", 1.0);
        cityBtn = [[YFTypeBtn alloc]init];
        cityBtn.btnType = RightImage;
        cityBtn.imageMargin = 5;
        [cityBtn setFrame:CGRectMake(10 ,7, 55, 31)];
        [cityBtn addTarget:self action:@selector(clickHandSearch:) forControlEvents:UIControlEventTouchUpInside];
        [cityBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        cityBtn.titleLabel.font = FONT(11);
        [cityBtn setImage:IMAGE(@"arrow_city_white") forState:UIControlStateNormal];
        NSString *cityString = [JHConfigurationTool shareJHConfigurationTool].cityName;
        cityString = cityString ? cityString : NSLocalizedString(@"城市",nil);
        [cityBtn setTitle:cityString forState:(UIControlStateNormal)];
        cityBtn.titleLabel.numberOfLines = 0;
        [cityBtn.titleLabel sizeToFit];
        [backView addSubview:cityBtn];
        
        //
        rightBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH-45, 4, 40, 35)];
        [rightBtn setTitle:NSLocalizedString(@"取消", nil) forState:(UIControlStateNormal)];
        [rightBtn setTitleColor:HEX(@"333333", 1.0f) forState:(UIControlStateNormal)];
        rightBtn.titleLabel.font = FONT(15);
        [backView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(clickCancel) forControlEvents:(UIControlEventTouchUpInside)];
        rightBtn.alpha = 0.0;
        //
        
        _searchField = [[UITextField alloc] initWithFrame:FRAME(70, 6, WIDTH-80,32)];
        _searchField.layer.cornerRadius = 4;
        _searchField.layer.masksToBounds = YES;
        _searchField.backgroundColor = HEX(@"e6e6e6", 1.0f);
        _searchField.layer.borderColor = LINE_COLOR.CGColor;
        _searchField.layer.borderWidth = 0.7;
        _searchField.placeholder = NSLocalizedString(@"请输入位置名称", nil);
        _searchField.textColor = HEX(@"333333", 1.0);
        _searchField.font = FONT(16);
        _searchField.delegate = self;
        //添加左右按钮
        UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 40, 35)];
        leftIV.image = IMAGE(@"search");
        leftIV.contentMode = UIViewContentModeCenter;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.leftView = leftIV;

        [backView addSubview:_searchField];
        [self.view addSubview:backView];
        //检测文本框发生文本发生改变的通知
        [NoticeCenter addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:_searchField];
    }
}
-(void)clickCancel{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        _mainTableView.frame = FRAME(0, NAVI_HEIGHT + 44, WIDTH, HEIGHT - (NAVI_HEIGHT + 44));
        backView.y = NAVI_HEIGHT;
        _searchField.frame =FRAME(70, 6, WIDTH-80,35);
        backView.backgroundColor = HEX(@"ffffff", 1);
        rightBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [_mainTableView reloadData];
    }];
    
    isKeySearch = NO;
    _searchField.text = @"";
    if (addressArray.count>0) {
        _statusLabel.text = [(AMapPOI *)addressArray[0] name];
    }
}
//搜索框发生改变的时候调用的方法
-(void)textFieldTextDidChangeOneCI:(NSNotification *)not{
    //发起关键字搜索
    isKeySearch = YES;
    [XHMapKitManager shareManager].currentCity = [JHConfigurationTool shareJHConfigurationTool].cityName;
    [self keySearchWithkey:_searchField.text];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    __weak typeof(self)ws = self;
    //当是国际化客户时,进入google关键字搜索
    if ([XHMapKitManager shareManager].is_International == YES) {
        XHPlacePicker *placePick = [[XHPlacePicker alloc] initWithPlaceCallback:^(XHLocationInfo *place) {
            NSLog(@"%@",place);
            [JHConfigurationTool shareJHConfigurationTool].lat = place.coordinate.latitude;
            [JHConfigurationTool shareJHConfigurationTool].lng = place.coordinate.longitude;
            [JHConfigurationTool shareJHConfigurationTool].lastCommunity = [place name];
            // 保存地址选择
            [[JHConfigurationTool shareJHConfigurationTool] saveConfiguration];
            [NoticeCenter postNotificationName:ChooseNewAddress_Notification object:nil];
            [ws dismissViewControllerAnimated:YES completion:nil];
        }];
        [placePick startPlacePicker];
        textField.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            textField.userInteractionEnabled = YES;
        });
        return NO;
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        isKeySearch = YES;
        keyAddressArray = @[];
        [_mainTableView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            _mainTableView.frame = FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT);
            backView.y = STATUS_HEIGHT;
            _searchField.frame =FRAME(70, 6, WIDTH-130,32);
            backView.backgroundColor = HEX(@"FAFAFA", 1);
            rightBtn.alpha = 1;
        } completion:^(BOOL finished) {
           
            _statusLabel.text = NSLocalizedString(@"输入关键字搜索位置...",nil);
        }];
    }
    return YES;
}

#pragma mark - 点击导航栏左按钮
- (void)clickBackBtn
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 后台请求城市列表
- (void)getCities
{
    NSLog(@"开始执行后台请求城市");
    [HttpTool postWithAPI:@"client/data/city" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        _cityDic = json[@"data"][@"items"]; //返回的数据格式还需调整
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 点击手动选择
- (void)clickHandSearch:(UIButton *)sender
{
    NSLog(@"点击了切换城市");
    JHChooseCityVC *vc = [[JHChooseCityVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.cityDic = _cityDic;
    vc.currentCity = currentCity;
    vc.refreshCityBlock = ^(NSString *cityName,NSString *city_id){
    [cityBtn setTitle:cityName forState:UIControlStateNormal];
        currentCity = cityName;
        self.temp_city_id = city_id;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 创建表视图
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0,(NAVI_HEIGHT + 46), WIDTH, HEIGHT - (NAVI_HEIGHT + 45)) style:(UITableViewStyleGrouped)];
        _mainTableView.backgroundColor = BACK_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.separatorColor = LINE_COLOR;
        _mainTableView.separatorInset = UIEdgeInsetsZero;
        _mainTableView.layoutMargins = UIEdgeInsetsZero;
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isKeySearch) {
        return 2;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (isKeySearch) {
                if (addressArray.count > 0 || keyAddressArray.count >0) {
                    return isKeySearch?keyAddressArray.count:addressArray.count;
                }else{
                    return 0;
                }
            }else{
                return _infoArr.count;
                
            }
            
            break;
        default:
            if (addressArray.count > 0 || keyAddressArray.count >0) {
                
                if (MoreAddress) {
                    return isKeySearch ? keyAddressArray.count : (addressArray.count >= 5 ? 5 : addressArray.count);
                }else{
                    return isKeySearch ? keyAddressArray.count : addressArray.count;
                }
            }
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (([JHUserModel shareJHUserModel].token == nil && section == 1 )|| isKeySearch) {
        return CGFLOAT_MIN;
    }
    return 36;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (([JHUserModel shareJHUserModel].token == nil && section == 1 )|| isKeySearch) {
         return nil;
    }
    NSArray *titleArr = @[NSLocalizedString(@"当前定位位置", nil),
                         NSLocalizedString(@"我的收货地址", nil),
                         NSLocalizedString(@"附近地址", nil)];
    NSArray *imgArr = @[@"icon_location_now",@"icon_location_house",@"icon_location_point"];
    UIView *headV = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 36)];
    headV.backgroundColor =[UIColor whiteColor];
    //图像
    UIImageView *iv = [[UIImageView alloc] initWithFrame:FRAME(10, 10, 16, 16)];
    iv.image = IMAGE(imgArr[section]);
    [headV addSubview:iv];
    //标题
    UILabel *titleL = [[UILabel alloc]initWithFrame:FRAME(30, 0, WIDTH-50, 36)];
    titleL.backgroundColor = BACK_COLOR;
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.textColor = HEX(@"999999", 1);
    titleL.font = FONT(14);
    titleL.text = titleArr[section];
    [headV addSubview:titleL];
    return headV;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!isKeySearch && section == 2) {

        if (MoreAddress) {
            UIButton *btn = [UIButton new];
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(chooseMoreAddr) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *label = [UILabel new];
            [btn addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset=10;
                make.centerY.offset=0;
                make.height.offset=20;
            }];
            label.textColor = HEX(@"333333", 1);
            label.font = FONT(14);
            label.text = NSLocalizedString(@"更多地址 >", nil);
            return btn;
        }
        return nil;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!isKeySearch && section == 2) {
        return MoreAddress ? 45 : CGFLOAT_MIN;
    }else{
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (indexPath.section == 0  && !isKeySearch) {
        return 50;
     }else if(indexPath.section == 0  && isKeySearch){
         return CGFLOAT_MIN;
     }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            //添加子控件
            if (!_statusLabel) {
                _statusLabel = [[UILabel alloc] initWithFrame:FRAME(32, 0, WIDTH - 45, 50)];
                _statusLabel.textColor = HEX(@"333333", 1.0f);
                _statusLabel.font = FONT(16);
                _statusLabel.textAlignment = NSTextAlignmentLeft;
                _statusLabel.numberOfLines = 2;
                _statusLabel.text = NSLocalizedString(@"定位中...", nil);
                
            }
//            //添加下划线
            UIView *line = [[UIView alloc]init];
            if (isKeySearch) {
                cell.clipsToBounds = YES;
            line.frame = FRAME(12, 59, WIDTH-24, 1);
            }else{
            line.frame = FRAME(12, 49, WIDTH-24, 1);
            }
            line.backgroundColor = HEX(@"f5f5f5", 1);
            [cell addSubview:line];
            
            [cell addSubview:_statusLabel];
            YFTypeBtn *rightButton = [[YFTypeBtn alloc]initWithFrame:FRAME(WIDTH - 90, 0, 80, 50)];
            rightButton.btnType = LeftImage;
            rightButton.titleMargin = 8;
            [rightButton setImage:IMAGE(@"btn-position") forState:UIControlStateNormal];
            [rightButton setTitle:NSLocalizedString(@"重新定位",nil) forState:UIControlStateNormal];
            [rightButton setTitleColor:HEX(@"ff9000", 1.0) forState:UIControlStateNormal];
            rightButton.hidden = isKeySearch;
            rightButton.titleLabel.font = FONT(13);
            [rightButton addTarget:self action:@selector(creatSurrondSearch) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:rightButton];
            return cell;
        }
            break;
        case 1:
        {
            if (isKeySearch) {
                static NSString *str = @"cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
                }
                cell.textLabel.text = isKeySearch?[(XHLocationInfo *)keyAddressArray[indexPath.row] name]:[(XHLocationInfo *)addressArray[indexPath.row] name];
                cell.textLabel.font = isKeySearch?FONT(14):FONT(12);
                cell.textLabel.textColor = HEX(@"333333", 1);
                NSMutableAttributedString *hintStr = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
                NSRange range =[[hintStr string]rangeOfString:_searchField.text];
                [hintStr addAttribute:NSForegroundColorAttributeName value:HEX(@"2797FF", 1) range:range];
                cell.textLabel.attributedText = hintStr;
                
             
               cell.detailTextLabel.text = isKeySearch?[(XHLocationInfo *)keyAddressArray[indexPath.row] street]:[(XHLocationInfo *)addressArray[indexPath.row] street];
                    cell.detailTextLabel.font = FONT(12);
                    cell.detailTextLabel.textColor = HEX(@"999999", 1);
                
                UIView *line = [[UIView alloc] initWithFrame:FRAME(12, 59, WIDTH-24, 1)];
                 line.backgroundColor = HEX(@"f5f5f5", 1);
                [cell addSubview:line];
                
                return cell;

            }else{
                static NSString *str = @"Addcell";
                JHMyaddressCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
                if (!cell) {
                    cell = [[JHMyaddressCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
                }
                JHWaimaiMineAddressListDetailModel *model = _infoArr[indexPath.row];
                cell.add = model.addr;
                cell.name = [NSString stringWithFormat:@"%@    %@",model.contact,model.mobile];
                return cell;

            }
        }
            break;
        default:{
            
            static NSString *str = @"Addcell";
            JHMyaddressCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHMyaddressCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
            }
            cell.add = isKeySearch?[(XHLocationInfo *)keyAddressArray[indexPath.row] name]:[(XHLocationInfo *)addressArray[indexPath.row] name];
            cell.name = isKeySearch?[(XHLocationInfo *)keyAddressArray[indexPath.row] street]:[(XHLocationInfo *)addressArray[indexPath.row] street];
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    XHLocationInfo *lastPOI;
    if (section == 0 && row == 0) {
        if (!isKeySearch) {
            if (addressArray.count == 0) {//地位失败
                [self creatSurrondSearch];
                return;
            }
            //获取当前的row
            lastPOI = (XHLocationInfo *)addressArray[row];
            [self saveClickAddress:lastPOI];
        }
    }else{
        if (!isKeySearch&&_infoArr.count>0&&indexPath.section ==1) {
             JHWaimaiMineAddressListDetailModel *model = _infoArr[indexPath.row];
            
            lastPOI = [[XHLocationInfo alloc] init];
            lastPOI.name = model.addr;
            lastPOI.coordinate = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
            
        }else{
            //获取当前的row
            lastPOI = isKeySearch?(XHLocationInfo *)keyAddressArray[row]:(XHLocationInfo *)addressArray[row];
        }
        [self saveClickAddress:lastPOI];
    }

}
- (void)saveClickAddress:(XHLocationInfo *)lastPOI{
    [JHConfigurationTool shareJHConfigurationTool].cityName = [lastPOI.city length] > 0 ? lastPOI.city : @"";
    [JHConfigurationTool shareJHConfigurationTool].cityCode = lastPOI.cityCode;
    [JHConfigurationTool shareJHConfigurationTool].lat = lastPOI.coordinate.latitude;
    [JHConfigurationTool shareJHConfigurationTool].lng = lastPOI.coordinate.longitude;
    [JHConfigurationTool shareJHConfigurationTool].lastCommunity = [lastPOI name];
    [JHConfigurationTool shareJHConfigurationTool].city_id = @"";

    [self getCityName:lastPOI];

    [self.view resignFirstResponder];
    [self.view endEditing:YES];
    // 保存地址选择
    [[JHConfigurationTool shareJHConfigurationTool] saveConfiguration];
    [NoticeCenter postNotificationName:ChooseNewAddress_Notification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getCityName:(XHLocationInfo *)lastPOI{
    [[XHPlaceTool sharePlaceTool] reGeocode:CLLocationCoordinate2DMake(lastPOI.coordinate.latitude, lastPOI.coordinate.longitude) success:^(XHLocationInfo *model) {
        [JHConfigurationTool shareJHConfigurationTool].cityName = model.city;
    } failure:^(NSString *error) {
        
    }];
}
#pragma mark - 开始拖拽时,放弃第一响应
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

//周边搜索
#pragma mark - 高德地图周边搜索
-(void)creatSurrondSearch
{
    SHOW_HUD
    __weak typeof(self)ws = self;
    [[XHPlaceTool sharePlaceTool] getCurrentPlaceWithSuccess:^(XHLocationInfo *model) {
    
        [[XHPlaceTool sharePlaceTool] aroundSearchWithSuccess:^(NSArray<XHLocationInfo *> *pois) {
            HIDE_HUD
            if (pois.count == 0) {
                _statusLabel.text = NSLocalizedString(@"定位服务或网络异常", @"JHAddressMainVC");
            }else{
                
                addressArray = pois;
                _statusLabel.text = [(XHLocationInfo *)pois[0] name];
                NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:_statusLabel.text];
                NSMutableParagraphStyle * paragrap = [[NSMutableParagraphStyle alloc]init];
                [paragrap setLineSpacing:3];
                [attributed addAttribute:NSParagraphStyleAttributeName value:paragrap range:NSMakeRange(0, _statusLabel.text.length)];
                _statusLabel.attributedText = attributed;
                currentCity = [(XHLocationInfo *)pois[0] city];
                [JHConfigurationTool shareJHConfigurationTool].cityName = model.city;
                [XHMapKitManager shareManager].currentCity = model.city;
                [cityBtn setTitle:currentCity forState:UIControlStateNormal];
                [_mainTableView reloadData];
            }
            
        } failure:^(NSString *error) {
            HIDE_HUD
            _statusLabel.text = NSLocalizedString(@"定位服务未开启", @"JHAddressMainVC");
        }];
        
    } failure:^(NSString *error) {
        
    }];
}

//关键字搜索
- (void)keySearchWithkey:(NSString *)key{
    [[XHPlaceTool sharePlaceTool] keywordsSearchWithKeyString:key success:^(NSArray<XHLocationInfo *> *pois) {
        
        if (pois.count == 0) {
                                                              
              _statusLabel.text = NSLocalizedString(@"未定位到附近位置,请手动搜索", @"JHAddressMainVC");
        }else{
          keyAddressArray = pois;
          _statusLabel.text = [(XHLocationInfo *)pois[0] name];
          NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:_statusLabel.text];
          NSMutableParagraphStyle * paragrap = [[NSMutableParagraphStyle alloc]init];
          [paragrap setLineSpacing:3];
          [attributed addAttribute:NSParagraphStyleAttributeName value:paragrap range:NSMakeRange(0, _statusLabel.text.length)];
          _statusLabel.attributedText = attributed;
          [cityBtn setTitle:currentCity forState:(UIControlStateNormal)];
          [_mainTableView reloadData];
        }
    } failure:^(NSString *error) {
       
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchField resignFirstResponder];
}

// 点击更多地址
-(void)chooseMoreAddr{
    currentCity = currentCity.length == 0 ? @"" : currentCity;
    [self pushToNextVcWithVcName:@"JHMoreAddrVC" params:@{@"cityDic":_cityDic,@"currentCity":currentCity}];
}

//点击进入地址管理
- (void)clickAddrManager:(UIButton *)sender{
    //判断是否登录
    NSString *token = [JHUserModel shareJHUserModel].token;
    if (token.length) {
        //已经登录
        Class addressClass = NSClassFromString(@"JHWaiMaiAddressVC");
        JHBaseVC *addressVC = [[addressClass alloc] init];
        [self.navigationController  pushViewController:addressVC animated:YES];
    }else{
        //未登录
        Class loginClass = NSClassFromString(@"JHLoginVC");
        JHBaseVC *loginVC = [[loginClass alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self  presentViewController:loginNav animated:YES completion:nil];
    }
}

-(void)dealloc{
    Remove_Notice
}
@end
