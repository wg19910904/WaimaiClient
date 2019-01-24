//
//  JHWaiMaiAddressListCell.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2017/5/24.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaiMaiAddressListCell.h"
@interface JHWaiMaiAddressListCell()
@property(nonatomic,strong)UIImageView *imgV;//选中的图片
@property(nonatomic,strong)UIControl *bgView;//去掉点击效果
@property(nonatomic,strong)JHWaimaiMineAddressListDetailModel* model;
@end
@implementation JHWaiMaiAddressListCell
{
    UILabel *customL; //用户姓名及电话label
    UILabel *addressL; //用户地址lable
    UIView *line; //分割线
    UILabel *tagL; //便签分类label
    UIButton *_editBtn; //编辑按钮
    UIButton *_deleteBtn; //删除按钮
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
        [self imgV];
        [self bgView];
    }
    return self;
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.image = IMAGE(@"icon_selected");
        [self addSubview:_imgV];
        _imgV.hidden = YES;
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.centerY.mas_equalTo(self.mas_centerY).offset = -15;
            make.width.offset = 20;
            make.height.offset = 15;
        }];
    }
    return _imgV;
}
-(UIControl *)bgView{
    if (!_bgView) {
        _bgView= [[UIControl alloc]init];
        _bgView.backgroundColor = HEX(@"fafafa", 0.5);
        [self addSubview:_bgView];
        _bgView.hidden = YES;
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset = 0;
        }];
        UILabel *label = [[UILabel alloc]init];
        label.text = NSLocalizedString(@"超出配送范围", nil);
        label.textColor = HEX(@"FA4C34", 1);
        label.font = FONT(15);
        [_bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.top.equalTo(line.mas_bottom).offset = 5;
            make.height.offset = 20;
            make.width.offset = 120;
        }];
    }
    return _bgView;
}
- (void)setupView{
    customL = [UILabel new];
    customL.textColor = HEX(@"333333", 1.0);
    customL.font = B_FONT(15);
    
    addressL = [UILabel new];
    addressL.font = FONT(13);
    addressL.textColor = HEX(@"666666", 1.0);
    addressL.numberOfLines = 0;
    
    line = [UILabel new];
    line.backgroundColor = HEX(@"e6eaed", 1.0);
    
    tagL = [UILabel new];
    tagL.font = FONT(12);
    tagL.textColor = [UIColor whiteColor];
    tagL.layer.cornerRadius = 2;
    tagL.clipsToBounds = YES;
    tagL.textAlignment = NSTextAlignmentCenter;
    
    _editBtn = [UIButton new];
    [_editBtn setImage:IMAGE(@"mall_my_btn_edit") forState:(UIControlStateNormal)];
    [_editBtn setTitle:NSLocalizedString(@"编辑", nil) forState:0];
    _editBtn.titleLabel.font = FONT(12);
    [_editBtn setTitleColor:HEX(@"666666", 1) forState:0];
    [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5,5)];
    [_editBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 0)];
    _deleteBtn = [UIButton new];
    
    [_deleteBtn setImage:IMAGE(@"mall_my_btn_delete") forState:(UIControlStateNormal)];
    [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [_deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:0];
    [_deleteBtn setTitleColor:HEX(@"666666", 1) forState:0];
    _deleteBtn.titleLabel.font = FONT(12);
      [_deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 0)];

    
    
    [self.contentView addSubview:customL];
    [self.contentView addSubview:addressL];
    [self.contentView addSubview:line];
    [self.contentView addSubview:tagL];
    [self.contentView addSubview:_editBtn];
    [self.contentView addSubview:_deleteBtn];
    
    
    [customL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.offset = 10;
        make.width.priorityLow();
        make.height.offset = 30;
    }];
    [customL setContentCompressionResistancePriority:UILayoutPriorityRequired
                                           forAxis:UILayoutConstraintAxisHorizontal];
    [customL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    
    [addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -40;
        make.top.equalTo(customL.mas_bottom).offset = 5;
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(addressL.mas_bottom).offset = 7;
        make.height.offset = 0.5;
    }];
    
    [tagL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customL.mas_right).offset = 10;
        make.top.equalTo(customL.mas_top).offset = 0+5;
        make.height.offset = 20;
        make.width.offset = 48;
    }];
    tagL.backgroundColor = HEX(@"4DC831", 0.2);
    tagL.textColor = HEX(@"4DC831", 1);

    
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset = 5;
        make.right.offset = -100;
        make.height.offset = 30;
        make.width.offset = 60;
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset = 5;
        make.right.offset = -20;
        make.height.offset = 30;
        make.bottom.offset = -5;
        make.width.offset = 60;
    }];
}

-(void)reloadCellWithModel:(JHWaimaiMineAddressListDetailModel *)model is_choose_paotui:(BOOL)is_choose_paotui{
    _model = model;
    if (is_choose_paotui) {
        _bgView.hidden = !(model.is_available == 0) ;
    }else{
        if (model.is_in) {
            if ([model.is_in integerValue] == 1) {
                _bgView.hidden = YES;
            }else{
                _bgView.hidden = NO;
            }
        }
    }
    customL.text = [NSString stringWithFormat:@"%@-%@",model.contact,model.mobile];
    addressL.text = [NSString stringWithFormat:@"%@ %@",model.addr,model.house];
    tagL.text = model.typeName;
    
 
}

//- (void)setModel:(JHWaimaiMineAddressListDetailModel *)model{
//
//    _model = model;
//    _bgView.hidden = !(model.is_availabl == 0) ;
////    if (model.is_in) {
////        if ([model.is_in integerValue] == 1) {
////            _bgView.hidden = YES;
////        }else{
////            _bgView.hidden = NO;
////        }
////    }
//
//    customL.text = [NSString stringWithFormat:@"%@-%@",model.contact,model.mobile];
//    addressL.text = [NSString stringWithFormat:@"%@%@",model.addr,model.house];
//
//    tagL.text = model.typeName;
//    tagL.backgroundColor = HEX(model.typeColor, 1.0);
//
//}

-(void)setAddr_id:(NSString *)addr_id{
    _addr_id = addr_id;
    if ([_model.addr_id isEqualToString:addr_id]) {
        _imgV.hidden = NO;
    }else{
        _imgV.hidden = YES;
    }
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
//    tagL.backgroundColor = HEX(_model.typeColor, 1.0);
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
//    tagL.backgroundColor = HEX(_model.typeColor, 1.0);
}
@end
