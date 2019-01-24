//
//  JHWaimaiOrderDetailComplaintVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailComplaintVC.h"
#import "JHWaimaiOrderDetailDefaultCell.h"
#import "JHWaimaiOrderDetailWriteCell.h"
#import <IQKeyboardManager.h>
#import "JHWaimaiOrderDetailSubmitImageCell.h"
#import "JHWaiMaiOrderViewModel.h"
@interface JHWaimaiOrderDetailComplaintVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic,strong)UITableView *myTableView;//创建表视图的方法
@property(nonatomic,strong)NSMutableArray * modelArr;//存选取的图片的模型数组
@property(nonatomic,strong)UITextView *textV;//输入框
@end

@implementation JHWaimaiOrderDetailComplaintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //创建表视图的方法
    [self myTableView];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
     _modelArr = @[].mutableCopy;
    if (_staff_id) {
         self.navigationItem.title = NSLocalizedString(@"投诉配送员", nil);
    }else{
        self.navigationItem.title = NSLocalizedString(@"投诉商家", nil);
    }
   
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(10, NAVI_HEIGHT + 15, WIDTH-20, HEIGHT - (NAVI_HEIGHT + 15)) style:UITableViewStyleGrouped];
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
    return 3;
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
    [submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = FONT(16);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = HEX(@"20ad20", 1);
    [submitBtn addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
    return submitBtn;
}
-(void)clickSubmit{
    if (_textV.text.length == 0 || [_textV.text isEqualToString:NSLocalizedString(@"请输入投诉内容,客服会尽快和您联系,请耐心等待", nil)]) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请输入投诉商家的理由!", nil)];
        return;
    }
    NSMutableDictionary *photoDic = @{}.mutableCopy;
    for (int i = 0;i<_modelArr.count;i++) {
        ZQImageModel *model = _modelArr[i];
        NSString *key = [NSString stringWithFormat:@"photo%d",i];
        NSDictionary *dic = @{key:model.data};
        [photoDic addEntriesFromDictionary:dic];
    }
    SHOW_HUD
    [JHWaiMaiOrderViewModel postToComplaintOrderWithDic:@{@"order_id":self.order_id,@"content":self.textV.text,@"shop_id":_shop_id?_shop_id:@"0",@"staff_id":_staff_id?_staff_id:@"0"} imageDic:photoDic block:^(NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已经成功投诉!", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *str = @"JHWaimaiOrderDetailDefaultCell";
        JHWaimaiOrderDetailDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderDetailDefaultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.isHidden = YES;
        cell.leftTitle = [NSLocalizedString(@"联系电话   ", nil) stringByAppendingString:_mobile];
        cell.leftLabel.textColor = HEX(@"333333", 1);
        cell.leftLabel.font = FONT(14);
        return cell;
 
    }else if (indexPath.row == 1){
        static NSString *str = @"JHWaimaiOrderDetailWriteCell";
        JHWaimaiOrderDetailWriteCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderDetailWriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.textView.delegate = self;
        _textV = cell.textView;
        return cell;

    }else{
        static NSString *str = @"JHWaimaiOrderDetailSubmitImageCell";
        JHWaimaiOrderDetailSubmitImageCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderDetailSubmitImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.modelArr = _modelArr;
        cell.superVC = self;
        __weak typeof (self)weakSelf = self;
        [cell setRemoveBlock:^(NSInteger index){
            [weakSelf.modelArr removeObjectAtIndex:index];
             [_myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return cell;

    }
}
-(void)choseImageArr:(NSArray *)modelArr{
    NSLog(@"%@",modelArr);
    [_modelArr addObjectsFromArray:modelArr];
    [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 这是UITextField的代理方法
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [IQKeyboardManager sharedManager].enable = YES;
    if ([textView.text isEqualToString:NSLocalizedString(@"请输入投诉内容,客服会尽快和您联系,请耐心等待", nil)]) {
        textView.text = @"";
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = NSLocalizedString(@"请输入投诉内容,客服会尽快和您联系,请耐心等待", nil);
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
