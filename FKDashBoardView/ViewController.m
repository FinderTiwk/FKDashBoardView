//
//  ViewController.m
//  FKDashBoardView
//
//  Created by FinderTiwk on 2018/8/22.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "ViewController.h"
#import "FKDashBoardView.h"

@interface ViewController ()
@property (weak, nonatomic) FKDashBoardView *dashBoard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIColor *color = [UIColor colorWithWhite:1 alpha:0.2];
    FKDashBoardView *dashBoard = [[FKDashBoardView alloc] initWithStartAngle:160
                                                               endAngle:380];
    dashBoard.frame = CGRectMake(30, 30, screenSize.width - 60, 260);
    
    dashBoard.titleLabel.text = @"未授权";
    dashBoard.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    dashBoard.titleLabel.textColor = [UIColor whiteColor];
    
    dashBoard.subtitleLabel.text = @"芝麻信用";
    dashBoard.subtitleLabel.font = [UIFont systemFontOfSize:14];
    dashBoard.subtitleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    [dashBoard setMargin:2];
    [dashBoard setPadding:2];
    [dashBoard setDashBoardWidth:15];
    
    [dashBoard setDashBoardBigScaleColor:[UIColor whiteColor]];
    [dashBoard setDashBoardSmallScaleColor:[UIColor colorWithWhite:1 alpha:0.6]];
    
    [dashBoard setDashBoardColor:color];
    [dashBoard setProgress:0.2];
    [self.view addSubview:dashBoard];
    self.dashBoard = dashBoard;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((screenSize.width - 160)/2, 360, 180, 50);
    button.layer.cornerRadius = 8;

    button.backgroundColor = [UIColor blackColor];
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:@"点击我改变进度条" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)changeProgress:(UIButton *)sender{
    double progress = rand()/(double)RAND_MAX;
    [self.dashBoard setProgress:progress];
}


@end
