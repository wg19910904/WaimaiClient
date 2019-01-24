//
//  HZQChoseImage.m
//  JHLive
//
//  Created by ijianghu on 16/8/20.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "HZQChoseImage.h"
#import "NSString+Tool.h"
#import "ZQPhotoAlbumPickVC.h"
#import "ZQImageModel.h"
@implementation HZQChoseImage{
    UIImage * image;
    NSData * dataImage;
}
-(void)creatChoseImage{
    UIViewController *vc = (UIViewController *)self.delegate;
    [vc addChildViewController:self];
    [self creatUIAlertControl];
}
-(void)creatUIAlertControl{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self creatUIImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选择", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.isUpFaceImage) {
            [self creatUIImagePickerControllerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }else{
            ZQPhotoAlbumPickVC *vc = [[ZQPhotoAlbumPickVC alloc]init];
            vc.maxCount = self.maxCount;
            __weak typeof (self)weakSelf = self;
            [vc setResultBlock:^(NSArray * modelArr){
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(choseImageArr:)]) {
                    [weakSelf.delegate choseImageArr:modelArr];
                }
            }];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            UIViewController *vc1 = (UIViewController *)self.delegate;
            [vc1 presentViewController:nav animated:YES completion:nil];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 这是创建UIImagePickerController的方法
-(void)creatUIImagePickerControllerWithType:(NSInteger)type{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = type;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 0) {
        return;
    }
    UIViewController *vc = navigationController.viewControllers[0];
    vc.navigationItem.title = NSLocalizedString(@"相册", nil);
//    UINavigationBar *navigationBar = navigationController.navigationBar;
//    [navigationBar setBarTintColor:NaVi_COLOR_Alpha(1)];
//    navigationBar.tintColor = [UIColor whiteColor];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark - 这是UIImagePickerController的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.allowsEditing) {
        image = info[UIImagePickerControllerEditedImage];
    }else{
        image = info[UIImagePickerControllerOriginalImage];
    }
    image = [NSString scaleFromImage:image scaledToSize:CGSizeMake(500, 500)];
    dataImage = UIImagePNGRepresentation(image);
    if (self.isUpFaceImage) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(choseImage:withData:)]) {
            [self.delegate choseImage:image withData:dataImage];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(choseImageArr:)]) {
            ZQImageModel *model = [ZQImageModel new];
            model.image = image;
            model.data = dataImage;
            [self.delegate choseImageArr:@[model]];
        }
 
    }
        [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
