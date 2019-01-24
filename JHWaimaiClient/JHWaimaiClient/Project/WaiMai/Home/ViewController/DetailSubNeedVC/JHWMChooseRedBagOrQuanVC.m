//
//  JHWMChooseRedBagOrQuanVC.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/11/20.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWMChooseRedBagOrQuanVC.h"
#import "ChooseRedBagOrQuanCell.h"

@interface JHWMChooseRedBagOrQuanVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIButton *no_use_btn;
@end

@implementation JHWMChooseRedBagOrQuanVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
    self.navigationItem.title = self.is_redbag ?  NSLocalizedString(@"选择红包", NSStringFromClass([self class])) : NSLocalizedString(@"选择优惠劵", NSStringFromClass([self class]));
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSInteger index = 0;
    for (NSDictionary *dic in self.dataSource) {
        NSString *_id = self.is_redbag ? dic[@"hongbao_id"] : dic[@"coupon_id"];
        if ([_id isEqualToString:self.chooesed_id]) {
           index = [self.dataSource indexOfObject:dic];
            ++index;
            break;
        }
    }
    if (index == 0) {
        self.no_use_btn.selected = YES;
    }else{
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
    }
}

-(void)setUpView{
    self.view.backgroundColor = BACK_COLOR;
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(10, NAVI_HEIGHT, WIDTH-20, HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = BACK_COLOR;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    self.tableView=tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *ID=@"JHWMChooseRedBagOrQuanVC_secion_0";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.font = FONT(16);
            cell.textLabel.textColor = HEX(@"666666", 1.0);
            cell.textLabel.text = self.is_redbag ? NSLocalizedString(@"不使用红包", NSStringFromClass([self class])) : NSLocalizedString(@"不使用优惠劵", NSStringFromClass([self class]));
            
            cell.contentView.layer.borderColor=HEX(@"999999", 0.5).CGColor;
            cell.contentView.layer.borderWidth=0.5;
            
            UIButton *chooseBtn = [UIButton new];
            [cell.contentView addSubview:chooseBtn];
            [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.offset(0);
                make.width.offset(40);
                make.height.offset(40);
            }];
            chooseBtn.userInteractionEnabled = NO;
            [chooseBtn setImage:IMAGE(@"index_selector_disable") forState:UIControlStateNormal];
            [chooseBtn setImage:IMAGE(@"index_selector_enable") forState:UIControlStateSelected];
            self.no_use_btn = chooseBtn;
        }
         return cell;
    }else{
        ChooseRedBagOrQuanCell *cell = [ChooseRedBagOrQuanCell initWithTableView:tableView reuseIdentifier:@"ChooseRedBagOrQuanCell"];
        NSDictionary *dic = self.dataSource[indexPath.section - 1];
        [cell reloadCellWithModel:dic is_redbag:self.is_redbag];
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 0) { // 判断是否可用
        NSDictionary *dic = self.dataSource[indexPath.section - 1];
        if (![dic[@"is_canuse"] boolValue]) return;
    }
    
    self.no_use_btn.selected = indexPath.section == 0;
    YF_SAFE_BLOCK(self.clickIndexBlock,indexPath.section,nil);
    [self.navigationController popViewControllerAnimated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


@end
