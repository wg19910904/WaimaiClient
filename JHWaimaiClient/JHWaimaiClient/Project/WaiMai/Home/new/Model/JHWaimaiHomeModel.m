//
//  JHWaimaiHomeModel.m
//  JHCommunityClient_V3
//
//  Created by xixixi on 2018/8/29.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "JHWaimaiHomeModel.h"

@implementation JHWaimaiHomeModel
{
    //存储配置数据和本地控制器的对应关系
    NSDictionary *mapDic;
}

- (void)handleConfig{
    [self handleTabBarVC];
}

#pragma mark - 首页数据展示(除了订单弹幕)
- (void)handleHomeConfig{
    _vcNameArr = @[].mutableCopy;
    _vcDataIndexArr = @[].mutableCopy;
    
    if (mapDic == nil) {
        //获取本地控制器映射关系
        mapDic = [self getHomeConfigMap];
    }
    NSUInteger count = _theme.count;
    for (int i = 0; i<count; i++) {
        NSDictionary *dataDic = (NSDictionary *)_theme[i];
        NSString *module = dataDic[@"module"];
        NSString *type = dataDic[@"type"];
        type = @(type.integerValue).stringValue;
        //获取需要返回的控制器
        NSString *vcName = mapDic[module][type];
        if (vcName.length) {
            //有效
            [_vcNameArr addObject:vcName];
            [_vcDataIndexArr addObject:@(i)];
        }
        if ([module isEqualToString:@"module9"]) {
            self.shopHuodongType = type;
        }
    }
}
#pragma mark - 处理根控制器tabbarVC
- (void)handleTabBarVC{
    //软件运行周期内只改变一次
    _tabbarDic = (NSDictionary *)[_theme lastObject];
}
#pragma mark - 获取本地控制器映射关系
- (NSDictionary *)getHomeConfigMap{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HomeConfig" ofType:@"json"];
    NSData *mapData = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *mapDic = [NSJSONSerialization JSONObjectWithData:mapData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
    if (error) {
        return @{};
    }
    return mapDic;
}
- (NSUInteger)type{
    NSDictionary *module1 = (NSDictionary *) _theme[1];
    NSString *type = module1[@"type"];
    return type.integerValue;
}

- (CGFloat)header_height{
    NSArray *remmondArr = _theme[1][@"searchBox"][@"keywords"];
    if(self.type != 2){
        NSString *open = _theme[1][@"searchBox"][@"open"];
        //第一种表头
        if(remmondArr.count && open.integerValue > 0){
            return 135-64+NAVI_HEIGHT;
        }else{
            return 104-64+NAVI_HEIGHT;
        }
    }else{
        //第二种表头
        if(remmondArr.count){
            return 95-64+NAVI_HEIGHT;
        }else{
            return 64-64+NAVI_HEIGHT;
        }
    }
}
- (BOOL)showDanmu{
    for (NSDictionary *tem_dic in self.theme) {
        if ([tem_dic[@"module"] isEqualToString:@"module4"] &&
            [tem_dic[@"open"] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}
- (NSDictionary *)getCurrentDataDic:(NSUInteger)row{
    NSNumber *_indexNum = _vcDataIndexArr[row];
    return (NSDictionary *)[_theme objectAtIndex:_indexNum.integerValue];
}

- (UIColor *)normalColor{
    NSDictionary *tabbarDic = [_theme lastObject];
    NSString *normalColor = tabbarDic[@"color_nochecked"];
    if ([normalColor length]) {
        return HEX(normalColor, 1.0);
    }
    return HEX(@"222222", 1.0);
}
- (UIColor *)selectedColor{
    NSString *selectedColor = _tabbarDic[@"color_checked"];
    if ([selectedColor length]) {
        return HEX(selectedColor, 1.0);
    }
    return THEME_COLOR_Alpha(1.0);
}


@end



@implementation JHWaimaiHomeShopListAndHongbao

+(NSDictionary *)mj_objectClassInArray{
    return  @{@"items":@"JHWaimaiHomeShopModel"};
}

@end


