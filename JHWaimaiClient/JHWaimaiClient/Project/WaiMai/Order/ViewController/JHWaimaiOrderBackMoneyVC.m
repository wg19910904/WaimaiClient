//
//  JHWaimaiOrderBackMoneyVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/27.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderBackMoneyVC.h"
#import  <IQKeyboardManager.h>
#import "JHWaimaiOrderBackMoneyPhoneCell.h"
#import "JHWaimaiBackMoneywriteCell.h"
#import "JHWaiMaiOrderViewModel.h"
@interface JHWaimaiOrderBackMoneyVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)UITableView *myTableView;//创建表视图的方法
@property(nonatomic,strong)UITextView *textV;//输入框
@end

@implementation JHWaimaiOrderBackMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //创建表视图的方法
    [self myTableView];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"申请退款", nil);
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(15, NAVI_HEIGHT, WIDTH-30, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.rowHeight = UITableViewAutomaticDimension;
            table.estimatedRowHeight = 100;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = BACK_COLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            table;
        });
    }
    return _myTableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setTitle:NSLocalizedString(@"提交申请", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = FONT(16);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = HEX(@"20ad20", 1);
    [submitBtn addTarget:self action:@selector(clickBackMoney) forControlEvents:UIControlEventTouchUpInside];
    return submitBtn;
}
#pragma mark - 点击申请退款的方法
-(void)clickBackMoney{
    if ([_textV.text isEqualToString:NSLocalizedString(@"请输入申请理由", nil)] || _textV.text.length == 0) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入退款理由", nil)];
        return;
    }
    SHOW_HUD
    [JHWaiMaiOrderViewModel postToPayBackWithDic:@{@"order_id":self.order_id,@"reason":_textV.text} block:^(NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *str = @"JHWaimaiOrderBackMoneyPhoneCell";
        JHWaimaiOrderBackMoneyPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderBackMoneyPhoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.superVC = self;
        cell.phoneLabel.text = _mobile;
        return cell;
    }else{
        static NSString *str = @"JHWaimaiBackMoneywriteCell";
        JHWaimaiBackMoneywriteCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiBackMoneywriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.textView.delegate = self;
        _textV = cell.textView;
        return cell;
    }
}
#pragma mark - 这是UITextField的代理方法
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [IQKeyboardManager sharedManager].enable = YES;
    if ([textView.text isEqualToString:NSLocalizedString(@"请输入申请理由", nil)]) {
        textView.text = @"";
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = NSLocalizedString(@"请输入申请理由", nil);
    }
}
#pragma mark - 滑动表的时候让键盘下落
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
#pragma mark - 这是表结束减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是表开始拖动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
@end
