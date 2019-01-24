//
//  HZQChoseImage.h
//  JHLive
//
//  Created by ijianghu on 16/8/20.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HZQChoseImageDelegate<NSObject>
@optional
-(void)choseImage:(UIImage *)image withData:(NSData *)data;
-(void)choseImageArr:(NSArray *)modelArr;
@end
@interface HZQChoseImage : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak)id<HZQChoseImageDelegate>delegate;
-(void)creatChoseImage;
@property(nonatomic,assign)NSInteger maxCount;//选择相册的最大选择数
@property(nonatomic,assign)BOOL isUpFaceImage;//是否是上传头像
@end
