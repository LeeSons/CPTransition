//
//  DemoSeccondViewController.m
//  CPTransitionDemo
//
//  Created by Morplcp on 2019/4/23.
//  Copyright © 2019 Morplcp. All rights reserved.
//

#import "DemoSeccondViewController.h"
#import "CPNavViewController.h"

@interface DemoSeccondViewController ()

@end

@implementation DemoSeccondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cp_navBar.backColor = [UIColor greenColor];
    
    
    // 自定义头视图
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleView.backgroundColor = [UIColor blueColor];
    self.cp_navBar.titleView = titleView;
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    
    // Do any additional setup after loading the view.
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
