//
//  JHWaiMaiAddAddressVC.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiAddOrModifyAddressVC.h"
#import "JHWaiMaiAddAddressCell.h"
#import "JHWaiMaiAddAddressTagCell.h"
#import "JHWaiMaiAddressAddOrDeleteCell.h"
#import "HZQMapSearch.h"
#import "JHWaimaiMineViewModel.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHShowAlert.h"
#import "XHMapKitHeader.h"
#import <IQKeyboardManager.h>
@interface JHWaiMaiAddOrModifyAddressVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
}
@property(nonatomic,strong)UITableView *addressTable;
@property(nonatomic,strong)UITextField *nameF; //姓名
@property(nonatomic,strong)UITextField *mobileF; //手机
@property(nonatomic,strong)UITextField *addressF; //地址
@property(nonatomic,strong)UITextField *houseF; //门牌号
@property(nonatomic,strong)UIButton *tagBtn; //选中的标签按钮
@property(nonatomic,copy)NSArray *titleArr;
@property(nonatomic,copy)NSArray *placehoderTitleArr;
@property(nonatomic,strong)XHLocationInfo *searchModel;
@property(nonatomic,assign)NSInteger index;//选中的地址类型
@end

@implementation JHWaiMaiAddOrModifyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = (self.vctype == E_addAddress_vc)?NSLocalizedString(@"新增地址", nil):NSLocalizedString(@"修改地址", nil);
    [self.view addSubview:self.addressTable];
    [NoticeCenter addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)textFieldChange:(NSNotification *)noti{
    if (!_detailModel) {
        return;
    }
    if (noti.object == _nameF) {//姓名改变了
        _detailModel.contact = _nameF.text;
    }else if(noti.object == _mobileF){//手机号改变了
        _detailModel.mobile = _mobileF.text;
    }else if(noti.object == _houseF){//门牌号改变了
        _detailModel.house = _houseF.text;
    }
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 2;
    else return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 3) return 120;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak typeof (self)weakSelf = self;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1 && row == 2) {
        JHWaiMaiAddAddressTagCell *cell = [JHWaiMaiAddAddressTagCell new];
        cell.titleL.text = self.titleArr[section][row];
        [cell setMyBlock:^(NSInteger tag){
            weakSelf.index = tag;
            if (_detailModel) {
                _detailModel.type = @(tag).stringValue;
            }
        }];
        if (_detailModel) {
            cell.index = [_detailModel.type integerValue];
            _index = [_detailModel.type integerValue];
        }
        return cell;
    }else if(section == 1 && row == 3){
       
        JHWaiMaiAddressAddOrDeleteCell *cell = [[JHWaiMaiAddressAddOrDeleteCell alloc ] initWithSaveBlock:^{
            [weakSelf addAddress];
        } deleteBlock:^{
            [weakSelf removeAddress];
        }];
        cell.deleteBtn.hidden = self.vctype;
        return cell;
    }else{
        JHWaiMaiAddAddressCell *cell = [JHWaiMaiAddAddressCell new];
        cell.titleL.text = self.titleArr[section][row];
        cell.line.hidden = !((section == 0 && row == 0) || (section ==1 && row <2));
        cell.contentF.placeholder = self.placehoderTitleArr[section][row];
        cell.accessoryType = (section == 1 && row == 0) ? UITableViewCellAccessoryDisclosureIndicator :    UITableViewCellAccessoryNone;
        cell.selectionStyle = (section == 1 && row == 0) ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
        cell.contentF.userInteractionEnabled = !(section == 1 && row == 0);
        cell.contentF.keyboardType = UIKeyboardTypeDefault;
        cell.contentF.delegate = self;
        if (section == 0 && row == 0) {
            if (_detailModel ) {
                cell.contentF.text = _detailModel.contact;
            }
            if (self.nameF) {
                cell.contentF.text = self.nameF.text;
            }
            self.nameF = cell.contentF;
        }
        if (section == 0 && row == 1){
            if (_detailModel ) {
                cell.contentF.text = _detailModel.mobile;
            }
            cell.contentF.keyboardType = UIKeyboardTypeNumberPad;
            if (self.mobileF) {
                cell.contentF.text = self.mobileF.text;
            }
            self.mobileF = cell.contentF;
        }
        if (section == 1 && row == 0){
            if (_detailModel ) {
                cell.contentF.text = _detailModel.addr;
            }
            if (self.addressF) {
                cell.contentF.text = self.addressF.text;
            }
            self.addressF = cell.contentF;
        }
        if (section == 1 && row == 1){
            if (_detailModel ) {
                cell.contentF.text = _detailModel.house;
            }
            if (self.houseF) {
                cell.contentF.text = self.houseF.text;
            }
            self.houseF = cell.contentF;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {   
        __weak typeof(self)weakself = self;
        //进入地址选择器
        XHPlacePicker *placePicker = [[XHPlacePicker alloc] initWithPlaceCallback:^(XHLocationInfo *place) {
            [weakself returnAddress:place];
        }];
        CLLocationCoordinate2D coord = [self changeBaiDuToGaodeWithBaidu:CLLocationCoordinate2DMake([self.detailModel.lat doubleValue], [self.detailModel.lng doubleValue])];
        if (self.detailModel) {
            placePicker.showLat = coord.latitude;
            placePicker.showLng = coord.longitude;
        }else{
            placePicker.showLat = [JHConfigurationTool shareJHConfigurationTool].lat;
            placePicker.showLng = [JHConfigurationTool shareJHConfigurationTool].lng;
        }
        [placePicker startPlacePicker];
    }
}

#pragma mark - 选择地图的回调
-(void)returnAddress:(XHLocationInfo *)model{
    _searchModel = model;
    _addressF.text = _searchModel.name;
    if (_detailModel) {
         _detailModel.addr = _addressF.text;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
- (UITableView *)addressTable{

    if (_addressTable == nil) {
        _addressTable = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT-NAVI_HEIGHT)
                                                                  style:(UITableViewStylePlain)];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = BACK_COLOR;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView;
        });
    }
    return _addressTable;
}


- (NSArray *)titleArr{
    return @[@[NSLocalizedString(@"收货人", nil),
               NSLocalizedString(@"手机号", nil)],
           @[NSLocalizedString(@"地址", nil),
             NSLocalizedString(@"门牌号", nil),
             NSLocalizedString(@"标签", nil)]];
}

- (NSArray *)placehoderTitleArr{
    return @[@[NSLocalizedString(@"姓名", nil),
               NSLocalizedString(@"手机号码", nil)],
           @[NSLocalizedString(@"点击选择地址", nil),
             NSLocalizedString(@"请输入门牌号", nil)]];
}
#pragma mark - 这是添加地址的方法
-(void)addAddress{
    if (_nameF.text.length == 0) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入姓名!", nil)];
    }else if(_mobileF.text.length == 0){
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请输入手机号!", nil)];
    }else if(_addressF.text.length == 0){
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先选择地址!", nil)];
    }else if(_houseF.text.length == 0){
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入门牌号!", nil)];
    }else{
        SHOW_HUD
        //将高德坐标转化为百度坐标
        double baidu_lat;
        double baidu_lng;
        [GaoDe_Convert_BaiDu transform_gaode_to_baiduWithGD_lat:_searchModel.coordinate.latitude
                                                     WithGD_lon:_searchModel.coordinate.longitude
                                                     WithBD_lat:&baidu_lat
                                                     WithBD_lon:&baidu_lng];
        NSMutableDictionary *dic = @{}.mutableCopy;
        NSString *lat = _searchModel?@(baidu_lat).stringValue:_detailModel.lat;
        NSString *lng = _searchModel?@(baidu_lng).stringValue:_detailModel.lng;
        [dic addEntriesFromDictionary:@{@"contact":_nameF.text,@"mobile":_mobileF.text,@"addr":_addressF.text,@"house":_houseF.text,@"lat":lat,@"lng":lng}];
        if (_index > 0) {
            [dic addEntriesFromDictionary:@{@"type":@(_index)}];
        }
        if (_detailModel) {
            [dic addEntriesFromDictionary:@{@"addr_id":_detailModel.addr_id}];
        }
        if (_detailModel) {//修改地址
            [JHWaimaiMineViewModel postToReviseAddressWithDic:dic block:^(NSString *error) {
                HIDE_HUD
                if (error) {
                    [self showToastAlertMessageWithTitle:error];
                }else{
                    [self showToastAlertMessageWithTitle:NSLocalizedString(@"修改地址成功!", nil)];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else{//新增地址
            [JHWaimaiMineViewModel postToCreatAddressWithDic:dic block:^(NSString *error) {
                HIDE_HUD
                if (error) {
                    [self showToastAlertMessageWithTitle:error];
                }else{
                    [self showToastAlertMessageWithTitle:NSLocalizedString(@"新增地址成功!", nil)];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}
#pragma mark - 这是删除该地址的方法
-(void)removeAddress{
    [JHShowAlert showAlertWithTitle:nil withMessage:NSLocalizedString(@"确定删除该地址?", nil) withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withController:self withCancelBlock:nil withSureBlock:^{
        SHOW_HUD
        [JHWaimaiMineViewModel postToRemoveAddressWithDic:@{@"addr_id":_detailModel.addr_id} block:^(NSString *error) {
            HIDE_HUD
            if (error) {
                [self showToastAlertMessageWithTitle:error];
            }else{
                [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已成功删除该地址!", nil)];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];

    }];
}
#pragma mark - 将百度坐标转换为高德坐标
-(CLLocationCoordinate2D)changeBaiDuToGaodeWithBaidu:(CLLocationCoordinate2D)baidu{
    double gaode_lat;
    double gaode_lng;
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:baidu.latitude WithBD_lon:baidu.longitude WithGD_lat:&gaode_lat WithGD_lon:&gaode_lng];
    return CLLocationCoordinate2DMake(gaode_lat, gaode_lng);
}
#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 这是表结束减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是表开始拖动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
@end
