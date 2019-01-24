//
//  UIWebView+Extension.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/16.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "UIWebView+Extension.h"

@implementation UIWebView (Extension)

////解决 [WebActionDisablingCALayerDelegate willBeRemoved] 崩溃的问题
//+ (void)load{
//
//    //  "v@:"
//    Class class = NSClassFromString(@"WebActionDisablingCALayerDelegate");
//
//#pragma clang diagnostic push
//
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//
//    class_addMethod(class, @selector(setBeingRemoved), (IMP)setBeingRemoved, "v@:");
//    class_addMethod(class, @selector(willBeRemoved), (IMP)willBeRemoved, "v@:");
//
//#pragma clang diagnostic pop
//
//    class_addMethod(class, @selector(removeFromSuperview), (IMP)removeFromSuperview, "v@:");
//}
//
//id setBeingRemoved( id self, SEL selector, ...)
//{
//    return nil;
//}
//
//id willBeRemoved( id self, SEL selector, ...)
//{
//    return nil;
//}
//
//id removeFromSuperview( id self, SEL selector, ...)
//{
//    return nil;
//}

@end
