//
//  WMEvaluateCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMEvaluateCell.h"
#import <UIImageView+WebCache.h>
#import "YFStartView.h"
#import "YFCollectionViewLayout.h"
#import "EvaluateImgCell.h"
#import "NSString+Tool.h"
#import "PresentAnimationTransition.h"
#import "YFDisplayImagesVC.h"

@interface WMEvaluateCell ()<UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewLayoutDelegate,PresentAnimationTransitionShowImgDelegate>
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *nameLab;
@property(nonatomic,weak)UILabel *dateLab;
@property(nonatomic,weak)YFStartView *starView;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *contentLab;
@property(nonatomic,strong)NSArray *imgArr;
@property(nonatomic,weak)UICollectionView *imgCollectionView;
@property(nonatomic,weak)UIImageView *replyImgView;
@property(nonatomic,weak)UILabel *replyLab;

@property(nonatomic,assign)NSIndexPath *selectedIndexPaht;

@end

@implementation WMEvaluateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.width.offset=36;
        make.height.offset=36;
    }];
    iconImgView.layer.cornerRadius=18;
    iconImgView.clipsToBounds=YES;
    self.iconImgView = iconImgView;
    
    UILabel *dateLab = [UILabel new];
    [self.contentView addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.top.offset=10;
        make.height.offset=20;
    }];
    dateLab.font = FONT(11);
    dateLab.textAlignment = NSTextAlignmentRight;
    dateLab.textColor = HEX(@"999999", 1.0);
    self.dateLab = dateLab;
    
    UILabel *nameLab = [UILabel new];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.right.equalTo(dateLab.mas_left).offset= -10;
        make.top.offset=10;
        make.height.offset=20;
    }];
    nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLab.font = FONT(12);
    nameLab.textColor = HEX(@"666666", 1.0);
    self.nameLab = nameLab;

    YFStartView *starView = [YFStartView new];
    [self.contentView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.bottom.equalTo(iconImgView.mas_bottom).offset=0;
        make.height.offset = 12;
        make.width.offset = 70;
    }];
    starView.interSpace = 2.5;
    starView.fullStarNum = 5;
    starView.currentStarScore = 0.0;
    starView.starType = YFStarViewFloat;
    starView.imgSize = CGSizeMake(12, 12);
    starView.userInteractionEnabled = NO;
    self.starView = starView;
    
    UILabel *timeLab = [UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starView.mas_right).offset= 10;
        make.centerY.equalTo(starView.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    timeLab.font = FONT(12);
    timeLab.textColor = HEX(@"999999", 1.0);
    self.timeLab = timeLab;
    
    UILabel *contentLab = [UILabel new];
    [self.contentView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).offset=10;
        make.left.offset= 10;
        make.right.offset = -10;
    }];
    contentLab.numberOfLines = 0;
    contentLab.font = FONT(12);
    contentLab.textColor = TEXT_COLOR;
    self.contentLab = contentLab;
    
    YFCollectionViewLayout * flowLayout=[[YFCollectionViewLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.lineItems = 10;
    flowLayout.interSpace = 5;
    flowLayout.delegate = self;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDTH,0) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[EvaluateImgCell class] forCellWithReuseIdentifier:@"EvaluateImgCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    [self.contentView addSubview:collectionView];
    self.imgCollectionView = collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset= 5;
        make.top.equalTo(contentLab.mas_bottom).offset=5;
        make.right.offset=-5;
        make.height.offset= (WIDTH - 30)/5 + 10;
    }];
    
    UIImageView *replyImgView = [UIImageView new];
    [self.contentView addSubview:replyImgView];
    [replyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.equalTo(collectionView.mas_bottom).offset=0;
        make.right.offset=-10;
        make.bottom.offset=-10;
    }];
    replyImgView.image = IMAGE(@"");
    self.replyImgView = replyImgView;
    
    UILabel *replyLab = [UILabel new];
    [replyImgView addSubview:replyLab];
    [replyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset = 5;
        make.right.bottom.offset = -5;
    }];
    replyLab.numberOfLines = 0;
    replyLab.font = FONT(12);
    replyLab.textColor = TEXT_COLOR;
    self.replyLab = replyLab;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArr.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EvaluateImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EvaluateImgCell" forIndexPath:indexPath];
    cell.imgUrl = self.imgArr[indexPath.item][@"photo"];
    return cell;
}

#pragma mark ======YFCollectionViewLayoutDelegate=======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH - 30)/5 , (WIDTH - 30)/5 );
}

-(void)reloadCellWithModel:(WMEvaluateModel *)model{
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(model.face)] placeholderImage:IMAGE(@"head36_default")];
    self.nameLab.text = model.nickname;
    self.dateLab.text = [NSString formateDate:@"yyyy/MM/dd" dateline:model.dateline];//@"2016/23/2";
    self.starView.currentStarScore = model.score;
    self.timeLab.text = model.pei_time;//@"30分钟送达";
    self.imgArr = model.comment_photos;
    [self.imgCollectionView reloadData];
    self.contentLab.text = model.content;
    model.have_photo = model.comment_photos.count > 0;
    
    if (model.have_photo) {
        [self.imgCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLab.mas_bottom).offset=5;
            make.height.offset= (WIDTH - 40)/5 + 10;
        }];
    }else{
        [self.imgCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLab.mas_bottom).offset=0;
            make.height.offset= 0;
        }];
    }
    [self.imgCollectionView reloadData];
   
    
    if (model.reply.length == 0) {
        self.replyLab.text = @"";
        self.replyImgView.hidden = YES;
        [self.replyImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgCollectionView.mas_bottom).offset=-20;
            make.bottom.offset= -10;
        }];
    }else{
        
        self.replyLab.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"商家回复", @"WMEvaluateCell"),model.reply];
        self.replyImgView.hidden = NO;
        [self.replyImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgCollectionView.mas_bottom).offset=0;
            make.bottom.offset=-10;
        }];
    }

    if (!model.have_photo && model.reply.length == 0) {
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset=-10;
        }];
    }else{
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImgView.mas_bottom).offset=10;
            make.left.offset= 10;
            make.right.offset = -10;
        }];
    }
}


#pragma mark ====== DisplayerImg =======
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndexPaht = indexPath;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in self.imgArr) {
        [arr addObject:dic[@"photo"]];
    }
    YFDisplayImagesVC *displayerVC = [YFDisplayImagesVC new];
    displayerVC.imgsArr = arr.copy;
    displayerVC.index = indexPath.item;
    displayerVC.presentAnimation.delegate = self;
    displayerVC.clickDismiss = ^(NSInteger index){
        self.selectedIndexPaht = [NSIndexPath indexPathForRow:index inSection:0];
    };
    [self.superVC presentViewController:displayerVC animated:YES completion:nil];
    
}

#pragma mark ======PresentAnimationTransitionShowImgDelegate=======
-(UIImage *)presentAnimationTransitionWillNeedView{
    EvaluateImgCell *cell = (EvaluateImgCell *)[self.imgCollectionView cellForItemAtIndexPath:self.selectedIndexPaht];
    return cell.imgView.image;
}

-(CGRect)presentAnimationTransitionViewFrame{
    EvaluateImgCell *cell = (EvaluateImgCell *)[self.imgCollectionView cellForItemAtIndexPath:self.selectedIndexPaht];
    return [self.imgCollectionView convertRect:cell.frame toView:self.superVC.view];
}

@end
