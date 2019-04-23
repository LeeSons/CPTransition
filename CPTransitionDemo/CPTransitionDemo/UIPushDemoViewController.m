//
//  UIPushDemoViewController.m
//  CPTransitionDemo
//
//  Created by Morplcp on 2019/4/23.
//  Copyright © 2019 Morplcp. All rights reserved.
//

#import "UIPushDemoViewController.h"

@interface UIPushDemoViewController ()

@end

@implementation UIPushDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
    label.text = @"全屏滑动返回";
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont boldSystemFontOfSize:30];
    
    [self.view addSubview:label];
    
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
