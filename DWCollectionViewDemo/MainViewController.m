//
//  MainViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/10/10.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//
/*
 1 普通视图
 2 纵向瀑布流、横向瀑布流（标签样式，标签随机显示）
 3 不同section之间cell跟随手指移动（点击移动）
 4 悬浮头/尾视图
 */
#import "MainViewController.h"
#import "NormalViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)teamDataRequest:(id)sender {
    [DataManager teamData:^(NSMutableArray *data) {
        
    }];
}
- (IBAction)pushToNormalCollectionView:(id)sender {
    [self.navigationController pushViewController:[NormalViewController new] animated:YES];
}
- (IBAction)pushToGDemoVC:(id)sender {
//    [self.navigationController pushViewController:[GDemoViewController new] animated:YES];

}

@end
