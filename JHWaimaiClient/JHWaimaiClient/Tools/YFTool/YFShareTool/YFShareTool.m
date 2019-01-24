//
//  YFShareTool.m
//  JHWaimaiClient
//
//  Created by ios_yangfei on 2018/12/22.
//  Copyright © 2018年 xixixi. All rights reserved.
//

#import "YFShareTool.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "UIImage+Extension.h"
#import <Photos/Photos.h>
#import "JHShowAlert.h"

@implementation YFShareTool

+(void)yf_shareWithInfo:(NSDictionary *)dic toPlatform:(YFSharePlatformType)platformType block:(MsgBlock)resultBlock{

    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareObject *shareObject = nil;

    NSString *urlImg = dic[@"urlImg"];
    NSString *shareTitle = dic[@"shareTitle"];
    NSString *shareStr = dic[@"shareStr"];
    NSString *localImg = dic[@"localImg"];
    NSString *shareUrl = dic[@"shareUrl"];
    BOOL is_only_img = [dic[@"isOnlyImg"] boolValue];
    UIImage *savedImg = dic[@"savedImg"];

    if (is_only_img) {
        if (savedImg) {
            shareObject = [UMShareImageObject shareObjectWithTitle:shareTitle descr:shareStr thumImage:savedImg];
            ((UMShareImageObject *)shareObject).shareImage = savedImg;
        }else{
            shareObject = [UMShareImageObject shareObjectWithTitle:shareTitle descr:shareStr thumImage:IMAGE(localImg)];
            ((UMShareImageObject *)shareObject).shareImage = IMAGE(localImg);
        }
    }else{
        if (urlImg.length > 0) {
            if (![urlImg hasPrefix:@"http"]) {
                urlImg = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,urlImg];
            }
            shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareStr thumImage:urlImg];
        } else {
            if (savedImg) {
                shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareStr thumImage:savedImg];
            }else{
                shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareStr thumImage:IMAGE(localImg)];
            }
        }
        ((UMShareWebpageObject *)shareObject).webpageUrl = shareUrl;
    }
    
    messageObject.shareObject = shareObject;

    switch (platformType) {
        case YFSharePlatformType_WechatSession:{
            [self shareToPlatform:UMSocialPlatformType_WechatSession infoDic:dic data:messageObject block:resultBlock];
        }
            break;
        case YFSharePlatformType_QQ:{
            [self shareToPlatform:UMSocialPlatformType_QQ infoDic:dic data:messageObject block:resultBlock];
        }
            break;
        case YFSharePlatformType_WechatTimeLine:{
            [self shareToPlatform:UMSocialPlatformType_WechatTimeLine infoDic:dic data:messageObject block:resultBlock];
        }
            break;
        case YFSharePlatformType_QQZone:{
            [self shareToPlatform:UMSocialPlatformType_Qzone infoDic:dic data:messageObject block:resultBlock];
        }
            break;
        default:
        {

            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
            {
                // 无权限
                resultBlock(NO, NSLocalizedString(@"应用相机权限受限,请在设置中启用", NSStringFromClass([self class])));
                return;
            }

            //保存图片到【相机胶卷】
            /// 异步执行修改操作
            [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                // 2.1 创建一个相册变动请求
                NSDictionary *dic = [NSBundle mainBundle].infoDictionary;
                NSString *albumName = dic[@"CFBundleDisplayName"];
                PHAssetCollectionChangeRequest *collectionRequest = [self getCurrentPhotoCollectionWithAlbumName:albumName];
                
                // 2.2 根据传入的照片，创建照片变动请求
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:savedImg];
                
                // 2.3 创建一个占位对象
                PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
//                localIdentifier = placeholder.localIdentifier;
                
                // 2.4 将占位对象添加到相册请求中
                [collectionRequest addAssets:@[placeholder]];
  
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (error) {
                    resultBlock(NO, NSLocalizedString(@"图片保存失败", NSStringFromClass([self class])));
                } else {
                    resultBlock(YES, NSLocalizedString(@"图片保存成功", NSStringFromClass([self class])));
                }
            }];
 
        }
            break;
    }

}

+ (PHAssetCollectionChangeRequest *)getCurrentPhotoCollectionWithAlbumName:(NSString *)albumName {
    // 1. 创建搜索集合
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 2. 遍历搜索集合并取出对应的相册，返回当前的相册changeRequest
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle containsString:albumName]) {
            PHAssetCollectionChangeRequest *collectionRuquest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            return collectionRuquest;
        }
    }
    
    // 3. 如果不存在，创建一个名字为albumName的相册changeRequest
    PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
    return collectionRequest;
}

+(void)shareToPlatform:(UMSocialPlatformType)platformType infoDic:(NSDictionary *)dic data:(UMSocialMessageObject *)messageObject block:(MsgBlock)block{
    
    BOOL is_miniProgrammar = [dic[@"is_miniProgrammar"] boolValue];
    if (is_miniProgrammar && platformType == UMSocialPlatformType_WechatSession) {
        
        NSString *shareUrl = dic[@"shareUrl"];
        NSString *userName = dic[@"userName"];
        NSString *pagePath = dic[@"pagePath"];
        NSString *shareTitle = dic[@"shareTitle"];
        NSString *shareStr = dic[@"shareStr"];
        
        UIViewController *vc = dic[@"miniProgrammar_vc"];
        
        WXMiniProgramObject *wxMiniObject = [WXMiniProgramObject object];
        wxMiniObject.webpageUrl = shareUrl;// 兼容低版本的网页链接
        wxMiniObject.userName = userName;// 小程序的原始id
        wxMiniObject.path= pagePath;// 小程序的页面路径
        
        UIImage *mini_shareImg = [self convertViewToImage:vc.view];
        
        NSData *data = UIImageJPEGRepresentation(mini_shareImg, 1.0);
        NSString *str = [NSByteCountFormatter stringFromByteCount:data.length countStyle:NSByteCountFormatterCountStyleFile];
        CGFloat scale = [str intValue] > 128 ? ([str intValue] * 1.0 /128) : 1 ;
        scale = scale >= 1 ? (1/scale) : scale;
        wxMiniObject.hdImageData= UIImageJPEGRepresentation(mini_shareImg, scale);//data.shareImage;// 小程序节点高清大图，小于128k
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = shareTitle;// title
        message.description = shareStr;// description
        message.mediaObject = wxMiniObject;
        message.thumbData = nil;// 兼容旧版本的节点图片，小于32k，新版本优先
        //使用WXMiniProgramObject的hdImageData属性
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.scene = WXSceneSession;// 目前只支持会话
        [WXApi sendReq:req];
        

    }else{

        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                block(NO, NSLocalizedString(@"分享失败", NSStringFromClass([self class])));
            }else{
                block(YES, NSLocalizedString(@"分享成功", NSStringFromClass([self class])));
            }
        }];
    }
    
}


// 小程序分享的图片处理
+ (UIImage *)convertViewToImage:(UIView *)view
{
    // 第二个参数表示是否非透明。如果需要显示半透明效果，需传NO，否则YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(WIDTH, HEIGHT),NO,[UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self scaleToSize:CGSizeMake(WIDTH/1.5, HEIGHT/1.5) img:image];
}

+(UIImage*)scaleToSize:(CGSize)size img:(UIImage *)img{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
