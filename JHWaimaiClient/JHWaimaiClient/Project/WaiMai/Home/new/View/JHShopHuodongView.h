//
//  JHShopHuodongView.h
//  JHWaimaiClient
//
//  Created by xixixi on 2018/11/9.
//  Copyright © 2018 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHShopHuodongView : UIView
@property(nonatomic,assign)CGFloat totalHeight;
@property(nonatomic,strong)UIButton *arrowBtn;
- (void)updateWithTitle:(NSArray <NSString *>*)titleArr showMore:(BOOL)showMore;
- (void)hiddenBtns;
@end

NS_ASSUME_NONNULL_END
