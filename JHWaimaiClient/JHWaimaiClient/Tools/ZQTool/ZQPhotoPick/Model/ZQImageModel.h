//
//  ZQImageModel.h
//  ZQPhotos
//
//  Created by ijianghu on 2017/6/7.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZQImageModel : NSObject
@property(nonatomic,assign)NSInteger width;//图片的宽度
@property(nonatomic,assign)NSInteger height;//图片的高度
@property(nonatomic,strong)UIImage *image;//图片
@property(nonatomic,strong)NSData *data;//图片的数据流
@property(nonatomic,assign)BOOL isSelector;
@end
