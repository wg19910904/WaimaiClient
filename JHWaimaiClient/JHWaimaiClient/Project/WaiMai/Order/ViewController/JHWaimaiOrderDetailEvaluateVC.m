//
//  JHWaimaiOrderDetailEvaluateVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/1.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWaimaiOrderDetailEvaluateVC.h"
#import "JHWaimaiOrderEvaluateHeaderCell.h"
#import <IQKeyboardManager.h>
#import "JHWaimaiOrderEvaluateGoodsScoreCell.h"
#import "JHWaimaiOrderEvaluatePeiSCell.h"
#import "JHWaimaiOrderDetailEvaluateChoseTimeView.h"
#import "JHWaimaiOrderEvaluateSubmitImageCell.h"
#import "JHWaiMaiOrderViewModel.h"
#import "YFTypeBtn.h"

@interface JHWaimaiOrderDetailEvaluateVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    NSInteger index_minute;
}
@property(nonatomic,strong)UITableView *myTableView;//创建的表视图
@property(nonatomic,strong)UILabel *bottomLab;//底部的label
@property(nonatomic,strong)UIButton *bottomBtn;//底部的按钮
@property(nonatomic,strong)NSMutableArray * modelArr;//存选取的图片的模型数组
@property(nonatomic,copy)NSString *timeL;
@property(nonatomic,strong)UITextView *textV;
@property(nonatomic,strong)YFStartView *starView;//可以用来评价的星星
@property(nonatomic,strong)YFStartView *pei_starView;//配送评分评价的星星
@property(nonatomic,weak)YFTypeBtn *noNameBtn;// 匿名评价
@end

@implementation JHWaimaiOrderDetailEvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加表视图
    [self myTableView];
    //底部的label
    [self bottomLab];
    //底部的按钮
    [self bottomBtn];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    _modelArr = @[].mutableCopy;
    self.navigationItem.title = NSLocalizedString(@"评价", nil);
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT - VC_TABBAR_HEIGHT) style:UITableViewStylePlain];
            table.rowHeight = UITableViewAutomaticDimension;
            table.estimatedRowHeight = 100;
            table.delegate = self;
            table.dataSource = self;
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
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isziti) {
        return 3;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_isziti && section == 2) {
         return CGFLOAT_MIN;
    }else{
        if (section == 3) {
            return CGFLOAT_MIN;
        }
        return 10;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *str = @"JHWaimaiOrderEvaluateHeaderCell";
        JHWaimaiOrderEvaluateHeaderCell *cell  = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderEvaluateHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            YFTypeBtn *noNameBtn = [YFTypeBtn new];
            [cell addSubview:noNameBtn];
            [noNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-15);
                make.top.offset(20);
                make.height.offset(40);
            }];
            [noNameBtn setImage:IMAGE(@"pj_selecter") forState:UIControlStateNormal];
            [noNameBtn setImage:IMAGE(@"pj_selecter_checked") forState:UIControlStateSelected];
            [noNameBtn setTitle: NSLocalizedString(@"匿名评价", NSStringFromClass([self class])) forState:UIControlStateNormal];
            [noNameBtn setTitleColor:HEX(@"999999", 1.0) forState:UIControlStateNormal];
            noNameBtn.btnType = LeftImage;
            noNameBtn.titleMargin = 5;
            noNameBtn.titleLabel.font = FONT(14);
            [noNameBtn addTarget:self action:@selector(clickNoNameBtn:) forControlEvents:UIControlEventTouchUpInside];
            self.noNameBtn = noNameBtn;
            
        }
        cell.imgUrl = [IMAGEADDRESS stringByAppendingString:self.shopImg];
        cell.shopName = self.shopName;
        cell.textView.delegate = self;
        _textV = cell.textView;
        _starView = cell.starView;
        return cell;

    }else if (indexPath.section == 1){
        static NSString *str = @"JHWaimaiOrderEvaluateGoodsScoreCell";
        JHWaimaiOrderEvaluateGoodsScoreCell *cell  = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderEvaluateGoodsScoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.arr = self.productsArr;
        return cell;

    }else if(indexPath.section == 2){
        if (_isziti) {
            static NSString *str = @"JHWaimaiOrderEvaluateSubmitImageCell";
            JHWaimaiOrderEvaluateSubmitImageCell *cell  = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaimaiOrderEvaluateSubmitImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.modelArr = _modelArr;
            cell.superVC = self;
            __weak typeof (self)weakSelf = self;
            [cell setRemoveBlock:^(NSInteger index){
                [weakSelf.modelArr removeObjectAtIndex:index];
                [_myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }];
            return cell;

        }else{
            static NSString *str = @"JHWaimaiOrderEvaluatePeiSCell";
            JHWaimaiOrderEvaluatePeiSCell *cell  = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[JHWaimaiOrderEvaluatePeiSCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.str = _timeL?_timeL:[NSString stringWithFormat:NSLocalizedString(@"%@分钟(%@送达)", nil),_timeArr[0][@"minute"],_timeArr[0][@"date"]];
            _pei_starView = cell.starView;
            __weak typeof (self)weakSelf = self;
            [cell setMyBlock:^{
                [weakSelf chosetime];
            }];
            return cell;
            
 
        }
    }else{
        static NSString *str = @"JHWaimaiOrderEvaluateSubmitImageCell";
        JHWaimaiOrderEvaluateSubmitImageCell *cell  = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHWaimaiOrderEvaluateSubmitImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.modelArr = _modelArr;
        cell.superVC = self;
        __weak typeof (self)weakSelf = self;
        [cell setRemoveBlock:^(NSInteger index){
            [weakSelf.modelArr removeObjectAtIndex:index];
            [_myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return cell;
    }
    
}
#pragma mark - 创建的是获得积分的label
-(UILabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [[UILabel alloc]init];
        _bottomLab.backgroundColor = [UIColor whiteColor];
        _bottomLab.textColor= HEX(@"222222", 1);
        _bottomLab.font = FONT(14);
        [self.view addSubview:_bottomLab];
        [_bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset= 0;
            make.height.offset = 49;
            make.bottom.offset = - SYSTEM_GESTURE_HEIGHT;
        }];
    }
    return _bottomLab;
}
#pragma mark - 这是点击发表评价的按钮
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc]init];
        _bottomBtn.backgroundColor = THEME_COLOR_Alpha(1);
        [_bottomBtn setTitle:NSLocalizedString(@"发表评价", nil) forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:HEX(@"ffffff", 1) forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = FONT(14);
        [self.view addSubview:_bottomBtn];
        [_bottomBtn addTarget:self action:@selector(clickSendEvaluate) forControlEvents:UIControlEventTouchUpInside];
        _bottomLab.text = [NSString stringWithFormat:NSLocalizedString(@"   评价后获得%@积分", nil),_jifenNum];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:_bottomLab.text];
        [attribute addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR_Alpha(1)} range:[_bottomLab.text rangeOfString:_jifenNum]];
        _bottomLab.attributedText = attribute;
        [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = 0;
            make.bottom.offset = - SYSTEM_GESTURE_HEIGHT;
            make.height.offset = 49;
            make.width.offset = 114;
        }];
    }
    return _bottomBtn;
}
-(void)choseImageArr:(NSArray *)modelArr{
    NSLog(@"%@",modelArr);
    [_modelArr addObjectsFromArray:modelArr];
    [_myTableView reloadSections:[NSIndexSet indexSetWithIndex:_isziti?2:3] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 点击是发送评价的方法
-(void)clickSendEvaluate{
    if (_starView.currentStarScore == 0) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请对商家星级进行点评!", nil)];
        return;
    }

//    if ([_textV.text isEqualToString:NSLocalizedString(@"写下您对商家的建议吧~", nil)] || _textV.text.length == 0) {
//        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请先输入您对商家的评价!", nil)];
//        return;
//    }
    NSString *str = _textV.text;
    if ([_textV.text isEqualToString:NSLocalizedString(@"写下您对商家的建议吧~", nil)] || _textV.text.length == 0) {
       str = @"";
    }
    if (_pei_starView.currentStarScore == 0 && !_isziti) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"请对配送服务星级进行点评!", nil)];
        return;
    }
    JHWaimaiOrderEvaluateGoodsScoreCell *cell = [_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSDictionary * dic = @{@"order_id":self.order_id,
                           @"content":str,
                           @"score_peisong":[NSString stringWithFormat:@"%.f",_pei_starView.currentStarScore],
                           @"score":[NSString stringWithFormat:@"%.f",_starView.currentStarScore],
                           @"is_anonymous":@(self.noNameBtn.isSelected ? 1 : 0),
                           @"pei_time":_timeL?_timeArr[index_minute][@"minute"]:_timeArr[0][@"minute"],
                           @"info":[cell getEvaluateArr]};
    NSMutableDictionary *photoDic = @{}.mutableCopy;
    for (int i = 0;i<_modelArr.count;i++) {
        ZQImageModel *model = _modelArr[i];
        NSString *key = [NSString stringWithFormat:@"photo%d",i];
        NSDictionary *dic = @{key:model.data};
        [photoDic addEntriesFromDictionary:dic];
    }
    SHOW_HUD
    [JHWaiMaiOrderViewModel postToEvaluateOrderWithDic:dic imageDic:photoDic block:^(NSString *err) {
        HIDE_HUD
        if (err) {
            [self showToastAlertMessageWithTitle:err];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已成功评价!", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark - 这是点击选择时间
-(void)chosetime{
    JHWaimaiOrderDetailEvaluateChoseTimeView *timeView = [[JHWaimaiOrderDetailEvaluateChoseTimeView alloc]init];
    timeView.timeArr = self.timeArr;
    [timeView setMyBlock:^(NSString *str,NSInteger index){
        _timeL = str;
        index_minute = index;
        NSInteger num =  _pei_starView.currentStarScore;
        [_myTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (num != _pei_starView.currentStarScore) {
            _pei_starView.currentStarScore = num;
        }
    }];
    [timeView showView];
}

// 点击匿名评价
-(void)clickNoNameBtn:(UIButton *)btn{
    btn.selected = !btn.isSelected;
}

#pragma mark - 这是UITextField的代理方法
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [IQKeyboardManager sharedManager].enable = YES;
    if ([textView.text isEqualToString:NSLocalizedString(@"写下您对商家的建议吧~", nil)]) {
        textView.text = @"";
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = NSLocalizedString(@"写下您对商家的建议吧~", nil);
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
