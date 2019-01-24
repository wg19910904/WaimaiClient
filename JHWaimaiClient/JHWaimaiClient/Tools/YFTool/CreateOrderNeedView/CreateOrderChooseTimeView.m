//
//  CreateOrderChooseTimeView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "CreateOrderChooseTimeView.h"
#import "CreateOrderChooseTimeCell.h"

@interface CreateOrderChooseTimeView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *leftTalbeView;
@property(nonatomic,weak)UITableView *rightTableView;

@property(nonatomic,assign)NSInteger cacheLeftSelectedIndex;// 选中左边的但不是最后的选择

@property(nonatomic,assign)NSInteger leftSelectedIndex;
@property(nonatomic,assign)NSInteger rightSelectedIndex;

@property(nonatomic,strong)NSArray *rightArr;
@end

@implementation CreateOrderChooseTimeView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
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
    
    self.rightSelectedIndex = 0;
    self.leftSelectedIndex = 0;
    
    UITableView *leftTalbeView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH,self.height) style:UITableViewStylePlain];
    leftTalbeView.delegate=self;
    leftTalbeView.dataSource=self;
    [self addSubview:leftTalbeView];
    leftTalbeView.scrollEnabled = NO;
    leftTalbeView.backgroundColor=[UIColor whiteColor];
    leftTalbeView.showsVerticalScrollIndicator=NO;
    leftTalbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTalbeView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.leftTalbeView=leftTalbeView;
    [leftTalbeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset = WIDTH*0.35;
        make.bottom.offset=0;
    }];
    
    UITableView *rightTableView=[[UITableView alloc] initWithFrame:FRAME(WIDTH*0.4, 0, WIDTH*0.6,self.height) style:UITableViewStylePlain];
    rightTableView.delegate=self;
    rightTableView.dataSource=self;
//    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:rightTableView];
    rightTableView.backgroundColor=[UIColor whiteColor];
    rightTableView.showsVerticalScrollIndicator=NO;
    rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.rightTableView=rightTableView;
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=WIDTH*0.35;
        make.top.offset=0;
        make.width.offset=WIDTH*0.65;
        make.bottom.offset=0;
    }];
    
    self.leftTalbeView.backgroundColor = HEX(@"f4f4f4", 1.0);
    
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.rightTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.rightTableView setSeparatorInset:UIEdgeInsetsZero];
        [self.rightTableView setSeparatorColor:LINE_COLOR];
    }
    
    if ([self.rightTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.rightTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
        CreateOrderChooseTimeCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[CreateOrderChooseTimeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.type = 1;
            
        }

        NSDictionary *dic = self.leftArr[indexPath.row];
        cell.titleStr = dic[@"day"];
        cell.accessoryType = UITableViewCellAccessoryNone;

        return cell;
        
    }else{
        static NSString *ID=@"rightTableView";
        CreateOrderChooseTimeCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[CreateOrderChooseTimeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.type = 2;
        }

        NSString *str= self.rightArr[indexPath.row];
        cell.titleStr = str;

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.leftTalbeView == tableView) {
        self.cacheLeftSelectedIndex = indexPath.row;
        self.rightArr = self.leftArr[indexPath.row][@"times"];
        [self.rightTableView reloadData];
        
        if ( self.rightArr.count != 0 && self.rightSelectedIndex >= 0 && self.cacheLeftSelectedIndex == self.leftSelectedIndex) {
            [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightSelectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }

    }else{
        self.leftSelectedIndex = self.cacheLeftSelectedIndex;
        self.rightSelectedIndex = indexPath.row;
        
        NSDictionary *dic = self.leftArr[_leftSelectedIndex];
        NSString *str = [NSString stringWithFormat:@"%@ %@",dic[@"date"],self.rightArr[_rightSelectedIndex]];
        if ([dic[@"day"] containsString: NSLocalizedString(@"今天", NSStringFromClass([self class]))]) {
            str = [NSString stringWithFormat:@"%@,%@",str,self.rightArr[_rightSelectedIndex]];
        }else{
            str = [NSString stringWithFormat:@"%@,%@ %@",str,dic[@"day"],self.rightArr[_rightSelectedIndex]];
        }
    self.chooseBlock(self.leftSelectedIndex,self.rightSelectedIndex,str);
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark ====== Functions =======
-(void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
    [self layoutSubviews];
}

-(void)reloadView{
    
    self.rightArr = self.leftArr[self.leftSelectedIndex][@"times"];
    self.leftTalbeView.scrollEnabled = self.leftArr.count > 6;
    [self.leftTalbeView reloadData];
    [self.rightTableView reloadData];

    if (self.leftArr.count !=0 ) {
        [self.leftTalbeView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.leftSelectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
    if (self.rightArr.count !=0 ) {
        [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightSelectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.rightTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightSelectedIndex inSection:0]];
    }
}

@end
