//
//  JHMyMessageCellTwo.m
//  JHWaimaiClient
//
//  Created by YangNan on 2018/12/25.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import "JHMyMessageCellTwo.h"
#import "NSString+Tool.h"
@interface JHMyMessageCellTwo(){
    
    UILabel *timeL;
    UILabel *titleL;
    UIView *redV;
    UILabel *desL;
    UIView * bgV;
    
}

@end

@implementation JHMyMessageCellTwo

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.backgroundColor = HEX(@"f6f6f6", 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)creatUI{
    timeL = [[UILabel alloc]init];
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset = 0;
        make.height.offset = 40;
    }];
    timeL.textColor = HEX(@"999999", 1);
    timeL.font = FONT(12);
    timeL.textAlignment = NSTextAlignmentCenter;
    
    bgV = [[UIView alloc]init];
    [self addSubview:bgV];
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeL.mas_bottom).offset = 0;
        make.centerX.offset = 0;
        make.width.offset = WIDTH-30;
        
    }];
    bgV.layer.cornerRadius = 8;
    bgV.backgroundColor = HEX(@"ffffff", 1);
    bgV.layer.masksToBounds = YES;
    
    titleL = [[UILabel alloc]init];
    [bgV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 20;
        make.left.offset = 16;
        make.height.offset = 22;
    }];
    titleL.textColor = HEX(@"333333", 1);
    titleL.font = FONT(16);
    
    redV = [[UIView alloc]init];
    [bgV addSubview:redV];
    [redV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleL.mas_centerY).offset = 0;
        make.left.equalTo(titleL.mas_right).offset = 8;
        make.height.width.offset = 10;
    }];
    redV.layer.cornerRadius = 5;
    redV.clipsToBounds = YES;
    redV.backgroundColor = HEX(@"FF2800", 1);
    
    
    desL = [[UILabel alloc]init];
    [bgV addSubview:desL];
    [desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset = 8;
        make.centerX.offset = 0;
        make.width.offset = WIDTH-30-32;
        
    }];
    desL.numberOfLines = 0;
    desL.textColor = HEX(@"666666", 1);
    desL.font = FONT(14);
  

}
-(void)setModel:(JHMyMessageListModel *)model{
//    timeL.text = [NSString formateDate:@"yyyy-MM-dd HH:ss" dateline:model.dateline];
    NSString * str =[NSString stringWithFormat:@"%ld",model.dateline];//model.dateline;
//    NSString *str = @"1545841813";
    timeL.text = [self distanceTimeWithBeforeTime:str.doubleValue];
    titleL.text = model.title;
    redV.hidden = model.is_read;
    desL.text = model.content;
    [bgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeL.mas_bottom).offset = 0;
        make.centerX.offset = 0;
        make.width.offset = WIDTH - 30;
        make.bottom.offset = 0;
        make.height.equalTo(desL.mas_height).offset = 10+58;
        
    }];
}
- (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"yyyy-MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
    }else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
        
        
    }
//    else if(distanceTime <24*60*60*365){
//        [df setDateFormat:@"MM-dd HH:mm"];
//        distanceStr = [df stringFromDate:beDate];
//    }
//    else{
//      
//    }
    return distanceStr;
}

@end
