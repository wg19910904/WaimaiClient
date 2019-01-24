//
//  JHWMCreateOrderAddNoticeVC.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/5/26.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "JHWMCreateOrderAddNoticeVC.h"
#import "YFTextView.h"

@interface JHWMCreateOrderAddNoticeVC ()
@property(nonatomic,weak)YFTextView *noticeView;
@end

@implementation JHWMCreateOrderAddNoticeVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUpView];
    
}

-(void)setUpView{

    self.navigationItem.title = NSLocalizedString(@"添加备注", @"JHWMCreateOrderAddNoticeVC");
    
    YFTextView *noticeView=[[YFTextView alloc] initWithFrame:CGRectMake(10, NAVI_HEIGHT+10, WIDTH - 20 , 200)];
    noticeView.placeholderStr= NSLocalizedString(@"请输入备注", @"JHWMCreateOrderAddNoticeVC");
    
    noticeView.textFont = 14;
    noticeView.inputText = self.notice;
    noticeView.backgroundColor= [UIColor whiteColor];
    noticeView.layer.cornerRadius=4;
    noticeView.clipsToBounds=YES;
    noticeView.layer.borderColor=LINE_COLOR.CGColor;
    noticeView.layer.borderWidth=0.5;
    [self.view addSubview:noticeView];
    self.noticeView=noticeView;
    
    [self addRightTitleBtn:NSLocalizedString(@"完成", @"JHWMCreateOrderAddNoticeVC") titleColor:HEX(@"333333",1) sel:@selector(clickSureBtn)];

}

-(void)clickSureBtn{
    if (self.noticeView.inputText.length == 0) {
        [self showToastAlertMessageWithTitle:NSLocalizedString(@"您还没有输入任何备注信息哟!", @"JHWMCreateOrderAddNoticeVC")];
        return;
    }
    
    if (self.clickSure) {
        self.clickSure(self.noticeView.inputText);
    }
    [self clickBackBtn];
}
@end
