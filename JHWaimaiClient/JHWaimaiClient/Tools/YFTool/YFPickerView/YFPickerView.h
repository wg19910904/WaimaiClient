//
//  ChooseTimeView.h
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/30.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YFPickerViewTypeThreeRow,
    YFPickerViewTypeTwoRow,
    YFPickerViewTypeOneRow
} YFPickerViewType;

typedef NS_ENUM(NSUInteger, YFPickerViewShowType) {
    YFPickerViewShowFromBottom,
    YFPickerViewShowFromCenter,
};

typedef NS_ENUM(NSUInteger, YFPickerViewSubViewLocationType) {
    YFPickerViewSubViewLocationTopCenter,
    YFPickerViewSubViewLocationTopLeft,
    YFPickerViewSubViewLocationTopRight,
    YFPickerViewSubViewLocationBottomCenter,
    YFPickerViewSubViewLocationBottomLeft,
    YFPickerViewSubViewLocationBottomRight,
};

@interface YFPickerView : UIView

@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,weak)UIPickerView *firstPicker;
@property(nonatomic,weak)UIPickerView *secondPicker;
@property(nonatomic,weak)UIPickerView *thirdPicker;
@property(nonatomic,assign)YFPickerViewShowType showType;// pickview展示出来时的动画位置
@property(nonatomic,assign)YFPickerViewSubViewLocationType sureBtnType;
@property(nonatomic,assign)YFPickerViewSubViewLocationType titleLabType;
@property(nonatomic,copy)NSString *titleStr;// title
@property(nonatomic,assign)NSInteger firstRow;//点击确定的时候选择的row
@property(nonatomic,assign)NSInteger secondRow;//点击确定的时候选择的row
@property(nonatomic,assign)NSInteger thirdRow;//点击确定的时候选择的row
@property(nonatomic,strong)NSArray *firstArr;
@property(nonatomic,strong)NSArray *secondArr;
@property(nonatomic,strong)NSArray *thirdArr;


-(instancetype)initWithType:(YFPickerViewType)type;
-(void)show;
-(void)hidden;


#pragma mark ====== 子类需要重写的方法 =======
// 点击确定的方法
-(void)clickSureAction;
// 选择某一个row的处理
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row;
// 每一个row显示的文字处理
-(void)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row view:(UILabel *)textLab;
@end
