//
//  UIControl+TimeInterVal.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/18.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "UIControl+TimeInterVal.h"

@interface UIControl ()
// 记录上次点击的时间戳
@property (nonatomic, assign) NSTimeInterval responderEventTime;
@end

@implementation UIControl (TimeInterVal)

static const char *UIControl_responderEventInterval = "UIControl_responderEventInterval";
static const char *UIControl_responderEventTime = "UIControl_responderEventTime";

-(NSTimeInterval)responderEventTime{
    return [objc_getAssociatedObject(self, UIControl_responderEventTime) doubleValue];
}

-(void)setResponderEventTime:(NSTimeInterval)responderEventTime{
    objc_setAssociatedObject(self, UIControl_responderEventTime, @(responderEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)responderTimeInterval{
    return [objc_getAssociatedObject(self, UIControl_responderEventInterval) doubleValue];
}

-(void)setResponderTimeInterval:(NSTimeInterval)responderTimeInterval{
    objc_setAssociatedObject(self, UIControl_responderEventInterval, @(responderTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    //获取着两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method myMethod = class_getInstanceMethod(self, @selector(yf_sendAction:to:forEvent:));
    SEL mySEL = @selector(yf_sendAction:to:forEvent:);
    
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    
    //如果方法已经存在了
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
        
    }
    
    //----------------以上主要是实现两个方法的互换,load是gcd的只shareinstance，果断保证执行一次
    
}

- (void)yf_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    if (NSDate.date.timeIntervalSince1970 - self.responderEventTime < self.responderTimeInterval) {
        return;
    }
    
    if (self.responderTimeInterval > 0) {
        self.responderEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self yf_sendAction:action to:target forEvent:event];
}


@end
