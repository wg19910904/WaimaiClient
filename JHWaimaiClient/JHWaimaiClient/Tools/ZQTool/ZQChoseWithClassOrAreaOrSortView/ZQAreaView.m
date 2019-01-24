//
//  ZQAreaView.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/8.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "ZQAreaView.h"
#import "ZQConditionCell.h"
#import "ZQConditonModel.h"
#import "ZQSaveSelecter.h"
#define CURRENT_SCALE 160/375
@interface ZQAreaView()<UITableViewDelegate,UITableViewDataSource>{
    ZQConditonModel *oldModel;
    ZQConditonModel *subOldModel;
}
@property(nonatomic,strong)UITableView *leftTab;
@property(nonatomic,strong)UITableView *rightTab;
@property(nonatomic,strong)UITableView *myTab;
@end
@implementation ZQAreaView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self leftTab];
        [self rightTab];
        [self myTab];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self leftTab];
        [self rightTab];
        [self myTab];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (_isShangCheng) {
        _myTab.frame = FRAME(0, 0, WIDTH, frame.size.height);
    }else{
        _leftTab.frame = FRAME(0, 0, WIDTH*CURRENT_SCALE, frame.size.height);
        
        _rightTab.frame = FRAME(WIDTH*CURRENT_SCALE, 0, (WIDTH - WIDTH*CURRENT_SCALE), frame.size.height);
    }
   
}
#pragma mark - 创建左边的表
-(UITableView *)leftTab{
    if (!_leftTab) {
        _leftTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH*CURRENT_SCALE, 0) style:UITableViewStylePlain];
        _leftTab.delegate = self;
        _leftTab.dataSource = self;
        _leftTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTab.backgroundColor = HEX(@"f4f4f4", 1);
        _leftTab.showsVerticalScrollIndicator = NO;
        [self addSubview:_leftTab];
    }
    return _leftTab;
}
#pragma mark - 右边的表
-(UITableView *)rightTab{
    if (!_rightTab) {
        _rightTab = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH*CURRENT_SCALE, 0, (WIDTH - WIDTH*CURRENT_SCALE), 0) style:UITableViewStylePlain];
        _rightTab.delegate = self;
        _rightTab.dataSource = self;
        _rightTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTab.backgroundColor = [UIColor whiteColor];
        _rightTab.showsVerticalScrollIndicator = NO;
        [self addSubview:_rightTab];
    }
    return _rightTab;
}
#pragma mark - myTab
-(UITableView *)myTab{
    if (!_myTab) {
        _myTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0) style:UITableViewStylePlain];
        _myTab.delegate = self;
        _myTab.dataSource = self;
        _myTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTab.backgroundColor = [UIColor whiteColor];
        _myTab.showsVerticalScrollIndicator = NO;
        [self addSubview:_myTab];
    }
    return _myTab;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isShangCheng) {
        return _dataArr.count;
    }else{
        if (tableView == _rightTab) {
            return oldModel.subArr.count;
        }
        return _dataArr.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isShangCheng) {
        static NSString *str = @"areaSubCell";
        ZQConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[ZQConditionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        ZQConditonModel *model = _dataArr[indexPath.row];
        cell.text = model.title;
        cell.isSelector = model.isSelector;
        if (model.isSelector) {
            subOldModel = model;
        }
        return cell;
    }else{
        
        if (tableView == _rightTab) {
            static NSString *str = @"areaSubCell";
            ZQConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[ZQConditionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            ZQConditonModel *model = oldModel.subArr[indexPath.row];
            cell.text = model.title;
            cell.isSelector = model.isSelector;
            if (model.isSelector) {
                subOldModel = model;
            }
            return cell;
        }
        static NSString *str = @"areaCell";
        ZQConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[ZQConditionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.isArea = YES;
        ZQConditonModel *model = _dataArr[indexPath.row];
        cell.text = model.title;
        cell.isSelector = model.isSelector;
        if (model.isSelector) {
            oldModel = model;
        }
        if (model.subArr.count == 0 || !model.subArr) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (model.isSelector) {
                [_rightTab reloadData];
            }
        }
        return cell;
 
    }
    
   }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isShangCheng) {
        subOldModel.isSelector = NO;
        ZQConditonModel *model = _dataArr[indexPath.row];
        model.isSelector = YES;
        subOldModel = model;
        [_rightTab reloadData];
        [ZQSaveSelecter saveModel].isArea = YES;
        [ZQSaveSelecter saveModel].isAreaSub = YES;
        [ZQSaveSelecter saveModel].areaIndexP = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        if (self.removeBlock) {
            self.removeBlock();
        }

    }else{
        
        if (tableView == _leftTab) {
            oldModel.isSelector = NO;
            ZQConditonModel *model = _dataArr[indexPath.row];
            model.isSelector = YES;
            [_leftTab reloadData];
            oldModel = model;
            if (!model.subArr||model.subArr.count == 0) {
                [ZQSaveSelecter saveModel].isArea = YES;
                [ZQSaveSelecter saveModel].areaIndexP = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
                if (self.removeBlock) {
                    self.removeBlock();
                }
            }else{
                [_rightTab reloadData];
            }
        }else{
            subOldModel.isSelector = NO;
            ZQConditonModel *model = oldModel.subArr[indexPath.row];
            model.isSelector = YES;
            subOldModel = model;
            [_rightTab reloadData];
            [ZQSaveSelecter saveModel].isArea = YES;
            [ZQSaveSelecter saveModel].isAreaSub = YES;
            NSInteger sec = [_dataArr indexOfObject:oldModel];
            [ZQSaveSelecter saveModel].areaIndexP = [NSIndexPath indexPathForRow:indexPath.row inSection:sec];
            if (self.removeBlock) {
                self.removeBlock();
            }
        }

    }
}
@end
