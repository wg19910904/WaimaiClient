//
//  JHWMBankCardChooseTimePickerView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMBankCardChooseTimePickerView.h"
#import "NSString+Tool.h"

@implementation JHWMBankCardChooseTimePickerView

// 数据处理
-(void)setDataSource:(NSArray *)dataSource{
    
    NSMutableArray *arr = [NSMutableArray array];
    NSDate *date = [NSDate date];
    NSString *year = [NSString formateDate:@"yyyy" dateline:[date timeIntervalSince1970]];
    NSString *month = [NSString formateDate:@"MM" dateline:[date timeIntervalSince1970]];
    for (NSInteger i=0; i<20; i++) {
        NSString *str = [NSString stringWithFormat: NSLocalizedString(@"%ld年", NSStringFromClass([self class])), [year integerValue]+ i];
        NSMutableArray *monthArr = [NSMutableArray array];
        int j =  i == 0 ? ([month intValue] - 1) : 0;
        for ( ; j<12; j++) {
           
            NSString *month = [NSString stringWithFormat: NSLocalizedString(@"%d月", NSStringFromClass([self class])),j+1];
            [monthArr addObject:month];
        }
        NSDictionary *dic = @{@"year":str,@"months":monthArr};
        [arr addObject:dic];
    }
    dataSource = arr.copy;
    
    [super setDataSource:dataSource];
    self.firstArr = dataSource;
    self.secondArr = dataSource.firstObject[@"months"];
    [self.firstPicker reloadAllComponents];
    [self.secondPicker reloadAllComponents];
    
}

-(void)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row view:(UILabel *)textLab{
    if (pickerView==self.firstPicker) textLab.text =self.firstArr[row][@"year"];
    else textLab.text = self.secondArr[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row{
    if (pickerView==self.firstPicker)  {
        self.firstRow=row;
        self.secondArr = self.firstArr[row][@"months"];
    }else if (pickerView==self.secondPicker){
        self.secondRow=row;
    }
    [self.firstPicker reloadAllComponents];
    [self.secondPicker reloadAllComponents];
}

-(void)clickSureAction{
    NSString *year = self.firstArr[self.firstRow][@"year"];
    NSString *month = self.secondArr[self.secondRow];
    self.timeChooseBlock(year,month);
}

@end
