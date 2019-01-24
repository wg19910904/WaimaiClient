//
//  JHUserAccountSetVC.m
//  JHCommunityClient_V3
//
//  Created by ijianghu on 2017/6/2.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHUserAccountSetVC.h"
#import "JHUserAccountSetHeaderCell.h"
#import "JHUserModel.h"
#import "HZQChoseImage.h"
#import "JHUserAccountReviseNickNameVC.h"
#import "JHUserAccountChoseSexView.h"
#import "JHUserAccountSetChangePhoneVC.h"
#import "JHUserAccountSetRevisePsdVC.h"
#import "JHUserAccountSetViewModel.h"
#import "JHShowAlert.h"
#import "UMSocialWechatHandler.h"
#import "JHPasteRegisterIDTool.h"
#import "JHWaimaiMineViewModel.h"
#import "JHUserModel.h"
@interface JHUserAccountSetVC ()<UITableViewDelegate,UITableViewDataSource,HZQChoseImageDelegate>{
    NSArray * titleArr;
    NSMutableArray * dataArr;
    NSData *dataHeaderImg;//头像的数据流
    UIImage *img;//头像的照片
    BOOL isUpSuccess;//是否上传成功
}
@property(nonatomic,strong)UITableView *myTableView;//创建表视图
@property(nonatomic,strong)HZQChoseImage *choseImgVC;//选择图片的控制器
@property(nonatomic,strong)JHPasteRegisterIDTool *tool;


@end

@implementation JHUserAccountSetVC


- (void)viewDidLoad {
    [super viewDidLoad];
   
    //初始化一些数据的方法
    [self initData];
    //创建表视图
    [self myTableView];
    [self bootomB];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLoginOut) name:QuitLogin object:nil];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"个人资料", nil);
        titleArr = @[@[NSLocalizedString(@"头像", nil)],
    @[NSLocalizedString(@"昵称", nil),
      NSLocalizedString(@"性别", nil)],
    @[NSLocalizedString(@"手机号", nil),
      NSLocalizedString(@"微信", nil),
      NSLocalizedString(@"密码", nil)],
    @[NSLocalizedString(@"版本号", nil)]];
//    titleArr = @[@[NSLocalizedString(@"昵称", nil),
//                   NSLocalizedString(@"性别", nil)],
//                @[NSLocalizedString(@"手机号", nil),
//                  NSLocalizedString(@"微信", nil),
//                  NSLocalizedString(@"密码", nil),
//                  NSLocalizedString(@"版本号", nil)]];
    JHUserModel *model = [JHUserModel shareJHUserModel];
    model.isBindWX = model.wx_unionid.length >0?YES:NO;
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    NSString *version = dic[@"CFBundleShortVersionString"];
    dataArr = @[@[].mutableCopy,@[model.nickname,model.sex?model.sex:NSLocalizedString(@"请选择", nil)].mutableCopy,@[model.hiddenCenterMobile,@"",NSLocalizedString(@"修改", nil)].mutableCopy,@[version].mutableCopy].mutableCopy;
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT-50) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.separatorStyle =UITableViewCellSeparatorStyleNone;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = BACK_COLOR;
            [self.view addSubview:table];
            self.tool = [[JHPasteRegisterIDTool alloc]initWithVC:self touchView:table];
            table;
            
        });
    }
    return _myTableView;
}
-(void)bootomB{
    UIButton *tuiB = [[UIButton alloc]init];
    [self.view addSubview:tuiB];
    [tuiB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 50;
    }];
    
    [tuiB setBackgroundColor:HEX(@"ffffff", 1) forState:0];
    [tuiB setTitleColor:HEX(@"FA4C34", 1) forState:0];
    [tuiB setTitle:NSLocalizedString(@"退出当前帐号", nil) forState:0];
    [tuiB addTarget:self action:@selector(tuiBClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineV = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 1)];
    [tuiB addSubview:lineV];
    lineV.backgroundColor = HEX(@"e6e6e6", 1);
    
    
}
-(void)reloadLoginOut{
    
       [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)tuiBClick{
    
    SHOW_HUD
    [JHWaimaiMineViewModel postToQuitLogin];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HIDE_HUD
    });
    
  
    
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }
    NSMutableArray *arr = titleArr[section];
    return arr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = BACK_COLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * str = @"JHUserAccountSetHeaderCell";
        JHUserAccountSetHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHUserAccountSetHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.isUpSuccess = isUpSuccess;
        cell.img = img;
        return cell;

    }else{
        static NSString * str = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = titleArr[indexPath.section][indexPath.row];
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = HEX(@"666666", 1);
        cell.detailTextLabel.font = FONT(15);
        cell.detailTextLabel.textColor = HEX(@"999999", 1);
        
        if (indexPath.row == 1&&indexPath.section == 2) {
            cell.detailTextLabel.text = [JHUserModel shareJHUserModel].bindStatus;
        }else{
            cell.detailTextLabel.text = dataArr[indexPath.section][indexPath.row];
        }
        if (indexPath.row == 0&&indexPath.section == 3) {
             cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *arr = dataArr[indexPath.section];
        if (indexPath.row != arr.count-1 ) {
            UIView *lineV = [[UIView alloc]initWithFrame:FRAME(15, 47, WIDTH, 0.5)];
            [cell addSubview:lineV];
            lineV.backgroundColor = HEX(@"e6e6e6", 1);
        }
       
        return cell;
 
    }
  }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {//头像
        [self.choseImgVC creatChoseImage];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {//修改昵称
            JHUserAccountReviseNickNameVC *vc = [[JHUserAccountReviseNickNameVC alloc]init];
            [vc setMyBlock:^{
                [dataArr[1] replaceObjectAtIndex:0 withObject:[JHUserModel shareJHUserModel].nickname];
                [tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
             __weak typeof (self)weakSelf = self;
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"男", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf changeSex:0];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"女", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf changeSex:1];
            
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
       
            
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {//换绑手机
            JHUserAccountSetChangePhoneVC * vc = [[JHUserAccountSetChangePhoneVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1){//绑定微信
            if ([JHUserModel shareJHUserModel].isBindWX) {//解除绑定
                [[UMSocialManager defaultManager]cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:nil];
                [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"您确定要解除和微信的绑定?", nil) withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withController:self withCancelBlock:nil withSureBlock:^{
                    [self noBindeWx];
                }];
            }else{//绑定
                [self BindWx];
            }
            
        }else if(indexPath.row == 2){//修改密码
            JHUserAccountSetRevisePsdVC *vc = [[JHUserAccountSetRevisePsdVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
//解除绑定微信
-(void)noBindeWx{
    SHOW_HUD
    [JHUserAccountSetViewModel postToNoBindeWeixinWithDic:@{} block:^(NSString *error) {
        HIDE_HUD
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"您已解除和微信的绑定!", nil)];
            [JHUserModel shareJHUserModel].isBindWX = NO;
            [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}
//绑定微信
-(void)BindWx{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (!error) {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            if (!resp.uid) {
                return;
            }
            [JHUserAccountSetViewModel postToBindeWeixinWithDic:@{@"wx_openid":resp.openid,@"wx_nickname": resp.name,@"wx_face":resp.iconurl,@"wx_unionid":resp.uid} block:^(NSString *error) {
                HIDE_HUD
                if (error) {
                    [self showToastAlertMessageWithTitle:error];
                }else{
                    [self showToastAlertMessageWithTitle:NSLocalizedString(@"绑定微信成功!", nil)];
                    [JHUserModel shareJHUserModel].isBindWX = YES;
                    [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"绑定微信失败", nil)];
        }
    }];

}
#pragma mark - 选择头像的
-(HZQChoseImage *)choseImgVC{
    if (!_choseImgVC) {
        _choseImgVC = [[HZQChoseImage alloc]init];
        _choseImgVC.delegate = self;
        _choseImgVC.isUpFaceImage = YES;
    }
    return _choseImgVC;
}
#pragma mark - 选择图片的代理方法
-(void)choseImage:(UIImage *)image withData:(NSData *)data{
    SHOW_HUD
    [JHUserAccountSetViewModel postToUpHeaderImgWithDic:@{@"face":data} block:^(NSString *error) {
        HIDE_HUD
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"上传头像成功!", nil)];
            img = image;
            isUpSuccess = YES;
            [_myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}
#pragma mark - 改变性别调用的接口
-(void)changeSex:(NSInteger)index{
    SHOW_HUD
    [JHUserAccountSetViewModel postToChangeSexWithDic:@{@"sex":@(index+1).stringValue} block:^(NSString *error) {
        HIDE_HUD
        if (error) {
            [self showToastAlertMessageWithTitle:error];
        }else{
            [self showToastAlertMessageWithTitle:NSLocalizedString(@"修改性别成功!", nil)];
            if (index == 0) {
                [JHUserModel shareJHUserModel].sex = NSLocalizedString(@"男", nil);
            }else{
                [JHUserModel shareJHUserModel].sex = NSLocalizedString(@"女", nil);
            }
            dataArr[1][1] = [JHUserModel shareJHUserModel].sex;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            [_myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
}
@end
