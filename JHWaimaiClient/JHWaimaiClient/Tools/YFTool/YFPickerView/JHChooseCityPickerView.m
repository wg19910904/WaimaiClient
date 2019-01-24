//
//  JHChooseCityPickerView.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/9/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHChooseCityPickerView.h"

@implementation JHChooseCityPickerView

// 数据处理
/*
 {
 "city_code" = 0;
 closed = 0;
 level = 3;
 "map_x" = "";
 "map_y" = "";
 orderby = 50;
 "parent_id" = 2;
 "path_ids" = ",1,2,20,";
 "region_id" = 20;
 "region_name" = "\U5ef6\U5e86\U53bf";
 }
 */
-(void)setDataSource:(NSArray *)dataSource{
    [super setDataSource:dataSource];
    self.firstArr = dataSource;
    self.secondArr = dataSource.firstObject[@"city"];
    self.thirdArr = self.secondArr.firstObject[@"area"];
    [self.firstPicker reloadAllComponents];
    [self.secondPicker reloadAllComponents];
    [self.thirdPicker reloadAllComponents];
}

-(void)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row view:(UILabel *)textLab{
    if (pickerView==self.firstPicker)  textLab.text =self.firstArr[row][@"region_name"];
    else if (pickerView==self.secondPicker)  textLab.text = self.secondArr[row][@"region_name"];
    else textLab.text = self.thirdArr[row][@"region_name"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row{
    if (pickerView==self.firstPicker)  {
        self.firstRow=row;
        self.secondArr = self.firstArr[row][@"city"];
        self.thirdArr = self.secondArr.firstObject[@"area"];
    }else if (pickerView==self.secondPicker){
        self.secondRow=row;
        self.thirdArr = self.secondArr[row][@"area"];
    }else{
        self.thirdRow=row;
    }
    [self.firstPicker reloadAllComponents];
    [self.secondPicker reloadAllComponents];
    [self.thirdPicker reloadAllComponents];
}

-(void)clickSureAction{
    NSString *province_name = self.firstArr[self.firstRow][@"region_name"];
    NSString *city_name = self.secondArr[self.secondRow][@"region_name"];
    NSString *area_name = self.thirdArr[self.thirdRow][@"region_name"];
    
    NSString *province_id = self.firstArr[self.firstRow][@"region_id"];
    NSString *city_id = self.secondArr[self.secondRow][@"region_id"];
    NSString *area_id = self.thirdArr[self.thirdRow][@"region_id"];
    
    if (self.resultBlock)  self.resultBlock(@{@"province_id" : province_id,
                                              @"city_id": city_id,
                                              @"area_id": area_id,
                                              @"province_name" : province_name,
                                              @"city_name" : city_name,
                                              @"area_name" : area_name});
}

@end
