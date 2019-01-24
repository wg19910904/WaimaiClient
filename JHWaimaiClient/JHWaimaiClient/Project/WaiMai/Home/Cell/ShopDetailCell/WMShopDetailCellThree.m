//
//  WMShopDetailCellThree.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/17.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopDetailCellThree.h"
#import <UIImageView+WebCache.h>
#import "PresentAnimationTransition.h"
#import "YFDisplayImagesVC.h"

#define  img_tag 100

@interface WMShopDetailCellThree ()<PresentAnimationTransitionShowImgDelegate>
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,strong)NSArray *imgArr;
@end

@implementation WMShopDetailCellThree

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.height.offset=20;
    }];
    titleLab.textColor = TEXT_COLOR;
    titleLab.font = FONT(14);
    self.titleLab = titleLab;
    
    CGFloat imgW = (WIDTH-40 )/3;
    CGFloat imgH = 70;
    
    for (NSInteger i=0; i<3; i++) {
        
        UIImageView *imgView = [UIImageView new];
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=10 + (imgW + 10) * i;
            make.top.offset=40;
            make.width.offset=imgW;
            make.height.offset=imgH;
        }];
        imgView.tag = img_tag + i;
        imgView.hidden = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImg:)];
        [imgView addGestureRecognizer:tap];
        imgView.userInteractionEnabled = YES;
    }
    
}

-(void)reloadCellWith:(NSString *)title imgArr:(NSArray *)imgArr{
    self.titleLab.text = title;
    self.imgArr = imgArr;
    for (NSInteger i=0; i<3; i++) {
        UIImageView *imgView = [self.contentView viewWithTag:img_tag + i];
        imgView.hidden = YES;
        if (i < imgArr.count) {
            imgView.hidden = NO;
            [imgView sd_setImageWithURL:[NSURL URLWithString:ImageUrl(imgArr[i])] placeholderImage:IMAGE(@"photo_placeHolder")];
        }

    }
}

#pragma mark ====== DisplayerImg =======
-(void)showImg:(UITapGestureRecognizer *)tap{
    UIImageView *imgView = (UIImageView *)tap.view;
    self.selectedIndex = imgView.tag - img_tag;

    YFDisplayImagesVC *displayerVC = [YFDisplayImagesVC new];
    displayerVC.imgsArr = self.imgArr;
    displayerVC.index = self.selectedIndex;
    displayerVC.presentAnimation.delegate = self;
    displayerVC.clickDismiss = ^(NSInteger index){
        self.selectedIndex = index;
    };
    [self.superVC presentViewController:displayerVC animated:YES completion:nil];
    
}

#pragma mark ======PresentAnimationTransitionShowImgDelegate=======
-(UIImage *)presentAnimationTransitionWillNeedView{
    
    UIImageView *imgView = [self.contentView viewWithTag:self.selectedIndex + img_tag];
    return imgView.image;
}

-(CGRect)presentAnimationTransitionViewFrame{
    
    if (self.selectedIndex < 3) {
        UIImageView *imgView = [self.contentView viewWithTag:self.selectedIndex + img_tag];
        return [self convertRect:imgView.frame toView:self.superVC.view];
    }else{
        return [self convertRect:FRAME(WIDTH, 40, 100, 40) toView:self.superVC.view];
    }
}


@end
