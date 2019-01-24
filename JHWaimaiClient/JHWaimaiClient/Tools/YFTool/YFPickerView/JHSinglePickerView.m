//
//  JHPaoTuiSinglePickerView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 2017/10/10.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHSinglePickerView.h"

@implementation JHSinglePickerView

-(void)setDataSource:(NSArray *)dataSource{
    [super setDataSource:dataSource];
    self.firstRow = 0;
    [self.firstPicker selectRow:0 inComponent:0 animated:NO];
    self.firstArr = dataSource;
    [self.firstPicker reloadAllComponents];
    
}

-(void)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row view:(UILabel *)textLab{
    textLab.text = self.firstArr[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row{
    self.firstRow=row;
}

-(void)clickSureAction{
  YF_SAFE_BLOCK(self.clickSureBlock,self.is_weight,self.firstArr[self.firstRow]);
}

@end
