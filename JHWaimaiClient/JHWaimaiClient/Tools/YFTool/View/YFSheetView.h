//
//  YFSheetView.h
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YFSheetViewDelegate <NSObject>
@optional
/**
 *  点击选项按钮
 */
-(void)sheetClickButtonIndex:(NSInteger)index;
@end

@interface YFSheetView : UIView
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *cancelColor;
@property(nonatomic,weak)id<YFSheetViewDelegate> delegate;
@property(nonatomic,assign)float cellHeight;

-(YFSheetView *)initWithTitle:(NSString *)title delegate:(id<YFSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

-(void)sheetShow;
@end
