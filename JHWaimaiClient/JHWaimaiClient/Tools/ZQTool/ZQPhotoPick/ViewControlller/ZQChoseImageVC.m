//
//  ZQChoseImageVC.m
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQChoseImageVC.h"
#import "ZQChoseImageCell.h"
#import "ZQSeeImageView.h"
#import "ZQPhotoAlbumPickVC.h"
#define The_Hex(x,y) [ZQPhotoModelTool colorWithHex:x alpha:y]
#define The_ThemeColor The_Hex(@"20ad20",1.0)
// 屏幕宽高
#define The_WIDTH [UIScreen mainScreen].bounds.size.width
#define The_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ZQChoseImageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIView *buttomView;//底部的View
@property(nonatomic,strong)UIButton *btn_see;//预览的按钮
@property(nonatomic,strong)UIButton *btn_sure;//确定的按钮
@property(nonatomic,strong)UICollectionView *myCollectionView;//展示图片的
@property(nonatomic,strong)NSMutableArray * imgArr;//选择的图片
@property(nonatomic,strong)ZQSeeImageView * SeeImgView;//预览图片的View
@end

@implementation ZQChoseImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //底部的view
    [self buttomView];
    //添加展示图片的
    [self myCollectionView];
}
-(NSMutableArray *)imgArr{
    if (!_imgArr) {
        _imgArr = @[].mutableCopy;
    }
    return _imgArr;
}
#pragma mrak - 初始化一些数据的方法
-(void)initData{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:The_ThemeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:The_Hex(@"ffffff", 1)}];
    [self.navigationController.navigationBar setTintColor:The_Hex(@"ffffff", 1)];
    self.navigationItem.title = NSLocalizedString(@"图片", nil);
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    for (int i = 0; i < self.result.count; i++) {
        ZQImageModel *model = [[ZQImageModel alloc]init];
        [self.imgArr addObject:model];
    }

}
#pragma mark - 点击取消的方法
-(void)clickCancel{
    UIViewController * vc = self.navigationController.viewControllers[0];
    [vc dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 添加collectionview
-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 5;
        _myCollectionView= [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, The_WIDTH, The_HEIGHT-NAVI_HEIGHT-40) collectionViewLayout:layout];
        [_myCollectionView registerClass:[ZQChoseImageCell class] forCellWithReuseIdentifier:@"cell"];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.alwaysBounceVertical = YES;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_myCollectionView];
    }
    return _myCollectionView;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.result.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((The_WIDTH-25)/4, (The_WIDTH-25)/4);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQChoseImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PHAsset *asset = self.result[indexPath.item];
    cell.asset = asset;
    cell.maxNum = self.maxCount;
    cell.arr = self.imgArr;
    cell.model = _imgArr[indexPath.item];
    cell.superVC = self;
    __weak typeof(self) weakSelf=self;
    [cell setMyBlock:^(BOOL isSelector,UIImage *image){
        [weakSelf editImgArr:isSelector index:indexPath.item image:image];
    }];
    return cell;
}
#pragma mark - 添加或者移除图片
-(void)editImgArr:(BOOL)isYes index:(NSInteger)index image:(UIImage *)image{

    ZQImageModel * model = _imgArr[index];
    model.image = image;
    model.width = image.size.width;
    model.height = image.size.height;
    model.isSelector = isYes;
    UIImage *img = [ZQPhotoModelTool scaleFromImage:image scaledToSize:CGSizeMake(500, 500)];
    model.data = UIImagePNGRepresentation(img);
    NSLog(@"%@",model);
}
#pragma mark - buttomView
-(UIView *)buttomView{
    if (!_buttomView) {
        _buttomView = [[UIView alloc]init];
        _buttomView.backgroundColor = The_Hex(@"333333", 1);
        _buttomView.frame = CGRectMake(0, The_HEIGHT- 40, The_WIDTH, 40);
        [self.view addSubview:_buttomView];
        [self btn_see];
        [self btn_sure];
    }
    return _buttomView;
}
#pragma mark - 预览的按钮
-(UIButton *)btn_see{
    if (!_btn_see) {
        _btn_see = [[UIButton alloc]init];
        _btn_see.frame = CGRectMake(5, 0, 40, 40);
        [_btn_see setTitle:NSLocalizedString(@"预览", nil) forState:UIControlStateNormal];
        [_btn_see setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_see.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn_see addTarget:self action:@selector(clickSeeBtn) forControlEvents:UIControlEventTouchUpInside];
        [_buttomView addSubview:_btn_see];
    }
    return _btn_see;
}
#pragma mark - 这是点击预览的方法
-(void)clickSeeBtn{
    NSArray *arr = [self getAllImage];
    if (arr.count > 0) {
        [self.SeeImgView showViewWithImgArr:arr];
    }
    
}
#pragma mark - 预览的按钮
-(UIButton *)btn_sure{
    if (!_btn_sure) {
        _btn_sure = [[UIButton alloc]init];
        _btn_sure.frame = CGRectMake(The_WIDTH-55, 5, 50, 30);
        [_btn_sure setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_sure.backgroundColor = The_ThemeColor;
        _btn_sure.layer.cornerRadius = 4;
        _btn_sure.layer.masksToBounds = YES;
        _btn_sure.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn_sure addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [_buttomView addSubview:_btn_sure];
    }
    return _btn_sure;
}
#pragma mark - 点击确定的方法
-(void)clickSureBtn{
    NSArray * arr = [self getAllImage];
    if (arr.count == 0) {
        [self showAlert:NSLocalizedString(@"请先选择照片!", nil)];
        return;
    }
    ZQPhotoAlbumPickVC * vc = self.navigationController.viewControllers[0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (vc.resultBlock) {
            vc.resultBlock(arr);
        }
    });
    [vc dismissViewControllerAnimated:YES completion:nil];
}
-(void)showAlert:(NSString *)msg{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil]];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}
#pragma mark - 获取所有选中的图片
-(NSArray *)getAllImage{
    NSMutableArray *arr = @[].mutableCopy;
    for (ZQImageModel *model in _imgArr) {
        if (model.isSelector) {
            [arr addObject:model];
        }
    }
    return arr;
}
-(ZQSeeImageView *)SeeImgView{
    if (!_SeeImgView) {
        _SeeImgView = [[ZQSeeImageView alloc]init];
    }
    return _SeeImgView;
}
@end
