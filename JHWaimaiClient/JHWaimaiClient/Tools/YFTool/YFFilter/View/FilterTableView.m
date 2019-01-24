//
//  FilterTableView.m
//  Lunch
//
//  Created by ios_yangfei on 17/3/21.
//  Copyright © 2017年 jianghu. All rights reserved.
//

#import "FilterTableView.h"
#import "FilterCell.h"
#import "FilterModel.h"
#import "FilterAddressModel.h"

@interface FilterTableView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *leftTalbeView;
@property(nonatomic,strong)UITableView *rightTableView;

@property(nonatomic,assign)NSInteger cacheLeftSelectedIndex;// 选中左边的但不是最后的选择

@end

@implementation FilterTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    self.rightSelectedIndex = -1;
    self.leftSelectedIndex = 0;
    self.cacheLeftSelectedIndex = -1;
    
    UITableView *leftTalbeView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH,self.height) style:UITableViewStylePlain];
    leftTalbeView.delegate=self;
    leftTalbeView.dataSource=self;
    [self addSubview:leftTalbeView];
    leftTalbeView.backgroundColor=[UIColor whiteColor];
    leftTalbeView.showsVerticalScrollIndicator=NO;
    leftTalbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTalbeView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.leftTalbeView=leftTalbeView;
    [leftTalbeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset=WIDTH;
        make.bottom.offset=0;
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTalbeView) {
        return self.leftArr.count;
    }
    return self.rightArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.leftTalbeView == tableView) {
        static NSString *ID=@"leftTalbeView";
        FilterCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[FilterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            if (self.filterType == FilterOneTable) {
                cell.type = 2;
            }else{
                cell.type = 1;
            }
        }
        
        
        NSInteger count = 0;
        if (self.kindType ==0 ) {
            FilterModel *cate = self.leftArr[indexPath.row];
            cell.titleStr = cate.title;
            count = cate.childrens.count;
        }else if (self.kindType == 1){
            FilterAddressModel *area = self.leftArr[indexPath.row];
            cell.titleStr = area.area_name;
            count = area.business.count;
        }else{
            NSString *str = self.leftArr[indexPath.row];
            cell.titleStr = str;
        }
        
        if (self.filterType == FilterOneTable) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = count == 0 ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
        
    }else{
        static NSString *ID=@"rightTableView";
        FilterCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[FilterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.type = 2;
        }
        
        if (self.kindType ==0 ) {
            FilterModel *cate = self.rightArr[indexPath.row];
            cell.titleStr = cate.title;
            
        }else if (self.kindType == 1){
            NSDictionary *dic = self.rightArr[indexPath.row];
            cell.titleStr = dic[@"business_name"];
            
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.filterType == FilterOneTable) {// 一个tableView
        if (self.chooseBlock) {
            self.leftSelectedIndex = indexPath.row;
            self.chooseBlock(self.leftSelectedIndex,-1);
        }
    }else{// 两个tableView
        
        
        if (self.leftTalbeView == tableView) {
            self.cacheLeftSelectedIndex = indexPath.row;
            
            if (self.kindType == 0) {
                FilterModel *cate = self.leftArr[indexPath.row];
                self.rightArr = cate.childrens;
            }else if (self.kindType == 1){
                FilterAddressModel *area = self.leftArr[indexPath.row];
                self.rightArr = area.business;
            }
            
            if (self.rightArr.count == 0) {
                self.rightSelectedIndex = -1;
                [self.rightTableView reloadData];
                self.leftSelectedIndex = self.cacheLeftSelectedIndex;
                self.chooseBlock(self.leftSelectedIndex,-1);
            }else{
                [self.rightTableView reloadData];
                if ( self.rightArr.count != 0 && self.rightSelectedIndex >= 0 && self.cacheLeftSelectedIndex == self.leftSelectedIndex) {
                    [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightSelectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                }
            }
            
        }else{
            self.leftSelectedIndex = self.cacheLeftSelectedIndex == -1 ? self.leftSelectedIndex : self.cacheLeftSelectedIndex;
            self.rightSelectedIndex = indexPath.row;
            self.chooseBlock(self.leftSelectedIndex,self.rightSelectedIndex);
        }
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark ======setter=======
-(void)setFilterType:(YFFilterType)filterType{
    _filterType = filterType;
    if (filterType == FilterTwoTable) {
        self.leftTalbeView.backgroundColor = HEX(@"f4f4f4", 1.0);
        [self.leftTalbeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset = WIDTH*0.45;
        }];
        
        [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=WIDTH*0.45;
            make.top.offset=0;
            make.width.offset=WIDTH*0.55;
            make.bottom.offset=0;
        }];
    }
}

-(UITableView *)rightTableView{
    if (_rightTableView==nil) {
        UITableView *rightTableView=[[UITableView alloc] initWithFrame:FRAME(WIDTH*0.4, 0, WIDTH*0.6,self.height) style:UITableViewStylePlain];
        rightTableView.delegate=self;
        rightTableView.dataSource=self;
        rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:rightTableView];
        rightTableView.backgroundColor=[UIColor whiteColor];
        rightTableView.showsVerticalScrollIndicator=NO;
        rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightTableView=rightTableView;
    }
    return _rightTableView;
}

-(void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
    [self layoutSubviews];
}

-(void)reloadView{
    
    [self.leftTalbeView reloadData];
    if (self.leftSelectedIndex >= 0) {
        [self.leftTalbeView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.leftSelectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        if (self.kindType == 0) {
            FilterModel *cate = self.leftArr[self.leftSelectedIndex];
            self.rightArr = cate.childrens;
        }else if (self.kindType == 1){
            FilterAddressModel *area = self.leftArr[self.leftSelectedIndex];
            self.rightArr = area.business;
        }
    }
    
    if (self.filterType == FilterTwoTable) {
        [self.rightTableView reloadData];
        if ( self.rightArr.count != 0 && self.rightSelectedIndex >= 0) {
            [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightSelectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        if (self.rightSelectedIndex < 0 && self.rightArr.count == 0) {
            self.rightArr = @[];
            [self.rightTableView reloadData];
        }
        
    }
}

-(void)setFirstShowSelectedIndex:(NSInteger)firstShowSelectedIndex{
    self.leftSelectedIndex = firstShowSelectedIndex;
    [self.leftTalbeView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.leftSelectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.leftTalbeView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.leftSelectedIndex inSection:0]];
}

@end
