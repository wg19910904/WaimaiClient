//
//  WMShopCateCell.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMShopMenuCateCell.h"

@interface WMShopMenuCateCell ()
@property(nonatomic,weak)UIImageView *cateImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *countLab;
//@property(nonatomic,weak)UIImageView *indexImgView;
@property(nonatomic,assign)BOOL is_hot;// 是否是热销
@end

@implementation WMShopMenuCateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
//    UIImageView *indexImgView = [UIImageView new];
//    [self.contentView addSubview:indexImgView];
//    [indexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset=0;
//        make.top.offset=0;
//        make.width.offset=3;
//        make.height.offset = 60;
//        make.bottom.offset=0;
//    }];
//    indexImgView.image = IMAGE(@"index_icon_vl02");
//    self.indexImgView = indexImgView;
    
    UIImageView *cateImgView = [UIImageView new];
    [self.contentView addSubview:cateImgView];
    [cateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.centerY.offset=0;
        make.width.offset=20;
        make.height.offset = 20;
    }];
    self.cateImgView = cateImgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets = UIEdgeInsetsMake(0, 6, 0, 0);
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"4a4b4c", 1.0);
    titleLab.numberOfLines = 2;
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab = titleLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-5;
        make.top.offset=5;
        make.height.offset = 12;
        make.width.greaterThanOrEqualTo(@16);
    }];
    countLab.backgroundColor = HEX(@"ff6600", 1.0);
    countLab.textColor = [UIColor whiteColor];
    countLab.layer.cornerRadius=6;
    countLab.font = FONT(10);
    countLab.textAlignment = NSTextAlignmentCenter;
    countLab.hidden = YES;
    countLab.clipsToBounds=YES;
    self.countLab = countLab;
    
}

-(void)reloadCellWithModel:(WMShopCateModel *)model{
    self.titleLab.text = model.title;
    int count = model.cate_choosedCount;
    if (Current_Is_Other_ShopCart) {
        count = model.current_shopcart_choosedCount;
    }
    self.countLab.text = [NSString stringWithFormat:@"%d",count];
    self.countLab.hidden = model.cate_choosedCount == 0 ? YES : NO;
    self.is_hot = [model.cate_id isEqualToString:@"hot"];
    self.countLab.hidden = self.is_hot || model.cate_choosedCount == 0 ;
    
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 30;
    }];
    if ([model.cate_id isEqualToString:@"hot"]) {
        self.cateImgView.image = IMAGE(@"icon_hot");
    }else if ([model.cate_id isEqualToString:@"must"]){
        self.cateImgView.image = IMAGE(@"icon_need");
    }else{
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
        }];
        self.cateImgView.image = nil;
    }
    
    if (count < 10) {
        [self.countLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-5;
            make.top.offset=5;
            make.height.width.offset = 12;
        }];
    }else{
        [self.countLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-5;
            make.top.offset=5;
            make.height.offset = 12;
            make.width.greaterThanOrEqualTo(@16);
        }];
    }
    
}

-(void)countChange:(BOOL)is_add{
    
    int count = [self.countLab.text intValue];
    if (is_add) {
        count += 1;
    }else{
        count -= 1;
    }
    count = count <= 0 ? 0 : count;
    self.countLab.text = [NSString stringWithFormat:@"%d",count];
    self.countLab.hidden = count == 0 ? YES : NO;
    self.countLab.hidden = self.is_hot || count == 0 ;
    
    if (count < 10) {
        [self.countLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-5;
            make.top.offset=5;
            make.height.width.offset = 12;
        }];
    }else{
        [self.countLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-5;
            make.top.offset=5;
            make.height.offset = 12;
            make.width.greaterThanOrEqualTo(@16);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    self.indexImgView.hidden = !selected;
    self.titleLab.textColor = selected ? THEME_COLOR_Alpha(1.0) : HEX(@"4a4b4c", 1.0);
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : HEX(@"f4f4f4", 1.0);
    
}

@end
