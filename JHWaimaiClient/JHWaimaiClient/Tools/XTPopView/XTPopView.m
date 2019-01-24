//
//  XTPopView.m
//  XTPopView
//
//  Created by zjwang on 16/5/23.
//  Copyright © 2016年 夏天. All rights reserved.
//
// Github : https://github.com/Zhangjingwang1993
// jianshu: http://www.jianshu.com/users/561e4eb07f0c/latest_articles
#import "XTPopView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define Length 5
#define Length2 15
@interface XTPopView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) XTDirectionType type;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XTPopView

- (instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height Type:(XTDirectionType)type Color:(UIColor *)color
{
    
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.0];
        // 箭头的位置
        self.origin = origin;
        // 视图的宽度
        self.width = width;
        // 视图的高度
        self.height = height;
        // 类型
        self.type = type;
        self.backGoundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
        self.backGoundView.backgroundColor = color;
        self.backGoundView.layer.masksToBounds = YES;
        self.backGoundView.layer.cornerRadius = 4;
        [self addSubview:self.backGoundView];
        // 添加tableview
        [self.backGoundView addSubview:self.tableView];
    }
    return self;
}
#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.type) {
        case XTTypeOfUpLeft:
        case XTTypeOfUpCenter:
        case XTTypeOfUpRight:{
            {
                CGFloat startX = self.origin.x;
                CGFloat startY = self.origin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX + Length, startY + Length);
                CGContextAddLineToPoint(context, startX - Length, startY + Length);
            }
            break;
        }
        case XTTypeOfDownLeft:
        case XTTypeOfDownCenter:
        case XTTypeOfDownRight: {
            {
                CGFloat startX = self.origin.x;
                CGFloat startY = self.origin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX - Length, startY - Length);
                CGContextAddLineToPoint(context, startX + Length, startY - Length);
            }
            break;
        }
        case XTTypeOfLeftUp:
        case XTTypeOfLeftCenter:
        case XTTypeOfLeftDown: {
            {
                CGFloat startX = self.origin.x;
                CGFloat startY = self.origin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX + Length, startY - Length);
                CGContextAddLineToPoint(context, startX + Length, startY + Length);
            }
            break;
        }
        case XTTypeOfRightUp:
        case XTTypeOfRightCenter:
        case XTTypeOfRightDown: {
            {
                CGFloat startX = self.origin.x;
                CGFloat startY = self.origin.y;
                CGContextMoveToPoint(context, startX, startY);
                CGContextAddLineToPoint(context, startX - Length, startY - Length);
                CGContextAddLineToPoint(context, startX - Length, startY + Length);
            }
            break;
        }
    }
    
    CGContextClosePath(context);
    [self.backGoundView.backgroundColor setFill];
    [self.backgroundColor setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}
#pragma mark - popView
- (void)popView
{
    // 同步显示 子控件(views)和(self)
    NSArray *results = [self.backGoundView subviews];
    for (UIView *view in results) {
        [view setHidden:YES];
    }
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:self];
    switch (self.type) {
        case XTTypeOfUpLeft: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y + Length, 0, 0);
                CGFloat origin_x = self.origin.x - Length2;
                CGFloat origin_y = self.origin.y + Length;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfUpCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y + Length, 0, 0);
                CGFloat origin_x = self.origin.x - self.width / 2;
                CGFloat origin_y = self.origin.y + Length;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfUpRight: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y + Length, 0, 0);
                CGFloat origin_x = self.origin.x + Length2;
                CGFloat origin_y = self.origin.y + Length;
                CGFloat size_width = -self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfDownLeft: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y - Length, 0, 0);
                CGFloat origin_x = self.origin.x - Length2;
                CGFloat origin_y = self.origin.y - Length;
                CGFloat size_width = self.width;
                CGFloat size_height = -self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfDownCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y - Length, 0, 0);
                CGFloat origin_x = self.origin.x - self.width / 2;
                CGFloat origin_y = self.origin.y - Length;
                CGFloat size_width = self.width;
                CGFloat size_height = -self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfDownRight: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y - Length, 0, 0);
                CGFloat origin_x = self.origin.x-self.width + Length2;
                CGFloat origin_y = self.origin.y - Length;
                CGFloat size_width = self.width;
                CGFloat size_height = -self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
            
        case XTTypeOfLeftUp: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x + Length, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x + Length;
                CGFloat origin_y = self.origin.y - Length2;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfLeftCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x + Length, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x + Length;
                CGFloat origin_y = self.origin.y - self.height / 2;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfLeftDown: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x + Length, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x + Length;
                CGFloat origin_y = self.origin.y - self.height + Length2;
                CGFloat size_width = self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfRightUp: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x - Length, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x - Length;
                CGFloat origin_y = self.origin.y - Length2;
                CGFloat size_width = -self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfRightCenter: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x - Length, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x - Length;
                CGFloat origin_y = self.origin.y - self.height / 2;
                CGFloat size_width = -self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
        case XTTypeOfRightDown: {
            {
                self.backGoundView.frame = CGRectMake(self.origin.x - Length, self.origin.y, 0, 0);
                CGFloat origin_x = self.origin.x - Length;
                CGFloat origin_y = self.origin.y - self.height + Length2;
                CGFloat size_width = -self.width;
                CGFloat size_height = self.height;
                [self startAnimateView_x:origin_x _y:origin_y origin_width:size_width origin_height:size_height];
            }
            break;
        }
    }
}
#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![[touches anyObject].view isEqual:self.backGoundView]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndexPathRow:)]) {
            [self.delegate selectIndexPathRow:-3];
        }
        [self dismiss];
    }
    
}
#pragma mark -
- (void)dismiss
{
    /**
     *  删除 在backGroundView 上的子控件
     */
    NSArray *results = [self.backGoundView subviews];
    
    for (UIView *view in results) {
        
        [view removeFromSuperview];
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        //
        self.backGoundView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        //
        [self removeFromSuperview];
    }];
}
#pragma mark -
- (void)startAnimateView_x:(CGFloat) x
                        _y:(CGFloat) y
              origin_width:(CGFloat) width
             origin_height:(CGFloat) height
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backGoundView.frame = CGRectMake(x, y, width, height);
    }completion:^(BOOL finished) {
        NSArray *results = [self.backGoundView subviews];
        for (UIView *view in results) {
            [view setHidden:NO];
        }
    }];
}
#pragma mark -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.backGoundView.frame.size.width, self.backGoundView.frame.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.row_height == 0) {
        return 44;
    }else{
        return self.row_height;
    }
}
#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (_images.count > 0) {
        UIView *view1 = [cell viewWithTag:100];
        [view1 removeFromSuperview];
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.image = [UIImage imageNamed:self.images[indexPath.row]];
//        imgV.frame = FRAME(15, 14, 12, 14);
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.tag = 100;
        [cell addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
            make.width.offset(15);
            make.height.offset(15);
        }];
        
    }
    UIView *view2 = [cell viewWithTag:101];
    [view2 removeFromSuperview];
    UILabel *label = [UILabel new];
    label.font = FONT(self.fontSize);
    label.textColor = self.titleTextColor;
    label.text = self.dataArray[indexPath.row];
    label.frame = FRAME(_images.count > 0?35:10, 10, self.backGoundView.frame.size.width-35, 20);
    label.tag = 101;
    [cell addSubview:label];
    UIView *view3 = [cell viewWithTag:105];
    [view3 removeFromSuperview];
    if (indexPath.row != self.dataArray.count-1) {
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    line.tag = 105;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 8;
        make.right.offset = -8;
        make.bottom.offset =0;
        make.height.offset = 0.5;
    }];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndexPathRow:)]) {
        [self.delegate selectIndexPathRow:indexPath.row];
    }
}

@end
