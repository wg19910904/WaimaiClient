//
//  JHWaiMaiMyselfHeadView.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiMyselfHeadView.h"
#import "JHUserAccountSetVC.h"
#import "JHUserModel.h"
#import <UIImageView+WebCache.h>
@implementation JHWaiMaiMyselfHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    //添加头像背景图片
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.image = IMAGE(@"waimai_my_bg");
    
    //添加头像
    [self addSubview:self.headIV];
    _headIV.center = CGPointMake(WIDTH/2, CGRectGetHeight(self.frame)/2);
    //添加姓名;
    [self addSubview:self.nameL];
    _nameL.center = CGPointMake(WIDTH/2, CGRectGetHeight(self.frame)/2 + 45);
}

- (UIImageView *)headIV{
    if (_headIV == nil) {
        _headIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 64, 64)];
        _headIV.layer.cornerRadius = 32;
        _headIV.layer.masksToBounds = YES;
        _headIV.contentMode = UIViewContentModeScaleAspectFill;
        _headIV.userInteractionEnabled = YES;
        JHUserModel *model = [JHUserModel shareJHUserModel];
        if (model.face) {
            [_headIV sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:model.face]] placeholderImage:IMAGE(@"head36_default")];
        }else{
            _headIV.image = IMAGE(@"head36_default");
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadIV:)];
        [_headIV addGestureRecognizer:tap];
    }
    return _headIV;
}

- (UILabel *)nameL{
    if (_nameL == nil) {
        _nameL = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH, 30)];
         JHUserModel *model = [JHUserModel shareJHUserModel];
        _nameL.text = model.nickname?model.nickname:NSLocalizedString(@"未登录", nil);
        _nameL.textColor = [UIColor whiteColor];
        _nameL.font = FONT(14);
        _nameL.textAlignment = NSTextAlignmentCenter;
    }
    return _nameL;
}

- (void)refreshPosition:(CGFloat)offset_y{
    self.frame = FRAME(0, CGRectGetMinY(self.frame), WIDTH, 130-offset_y + (self.isMall?NAVI_HEIGHT:0));
    self.headIV.center = CGPointMake(WIDTH/2, 65-offset_y/2 + (self.isMall?NAVI_HEIGHT:0));
    self.nameL.center = CGPointMake(WIDTH/2, 65-offset_y/2 + 45 + (self.isMall?NAVI_HEIGHT:0));
}

#pragma mark - 点击头像
- (void)clickHeadIV:(UITapGestureRecognizer *)ges{
    NSLog(@"点击了头像");
    if ([JHUserModel shareJHUserModel].token) {
        JHUserAccountSetVC *vc = [[JHUserAccountSetVC alloc]init];
        [self.superVC.navigationController pushViewController:vc animated:YES];
        return;
    }
    //登录
    [NoticeCenter postNotificationName:LOGIN_NoticeName object:nil];
}
/**
 刷新数据
 */
-(void)refreshData{
    JHUserModel *model = [JHUserModel shareJHUserModel];
    if (model.token) {
        _nameL.text = model.nickname;
        [_headIV sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:model.face]] placeholderImage:IMAGE(@"head36_default")];
    }else{
        _nameL.text = NSLocalizedString(@"未登录", nil);
        _headIV.image = IMAGE(@"head36_default");
    }
}
- (void)setIsMall:(BOOL)isMall{
    if (isMall) {
        self.image = IMAGE(@"mall_my_bg");
        _headIV.center = CGPointMake(WIDTH/2, CGRectGetHeight(self.frame)/2+32);
        _nameL.center = CGPointMake(WIDTH/2, CGRectGetHeight(self.frame)/2 + 45 + 32);
    }
    _isMall = isMall;
}
@end
