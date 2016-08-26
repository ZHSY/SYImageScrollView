//
//  MainViewController.m
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/24.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import "MainViewController.h"

#import "MainTestViewController.h"
#import "ScrollConflictTestViewControll.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 200, 30)];
    [testButton setTitle:@"测试" forState:UIControlStateNormal];
    
    testButton.backgroundColor = [UIColor orangeColor];
    
    [testButton addTarget:self action:@selector(testBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:testButton];
    
    
    
    UIButton *testButton2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 200, 30)];
    [testButton2 setTitle:@"滑动冲突测试" forState:UIControlStateNormal];
    
    testButton2.backgroundColor = [UIColor orangeColor];
    
    [testButton2 addTarget:self action:@selector(testBtn2Click) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:testButton2];
    
    
    
}



- (void)testBtnClick
{
    MainTestViewController *testVC = [[MainTestViewController alloc] init];
    testVC.title = self.title;
    
    
    [self.navigationController pushViewController:testVC animated:YES];
    
    
}


- (void)testBtn2Click
{
    ScrollConflictTestViewControll *testVC = [[ScrollConflictTestViewControll alloc] init];
    testVC.title = self.title;
    
    
    [self.navigationController pushViewController:testVC animated:YES];
   
}



@end
