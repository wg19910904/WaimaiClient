//
//  JHShowAlert.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShowAlert.h"

@implementation JHShowAlert
+(void)showAlertWithTitle:(NSString *)title
               withMessage:(NSString *)msg
            withBtn_cancel:(NSString *)cancel
              withBtn_sure:(NSString *)sure
            withController:(UIViewController *)vc
           withCancelBlock:(void(^)(void))cancelBlock
             withSureBlock:(void(^)(void))sureBlock {
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancel) {
        [alertControl addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }]];
    }
    if (sure) {
        [alertControl addAction:[UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureBlock) {
                sureBlock();
            }

        }]];
    }
    // 解决 Presenting view controllers on detached view controllers is discouraged
    if (!vc) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControl animated:YES completion:nil];
    }else{
        [vc presentViewController:alertControl animated:YES completion:nil];
    }
}
+(void)showAlertWithMsg:(NSString *)msg
         withController:(UIViewController *)vc
{
  
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", @"JHShowAlert")
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"知道了", @"JHShowAlert")
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil]];
    
    if (!vc) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControl animated:YES completion:nil];
    }else{
        [vc presentViewController:alertControl animated:YES completion:nil];
    }
}
+(void)showAlertWithMsg:(NSString *)msg
           withBtnTitle:(NSString *)title
         withController:(UIViewController *)vc
           withBtnBlock:(void(^)())btnBlock
{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", @"JHShowAlert")
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       if (btnBlock) {
                                                           btnBlock();
                                                       }
                                                   }]];
    if (!vc) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControl animated:YES completion:nil];
    }else{
        [vc presentViewController:alertControl animated:YES completion:nil];
    }
}
//电话
+ (void)showCallWithMsg:(NSString *)phone
         withController:(UIViewController *)vc

{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:phone
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle: NSLocalizedString(@"取消", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle: NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    if (!vc) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }else{
        [vc presentViewController:alert animated:YES completion:nil];
    }

}
/**
 点击弹出底部的警告框
 
 @param arr 标题的数组
 @param btnBlock 点击按钮的回调
 */
+(void)showSheetAlertWithTextArr:(NSArray *)arr
                  withController:(UIViewController *)vc
                  withClickBlock:(void(^)(NSInteger tag))btnBlock{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < arr.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:arr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (btnBlock) {
                btnBlock(i);
            }
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil]];
    if (!vc) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }else{
        [vc presentViewController:alert animated:YES completion:nil];
    }
}


+(void)showTextFieldAlertWithTitle:(NSString *)title
              withPlaceholder:(NSString *)placeholder
           withBtn_cancel:(NSString *)cancel
             withBtn_sure:(NSString *)sure
           withController:(UIViewController *)vc
          withCancelBlock:(void(^)(void))cancelBlock
            withSureBlock:(void(^)(NSString *))sureBlock {
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    if (placeholder.length > 0) {
        [alertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholder;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
    }
    if (cancel) {
        [alertControl addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }]];
    }
    if (sure) {
        [alertControl addAction:[UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureBlock) {
                UITextField *textfield = alertControl.textFields.firstObject;
                sureBlock(textfield.text);
            }
            
        }]];
    }
    
    if (!vc) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControl animated:YES completion:nil];
    }else{
        [vc presentViewController:alertControl animated:YES completion:nil];
    }
    
}

//+(void)showAlertWithTitle:(NSString *)msg
//         withController:(UIViewController *)vc
//{
//    
//    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", @"JHShowAlert")
//                                                                           message:msg
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//    [alertControl addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"知道了", @"JHShowAlert")
//                                                     style:UIAlertActionStyleCancel
//                                                   handler:nil]];
//    
//    [vc presentViewController:alertControl animated:YES completion:nil];
//}
@end
