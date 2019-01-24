//
//  JHChooseCityVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/21.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHChooseCityVC.h"

#import "JHConfigurationTool.h"
@interface JHChooseCityVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHChooseCityVC
{
    //导航栏
    UIView *_customNav;
    UIButton *backBtn_custom;
    UILabel *title_;
    //搜索框
    UITextField *_searchField;
    //城市key组成的数组
    NSMutableArray *keyArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建自定义导航栏
    [self createNav];
    //根据cityDic判断怎样创建主表视图
    [self createTableView];
}
#pragma mark - 创建左边按钮
- (void)createNav
{
    _customNav = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, NAVI_HEIGHT)];
    [self.view addSubview:_customNav];
    _customNav.backgroundColor = NaVi_COLOR_Alpha(1.0);
    backBtn_custom = [[UIButton alloc] initWithFrame:CGRectMake(15,STATUS_HEIGHT,44,44)];
    [backBtn_custom addTarget:self action:@selector(clickBackBtn)
             forControlEvents:UIControlEventTouchUpInside];
    [backBtn_custom setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    backBtn_custom.imageEdgeInsets = UIEdgeInsetsMake(13, 0, 13, 26);
    [_customNav addSubview:backBtn_custom];
    title_ = [[UILabel alloc] initWithFrame:FRAME(0, 0, 100, 44)];
    title_.text = NSLocalizedString(@"选择城市", @"JHChooseCityVC");
    title_.font = FONT(17);
    title_.textColor = HEX(@"333333", 1.0);
    title_.textAlignment = NSTextAlignmentCenter;
    [_customNav addSubview:title_];
    title_.center = CGPointMake(_customNav.center.x, _customNav.center.y + (isIPhoneX ? 22 : 10));
}
#pragma mark - 点击导航栏左按钮
- (void)clickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - 创建表视图
- (void)createTableView{
    if (_cityDic) {
        [self handleKeyarrAndRefresh];
    }else{
        //请求城市数据
        [HttpTool postWithAPI:@"client/data/city" withParams:@{} success:^(id json) {
            NSLog(@"%@",json);
            _cityDic = json[@"data"][@"items"];
            [self handleKeyarrAndRefresh];
        } failure:^(NSError *error) {}];
    }
}
- (void)handleKeyarrAndRefresh{
    keyArray = @[].mutableCopy;
    [keyArray addObjectsFromArray:[[_cityDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
//    [keyArray insertObject:NSLocalizedString(@"热门城市", nil) atIndex:0];
    [keyArray insertObject:NSLocalizedString(@"当前定位", nil) atIndex:0];
    
    [self createMainTableView];
}
- (void)createMainTableView
{
    if (_mainTableView) {
        [_mainTableView reloadData];
    }else{
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0,NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) style:(UITableViewStylePlain)];
        _mainTableView.backgroundColor = BACK_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.sectionIndexColor = HEX(@"666666", 1.0f);//改变索引的颜色
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cityDic.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
//    else if(section == 1)
//    {
//        return 1;
//    }
    else{
        NSString *key = keyArray[section];
        return [_cityDic[key] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
    sectionView.backgroundColor = BACK_COLOR;
    //添加标签
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0,  200, 40)];
    [keyArray replaceObjectAtIndex:0 withObject:NSLocalizedString(@"当前定位", nil)];
//    [keyArray replaceObjectAtIndex:1 withObject:NSLocalizedString(@"热门城市", nil)];
    titleLabel.text = keyArray[section];
    titleLabel.font = FONT(14);
    titleLabel.textColor =  HEX(@"999999", 1.0);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [sectionView addSubview:titleLabel];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) { //当前定位
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 48)];
        titleLabel.text = self.currentCity;
        titleLabel.textColor = HEX(@"666666", 1.0f);
        titleLabel.font = FONT(16);
        [cell addSubview:titleLabel];
        return cell;
    }else{ //其他分区
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 48)];
        NSString *key = keyArray[section];
        NSDictionary *dic = _cityDic[key][row];
        titleLabel.text = dic[@"city_name"];
        titleLabel.font = FONT(16);
        titleLabel.textColor = HEX(@"333333", 1.0f);
        [cell addSubview:titleLabel];
        //添加下划线
        if (indexPath.row != ([_cityDic[key] count] -1)) {
            UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 47.5, WIDTH, 0.5)];
            line.backgroundColor = LINE_COLOR;
            [cell addSubview:line];
        }
        return cell;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   //处理为需要的数组
    [keyArray replaceObjectAtIndex:0 withObject:@"#"];
//     [keyArray replaceObjectAtIndex:1 withObject:NSLocalizedString(@"热", nil)];
    return keyArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    //获取当前选中的行的城市名和城市code
    NSDictionary *cityDic = _cityDic[keyArray[section]][row];
    NSString *cityName = cityDic[@"city_name"];
    NSString *cityCode = cityDic[@"city_code"];
    NSString *city_id = cityDic[@"city_id"];
    [JHConfigurationTool shareJHConfigurationTool].cityName = cityName;
    [JHConfigurationTool shareJHConfigurationTool].cityCode = cityCode;
    [JHConfigurationTool shareJHConfigurationTool].city_id = city_id;
    self.refreshCityBlock(cityName,city_id);
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 滚动放弃第一响应
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchField resignFirstResponder];
}

@end
