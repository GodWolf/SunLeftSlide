//
//  MainViewController.m
//  SunLeftSlide
//
//  Created by sun on 15/6/26.
//  Copyright (c) 2015年 sunxingxiang. All rights reserved.
//

#import "MainViewController.h"
#import "SunLeftSlideViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 250, 50, 30)];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)button {
//    UIViewController *vc = [UIViewController new];
//    vc.view.backgroundColor = [UIColor greenColor];
//    [self.navigationController pushViewController:vc animated:YES];

    SunLeftSlideViewController *sunLSVC = (SunLeftSlideViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [sunLSVC openSlideWithAnimation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
