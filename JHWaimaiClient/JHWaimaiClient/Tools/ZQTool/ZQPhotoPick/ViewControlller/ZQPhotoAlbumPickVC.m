//
//  ZQPhotoAlbumPickVC.m
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQPhotoAlbumPickVC.h"
#import "ZQPhotoAlbumCell.h"
#import "ZQChoseImageVC.h"
#define The_Hex(x,y) [ZQPhotoModelTool colorWithHex:x alpha:y]
#define The_ThemeColor The_Hex(@"20ad20",1.0)
// 屏幕宽高
#define The_WIDTH [UIScreen mainScreen].bounds.size.width
#define The_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ZQPhotoAlbumPickVC ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isYes;
}
@property(nonatomic,strong)UITableView *myTableView;//展示相册的表
@property(nonatomic,strong)NSMutableArray *infoArr;//存放信息的数组
@end

@implementation ZQPhotoAlbumPickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    [self checkAuthorizationStatus];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:The_ThemeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:The_Hex(@"ffffff", 1)}];
    [self.navigationController.navigationBar setTintColor:The_Hex(@"ffffff", 1)];
    self.navigationItem.title = NSLocalizedString(@"相册", nil);
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    [self getAlbum];
    //展示相册的表
    [self myTableView];
}
- (void)checkAuthorizationStatus
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
        {
           [self requestAuthorizationStatus];
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            [self showAlert];
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default:
        {
            //已经允许获取相册,不做处理
            break;
        }
    }
}
- (void)requestAuthorizationStatus
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized://用户点击了允许
                {
                    [self getAlbum];
                    break;
                }
                default://用户点击了不允许
                {
                    [self showAlert];
                    break;
                }
            }
        });
    }];
}
-(void)showAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"请在设置-隐私-照片中打开权限", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 点击取消的方法
-(void)clickCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 获取相册信息的方法
-(void)getAlbum{
    [ZQPhotoModelTool loadAlbumInfoWithBlock:^(NSArray *albumArr) {
        for (int i = 0; i < albumArr.count; i++) {
            ZQAlbumModel *model = albumArr[i];
            if ([model.name isEqualToString:NSLocalizedString(@"相机胶卷", nil)]) {
                [self jumpToChoseImageVC:model.result animated:NO];
                isYes = YES;
            }
        }
        if (!isYes&&albumArr.count > 0) {
             ZQAlbumModel *model = albumArr[0];
             [self jumpToChoseImageVC:model.result animated:NO];
        }
        [self.infoArr addObjectsFromArray:albumArr];
        [_myTableView reloadData];
    }];
}
-(NSMutableArray *)infoArr{
    if (!_infoArr) {
        _infoArr = @[].mutableCopy;
    }
    return _infoArr;
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, The_WIDTH, The_HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = [UIColor whiteColor];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            table;
        });
    }
    return _myTableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"ZQPhotoAlbumCell";
    ZQPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[ZQPhotoAlbumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    ZQAlbumModel *model = _infoArr[indexPath.row];
    cell.model = model;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     ZQAlbumModel *model = _infoArr[indexPath.row];
     [self jumpToChoseImageVC:model.result animated:YES];
}
#pragma mark - 跳转到图片选择的控制器
-(void)jumpToChoseImageVC:(PHFetchResult *)result animated:(BOOL)animated{
    ZQChoseImageVC *vc = [[ZQChoseImageVC alloc]init];
    vc.maxCount = self.maxCount;
    vc.result = result;
    [self.navigationController pushViewController:vc animated:animated];
}
@end
