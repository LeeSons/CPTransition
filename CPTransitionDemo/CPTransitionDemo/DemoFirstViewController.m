//
//  DemoFirstViewController.m
//  CPTransitionDemo
//
//  Created by Morplcp on 2019/4/23.
//  Copyright © 2019 Morplcp. All rights reserved.
//

#import "DemoFirstViewController.h"
#import "CPNavViewController.h"

#import "UIPushDemoViewController.h"
#import "UIDrawerViewController.h"

@interface DemoFirstViewController ()

@end

@implementation DemoFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    self.cp_navBar.title = @"呵呵";
    self.cp_navBar.backColor = [UIColor redColor];
    self.cp_navBar.titleTextAttribute = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.cp_navBar.itemTextAttribute = @{NSForegroundColorAttributeName:[UIColor yellowColor]};
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_moment_zan_per"] style:UIBarButtonItemStylePlain target:self action:@selector(heheda:)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_moment_zan_per"] style:UIBarButtonItemStylePlain target:self action:@selector(heheda:)];
    
    self.cp_navBar.leftItem = leftButton;
    
    self.cp_navBar.rightItems = @[rightButton, rightButton, rightButton, rightButton, rightButton, rightButton];
    
    // 注册导航栏高度改变通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bianle:) name:CPNavigationBarHeightDidChangeNotification object:nil];
    
    // Do any additional setup after loading the view.
    
    
    UIButton *push = [UIButton buttonWithType:UIButtonTypeSystem];
    [push setTitle:@"push一个" forState:UIControlStateNormal];
    
    push.frame = CGRectMake(100, 100, 100, 100);
    
    [push addTarget:self action:@selector(clickPush:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:push];
    
    
   
    
    UIButton *leftd = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftd setTitle:@"左侧抽屉" forState:UIControlStateNormal];
    
    leftd.frame = CGRectMake(100, 300, 100, 100);
    [leftd addTarget:self action:@selector(clickLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftd];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    [right setTitle:@"右侧抽屉" forState:UIControlStateNormal];
    
    right.frame = CGRectMake(100, 500, 100, 100);
    [right addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right];
    
    
}

- (void)clickRight:(UIButton *)sender
{
//    UIPushDemoViewController.h"
//#import "UIDrawerViewController.h"
    UIDrawerViewController *right = [UIDrawerViewController new];
    [right cp_openDrawerWithType:(CPTransitionOpenDrawerTypeRight) complete:nil];
}

- (void)clickLeft:(UIButton *)sender
{
    UIDrawerViewController *left = [UIDrawerViewController new];
    [left cp_openDrawerWithType:(CPTransitionOpenDrawerTypeLeft) complete:nil];
}

- (void)clickPush:(UIButton *)sender
{
    UIPushDemoViewController *push = [UIPushDemoViewController new];
    [push cp_pushWithAnimationType:(CPTransitionAnimationTypeDefault) complete:nil];
}

- (void)bianle:(NSNotification *)notify
{
    CGFloat height = [notify.object floatValue];
    
    NSLog(@"%f", height);
}

- (void)heheda:(UIBarButtonItem *)sender
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
