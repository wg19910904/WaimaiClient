//
//  JHWaimaiOrderEvaluateSubmitImageCell.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/13.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderEvaluateSubmitImageCell.h"
#import "JHWaimaiOrderShowImageColCell.h"
@interface JHWaimaiOrderEvaluateSubmitImageCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIImageView *addBtn;//加号的按钮
@property(nonatomic,strong)UILabel *titleL;//提示的
@property(nonatomic,strong)HZQChoseImage *choseImgVC;//选择图片的控制器
@property(nonatomic,strong)UICollectionView *myCollectionView;//展示图片的
@end
@implementation JHWaimaiOrderEvaluateSubmitImageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BACK_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self myCollectionView];
        [self titleL];
       
    }
    return self;
}
#pragma mark - clickAddBtn
-(void)clickAddBtn{
    NSInteger a = _modelArr.count;
    self.choseImgVC.maxCount = 5-a;
    [self.choseImgVC creatChoseImage];
}
-(HZQChoseImage *)choseImgVC{
    if (!_choseImgVC) {
        _choseImgVC = [[HZQChoseImage alloc]init];
        _choseImgVC.maxCount = 5;
        _choseImgVC.delegate = self.superVC;
    }
    return _choseImgVC;
}
#pragma mark - 提示的
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = NSLocalizedString(@"最多5张", nil);
        _titleL.textColor = HEX(@"666666", 1);
        _titleL.font = FONT(10);
        [self addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_myCollectionView.mas_bottom).offset = 10;
            make.height.offset = 12;
            make.bottom.offset = -20;
            make.left.offset = 10;
        }];
    }
    return _titleL;
}
-(void)setModelArr:(NSMutableArray *)modelArr{
    _modelArr = modelArr;
    [_myCollectionView reloadData];
}
#pragma mark - 这是展示图片的collectionview
-(UICollectionView *)myCollectionView{
    CGFloat w = (WIDTH - 60)/5;
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        _myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 0, WIDTH, w) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = BACK_COLOR;
        [_myCollectionView registerClass:[JHWaimaiOrderShowImageColCell class] forCellWithReuseIdentifier:@"cell"];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.scrollEnabled = NO;
        [self addSubview:_myCollectionView];
        [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.top.offset = 5;
            make.width.offset = WIDTH;
            make.height.offset = w;
        }];
    }
    return _myCollectionView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _modelArr.count+1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH - 60)/5, (WIDTH - 60)/5);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHWaimaiOrderShowImageColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item < _modelArr.count) {
        ZQImageModel *model = _modelArr[indexPath.item];
        cell.image = model.image;
        cell.hiddenRemove = NO;
    }else{
        cell.image = IMAGE(@"add_pingjia_pic");
        cell.hiddenRemove = YES;
    }
    __weak typeof (self)weakSelf = self;
    [cell setRemoveBlock:^{
        [weakSelf clickRemove:indexPath.item];
    }];
    return cell;
}
-(void)clickRemove:(NSInteger )index{
    if (_removeBlock) {
        _removeBlock(index);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _modelArr.count) {
        [self clickAddBtn];
    }
}
@end
