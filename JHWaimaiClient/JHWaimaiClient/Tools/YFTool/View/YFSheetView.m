//
//  YFSheetView.m
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "YFSheetView.h"
#import "AppDelegate.h"

@interface YFSheetView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,assign)NSInteger sectionNum;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *cancelStr;
@property(nonatomic,assign)CGFloat tabH;
@end

@implementation YFSheetView


-(YFSheetView *)initWithTitle:(NSString *)title delegate:(id<YFSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles{

    self = [[YFSheetView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT)];
    self.delegate=delegate;
    
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    [control addTarget:self action:@selector(sheetHidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    self.control=control;
    
    self.sectionNum=1;
    
    self.tabH=40*otherButtonTitles.count;
    if (title && title.length!=0) {
        self.tabH += 50;
        self.sectionNum++;
        self.titleStr=title;
    }
    if(cancelButtonTitle && cancelButtonTitle.length !=0){
        self.tabH += 50;
        self.sectionNum++;
        self.cancelStr=cancelButtonTitle;
    }
    
    self.titleArr=otherButtonTitles;
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, HEIGHT+10, WIDTH-20, self.tabH) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [control addSubview:tableView];
    tableView.scrollEnabled=NO;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.showsVerticalScrollIndicator=NO;
    self.tableView=tableView;

    return self;
}

#pragma mark =========补齐UITableViewCell分割线========
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
        [self.tableView setSeparatorColor:HEX(@"e6e6e6", 1.0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.titleArr.count-1) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    
    if (indexPath.row==0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
   
    
    NSInteger section=1;
    if (self.titleStr && self.titleStr.length>0) {
       section=2;
        if (indexPath.section==0) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
    }
    
    if (indexPath.section==section) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
   
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.sectionNum;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0 ) {
        if (self.titleStr.length>0) return 1;
        else return self.titleArr.count;
    }else if(section==1){
        if (self.titleStr.length>0) return self.titleArr.count;
        else if (self.cancelStr.length>0) return 1;
        else return 0;
    }else{
        if (self.cancelStr.length>0) return 1;
        else return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"YFActionSheet";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UILabel *lab=[UILabel new];
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.centerY.offset=0;
            make.width.offset=WIDTH-20;
            make.height.offset=40;
        }];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.textColor=self.textColor;
        lab.font=FONT(16);
        lab.tag=100;
    }
    UILabel *titleLab=(UILabel *)[cell viewWithTag:100];
    NSString *str;
    if (indexPath.section==0 ) {
        if (self.titleStr.length>0) str=self.titleStr;
        else str=self.titleArr[indexPath.row];
    }else if(indexPath.section==1){
        if (self.titleStr.length>0) str=self.titleArr[indexPath.row];
        else if (self.cancelStr.length>0) str=self.cancelStr;
    }else{
        if (self.cancelStr.length>0) str=self.cancelStr;
    }
    
    if ([str isEqualToString:self.cancelStr])  titleLab.textColor=self.cancelColor;
    
    titleLab.text=str;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight == 0 ? 40 : self.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.delegate) return;
    if (self.titleStr.length>0 && indexPath.section==0) return;
    
    [self sheetHidden];
    if (indexPath.section==0 ) {
        if([self.delegate respondsToSelector:@selector(sheetClickButtonIndex:)]){
            [self.delegate sheetClickButtonIndex:indexPath.row];
        }
    }else if(indexPath.section==1){
        if (self.titleStr.length>0)  {
            if([self.delegate respondsToSelector:@selector(sheetClickButtonIndex:)]){
                [self.delegate sheetClickButtonIndex:indexPath.row];
            }
        }
    }
}


-(void)sheetShow{
   
   AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.control];
    self.control.alpha=1;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y=HEIGHT-self.tabH-10;
        [self.tableView reloadData];
    }];
}

-(void)sheetHidden{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y=HEIGHT+10;
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
         self.control.alpha=0;
    }];
    [self removeFromSuperview];
    
}

-(UIColor *)textColor{
    if (!_textColor) {
        _textColor=HEX(@"333333", 1.0);
    }
    return _textColor;
}

-(UIColor *)cancelColor{
    if (!_cancelColor) {
        _cancelColor=HEX(@"868686", 1.0);
    }
    return _cancelColor;
}

-(void)setCellHeight:(float)cellHeight{
    _cellHeight = cellHeight;
    self.tabH = cellHeight * self.titleArr.count+10;
    if (self.titleStr.length !=0) {
        self.tabH += cellHeight+10;
    }
    if(self.cancelStr.length !=0){
        self.tabH += cellHeight+10;
    }
    self.tableView.height = self.tabH;
}

@end
