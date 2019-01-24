//
//  ZQSeeWebImageView.m
//  JHAppWebViewTest
//
//  Created by ijianghu on 2017/7/17.
//  Copyright © 2017年 ijianghu. All rights reserved.
//

#import "ZQSeeWebImageView.h"
#import <UIImageView+WebCache.h>
// 屏幕宽高
#define The_WIDTH [UIScreen mainScreen].bounds.size.width
#define The_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ZQSeeWebImageView()<UIScrollViewDelegate>{
    NSArray *currentArr;
    NSInteger currentIndex;
}
@property(nonatomic,strong)UIScrollView * scrollV;//滑动视图
@property(nonatomic,strong)UILabel * label_image;
@property(nonatomic,strong)UITextView *textView;//展示每张图片的描述的
@property(nonatomic,strong)UIButton *downloadImage;//下载图片到相册的方法
@property(nonatomic,strong)UILabel *saveImgAlertL;//保存图片的相关提示

@end
@implementation ZQSeeWebImageView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self creatSubView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}
-(void)creatSubView{
    self.backgroundColor = [UIColor blackColor];
    self.frame = CGRectMake(0, 0, The_WIDTH, The_HEIGHT);
    self.alpha = 0;
    //创建点击view移除图片展示的view
    UITapGestureRecognizer * tap_remove = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove_image)];
    [self addGestureRecognizer:tap_remove];
    [self scrollV];
    [self label_image];
    [self textView];
    [self downloadImage];
    [self saveImgAlertL];
}
-(UIScrollView *)scrollV{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]init];
        _scrollV.bounds = CGRectMake(0, 0,The_WIDTH, The_HEIGHT);
        _scrollV.center = self.center;
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.showsVerticalScrollIndicator = NO;
        _scrollV.pagingEnabled = YES;
        _scrollV.delegate = self;
        //滑动到头／尾的时候，不能滑动
        //_scrollV.bounces = NO;
        [self addSubview:_scrollV];
    }
    return _scrollV;
}
-(UILabel *)label_image{
    if (!_label_image) {
        _label_image = [[UILabel alloc]init];
        _label_image.backgroundColor = [UIColor blackColor];
        _label_image.frame = CGRectMake((The_WIDTH-50)/2,(The_HEIGHT - The_WIDTH+100)/2-40, 50, 20);
        _label_image.textAlignment = NSTextAlignmentCenter;
        _label_image.textColor  = [UIColor whiteColor];
        _label_image.backgroundColor = [UIColor clearColor];
        [self addSubview:_label_image];
    }
    return _label_image;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = FONT(13);
        _textView.editable = NO;
        _textView.frame = FRAME(20, The_HEIGHT/2+The_WIDTH/2-30, 200, 40);
        [self addSubview:_textView];
    }
    return _textView;
}
-(UIButton *)downloadImage{
    if (!_downloadImage) {
        _downloadImage = [[UIButton alloc]init];
        [_downloadImage setTitle:NSLocalizedString(@"保存图片", nil) forState:UIControlStateNormal];
        [_downloadImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downloadImage.titleLabel.font = FONT(13);
        _downloadImage.frame = FRAME(The_WIDTH - 80, The_HEIGHT/2+The_WIDTH/2-30, 60, 30);
        [_downloadImage addTarget:self action:@selector(clickDownLoadImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_downloadImage];
    }
    return _downloadImage;
}
-(void)clickDownLoadImage{
    _saveImgAlertL.text = NSLocalizedString(@"正在保存图片到相册...", nil);
    NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:currentArr[currentIndex][@"img"]]];
    UIImage *img = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = NSLocalizedString(@"保存图片失败!", nil) ;
        _saveImgAlertL.text = msg;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _saveImgAlertL.text = @"";
        });
        
    }else{
        
        msg = NSLocalizedString(@"保存图片成功!", nil) ;
        _saveImgAlertL.text = msg;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _saveImgAlertL.text = @"";
        });
        
    }
    
}
-(UILabel *)saveImgAlertL{
    if (!_saveImgAlertL) {
        _saveImgAlertL = [[UILabel alloc]init];
        _saveImgAlertL.textColor = [UIColor whiteColor];
        _saveImgAlertL.font = FONT(13);
        _saveImgAlertL.frame = FRAME(0, The_HEIGHT - 50, WIDTH, 30);
        _saveImgAlertL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_saveImgAlertL];
    }
    return _saveImgAlertL;
}
-(void)remove_image{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)showViewWithImgArr:(NSArray *)arr
                    index:(NSInteger)index{
    currentArr = arr;
    currentIndex = index;
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
     _scrollV.tag = arr.count;
    _label_image.text = [NSString stringWithFormat:@"%ld/%ld",index+1,arr.count];
    [_scrollV setContentOffset:CGPointMake(The_WIDTH*index, 0)];
    _scrollV.contentSize = CGSizeMake(The_WIDTH*arr.count, The_HEIGHT);
    _textView.text =arr[index][@"title"];
    for (UIImageView *view in _scrollV.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < arr.count; i++) {
        CGFloat h = The_WIDTH-100;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*The_WIDTH, (The_HEIGHT - h)/2, The_WIDTH, h)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:arr[i][@"img"]] placeholderImage:IMAGE(@"home_banner_default")];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_scrollV addSubview:imageView];
    }
}
#pragma mark - 这是滑动视图的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat f = scrollView.contentOffset.x/The_WIDTH+1;
    NSLog(@"%f",f);
    int  a = f;
    if (f+0.5 >= a+1) {
        a++;
    }
    currentIndex = a-1;
    _textView.text =currentArr[a-1][@"title"];
    _label_image.text = [NSString stringWithFormat:@"%d/%ld",a,scrollView.tag];
}

@end
