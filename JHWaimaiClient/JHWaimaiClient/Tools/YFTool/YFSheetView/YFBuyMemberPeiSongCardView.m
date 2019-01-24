//
//  YFBuyMemberPeiSongCardView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2018/7/30.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFBaseTableViewCell.h"
#import "NSString+Tool.h"

@interface CardCell : YFBaseTableViewCell
@property(nonatomic,assign)NSString *card_id;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIButton *selecteBtn;
@property(nonatomic,weak)UILabel *desLab;
@property(nonatomic,weak)UILabel *moneyLab;
@property(nonatomic,assign)BOOL is_buy;

-(void)reloadCellWith:(NSDictionary *)cardInfo;
@end

@implementation CardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(15);
        make.height.offset(20);
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;
    
    UILabel *desLab = [UILabel new];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(titleLab.mas_bottom).offset(4);
        make.height.offset(20);
    }];
    desLab.font = FONT(14);
    desLab.textColor = HEX(@"999999", 1.0);
    self.desLab = desLab;
    
    UILabel *moneyLab = [UILabel new];
    [self.contentView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(desLab.mas_bottom).offset(4);
        make.height.offset(20);
        make.bottom.offset(-15);
    }];
    moneyLab.font = FONT(14);
    moneyLab.textColor = HEX(@"999999", 1.0);
    self.moneyLab = moneyLab;
 
    UIButton *selecteBtn = [UIButton new];
    [self.contentView addSubview:selecteBtn];
    [selecteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.offset(0);
        make.width.offset(24);
        make.height.offset(24);
    }];
    selecteBtn.userInteractionEnabled = NO;
    [selecteBtn setImage:IMAGE(@"btn_radio") forState:UIControlStateNormal];
    [selecteBtn setImage:IMAGE(@"btn_radio_selected") forState:UIControlStateSelected];
    self.selecteBtn = selecteBtn;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=-1;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.backgroundColor=BACK_COLOR;
}


/*  购买过的会员卡
 "cid": "1",
 "card_id": "1",
 "uid": "4",
 "title": "30天卡",
 "ltime": "1535375203",
 "limits": "5",
 "reduce": "1.00",
 "dateline": "1532783203"
 */
/*  可以购买的会员卡
 "card_id": "5",
 "title": "60天卡",
 "days": "60",      会员卡有效期限
 "amount": "60.00", 会员卡购买金额
 "limits": "2",     单日可使用次数
 "reduce": "1.00",  每单可减免金额
 */
-(void)reloadCellWith:(NSDictionary *)cardInfo{
    if (_is_buy) {
        self.titleLab.text = cardInfo[@"title"];
        NSString *str = [NSString stringWithFormat: NSLocalizedString(@"今日可减免配送单数: %@单", NSStringFromClass([self class])),cardInfo[@"limits"]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttribute:NSForegroundColorAttributeName value:HEX(@"FA4C34", 1.0) range:NSMakeRange(10, str.length-10)];
        self.desLab.attributedText = attStr;
        
        NSString *str2 = [NSString stringWithFormat: NSLocalizedString(@"本单最多减免配送费: ¥%@", NSStringFromClass([self class])),cardInfo[@"reduce"]];
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc]initWithString:str2];
        [attStr2 addAttribute:NSForegroundColorAttributeName value:HEX(@"FA4C34", 1.0) range:NSMakeRange(10, str2.length-10)];
        self.moneyLab.attributedText = attStr2;
        self.selecteBtn.selected = [_card_id isEqualToString:cardInfo[@"cid"]];
    }else{
        NSString *title = [NSString stringWithFormat: NSLocalizedString(@"%@ ¥%@ [%@天有效]", NSStringFromClass([self class])),cardInfo[@"title"],cardInfo[@"amount"],cardInfo[@"days"]];
        NSAttributedString *attStr = [NSString getAttributeString:title dealStr:[NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),cardInfo[@"amount"]] strAttributeDic:@{NSForegroundColorAttributeName:HEX(@"FA4C34", 1.0)}];
        attStr = [NSString addAttributeString:attStr dealStr:[NSString stringWithFormat: NSLocalizedString(@"[%@天有效]", NSStringFromClass([self class])),cardInfo[@"days"]] strAttributeDic:@{NSFontAttributeName:FONT(14)}];
        self.titleLab.attributedText = attStr;
        self.desLab.text = [NSString stringWithFormat: NSLocalizedString(@"单日可减免配送单数: %@单", NSStringFromClass([self class])),cardInfo[@"limits"]];
        self.moneyLab.text = [NSString stringWithFormat: NSLocalizedString(@"每单最多减免配送费 ¥%@", NSStringFromClass([self class])),cardInfo[@"reduce"]];
        self.selecteBtn.selected = [_card_id isEqualToString:cardInfo[@"card_id"]];
    }
    
}

@end

#import "YFBuyMemberPeiSongCardView.h"

@interface YFBuyMemberPeiSongCardView ()
@property(nonatomic,assign)BOOL is_have_buy;// 是否已经买过会员卡了
@property(nonatomic,weak)UIButton *cancleBtn;
@property(nonatomic,assign)NSInteger selectedIndex;
@end

@implementation YFBuyMemberPeiSongCardView

-(instancetype)initWithFrame:(CGRect)frame is_bug:(BOOL)is_buy{
    _is_have_buy = is_buy;
    return [self initWithFrame:frame];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *titleView = [UIView new];
        titleView.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.height.offset(48);
        }];
        
        UILabel *titleLab = [UILabel new];
        [titleView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(0);
            make.height.offset(20);
        }];
        titleLab.font = FONT(18);
        titleLab.textColor = HEX(@"333333", 1.0);
        titleLab.text = _is_have_buy ?  NSLocalizedString(@"使用会员卡", NSStringFromClass([self class])) :  NSLocalizedString(@"购买会员卡", NSStringFromClass([self class]));
        
        UIButton *closeBtn = [UIButton new];
        [titleView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.offset(0);
            make.width.height.offset(40);
        }];
        [closeBtn setImage:IMAGE(@"icon_close") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(yf_sheetHiddenAnimation) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 252, WIDTH, 48)];
        [self.backView addSubview:cancleBtn];
        [cancleBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = FONT(16);
        [cancleBtn addTarget:self action:@selector(clickCancle) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        self.cancleBtn = cancleBtn;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        
        UIView *lineView=[UIView new];
        [cancleBtn addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.top.offset=0;
            make.right.offset=0;
            make.height.offset=0.5;
        }];
        lineView.backgroundColor=LINE_COLOR;
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count == 0) return 0;
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardCell *cell = [CardCell initWithTableView:tableView reuseIdentifier:@"CardCell"];
    cell.is_buy = _is_have_buy;
    cell.card_id = self.choosed_card_id;
    [cell reloadCellWith:self.dataSource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    if (_is_have_buy) {
        [self yf_sheetHiddenAnimation];
    }else{
        self.choosed_card_id = self.dataSource[indexPath.row][@"card_id"];
        [self.tableView reloadData];
    }
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;

    [self.tableView reloadData];
    self.tableView.scrollEnabled = dataSource.count > 4;
    CGFloat height = 0;
    if (dataSource.count > 4) {
        height = 100 * 4 + 4;
    }else{
        height = 100 * dataSource.count + 4;
    }
    
    if (_is_have_buy) {
        height = height + 48 + 48;
        self.backViewHeight = height ;
        self.backView.frame = CGRectMake(0, HEIGHT - height, WIDTH, height);
        self.tableView.frame = CGRectMake(0, 48, WIDTH, height-48-48);
        self.cancleBtn.frame = CGRectMake(0, height-48, WIDTH, 48);
        [self.cancleBtn setTitle: NSLocalizedString(@"不使用", NSStringFromClass([self class])) forState:UIControlStateNormal];
    }else{
        height = height + 48;
        self.backViewHeight = height;
        self.backView.frame = CGRectMake(0, HEIGHT - height, WIDTH, height);;
        self.tableView.frame = CGRectMake(0, 48, WIDTH, height-48);
        self.cancleBtn.frame = CGRectMake(0, height, WIDTH, 0);
    }

    [super yf_sheetHiddenAnimation];
}

-(void)yf_sheetHiddenAnimation{
    [super yf_sheetHiddenAnimation];
    NSDictionary *infoDic =  self.dataSource[self.selectedIndex];
    
    YF_SAFE_BLOCK(self.choosedCardBlock,infoDic);
}

-(void)clickCancle{
    [super yf_sheetHiddenAnimation];
    YF_SAFE_BLOCK(self.choosedCardBlock,nil);
}

@end
