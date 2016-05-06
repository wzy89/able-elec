//
//  ViewController.m
//  BulletForIOS
//
//  Created by 王朝阳 on 16/4/27.
//  Copyright © 2016年 Risun. All rights reserved.
//

#import "ViewController.h"
#import "BulletGroupView.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BulletGroupView *bulletView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bulletView = [[BulletGroupView alloc] initWithOriginY:200.0 trajectoryHeight:34.0 trajectoryNum:5];
    
    BulletSettingDic *settingDic = [[BulletSettingDic alloc] init];
    [settingDic setBulletTextColor:[UIColor redColor]];
    [settingDic setBulletAnimationDuration:5.0];
    [_bulletView setBulletDic:settingDic];
    
    _bulletView.dataSource = @[@"我去",
                               @"路见不平",
                               @"拔刀相助",
                               @"额，就是负伤啊",
                               @"错了，那是勇猛无敌",
                               @"哈？！英雄救美呢！！！！！",
                               @"哈哈哈哈。。。",
                               @"你们说错啦，那个坑货！",
                               @"这是一个故事啊！",
                               @"不懂不要乱说",
                               @"额。。。",
                               @"什么情况",
                               @"hello meizi",
                               @"天理难容啊～",
                               @"放开它，让我来",
                               @"nb",
                               @"这样都可以？！",
                               @"看不懂",
                               @"不错不错，有大酱风范～",
                               @"如果有一天。。。",
                               @"我去，天掉下来了",
                               @"都挺好的",
                               @"你们看到后面了吗，貌似有背景呢，哈哈哈哈哈。。。",
                               @"真是，额，强",
                               @"可以可以"];
    [self.view addSubview:_bulletView];

    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 35)];
    tf.textColor = [UIColor blackColor];
    tf.delegate = self;
    tf.layer.borderColor = [UIColor blackColor].CGColor;
    tf.layer.borderWidth = 1.0f;
    [self.view addSubview:tf];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 80, 80, 35)];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor lightGrayColor]];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    startBtn.layer.cornerRadius = 4.0f;
    [startBtn addTarget:self action:@selector(showBullet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *pauseResumeBtn = [[UIButton alloc] initWithFrame:CGRectMake(170, 80, 80, 35)];
    [pauseResumeBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseResumeBtn setTitle:@"继续" forState:UIControlStateSelected];
    [pauseResumeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [pauseResumeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pauseResumeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    pauseResumeBtn.layer.cornerRadius = 4.0f;
    [pauseResumeBtn addTarget:self action:@selector(pauseResume:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseResumeBtn];
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 80, 80, 35)];
    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn setBackgroundColor:[UIColor lightGrayColor]];
    [stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    stopBtn.layer.cornerRadius = 4.0f;
    [stopBtn addTarget:self action:@selector(hideBullet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
}
-(void)showBullet
{
    [_bulletView startBullet];
}
-(void)pauseResume:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
        [_bulletView pauseBullet];
    else
        [_bulletView resumeBullet];
}
-(void)hideBullet
{
    [_bulletView stopBullet];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_bulletView addObjectsToDataSource:@[textField.text]];
    textField.text = nil;
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
