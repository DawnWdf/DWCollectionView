//
//  CollectionViewBaseViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/11/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "CollectionViewBaseViewController.h"


@interface CollectionViewBaseViewController ()

@end

@implementation CollectionViewBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DWCollectionView *cv= [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    cv.backgroundColor = [UIColor whiteColor];
    cv.delegate = self;
    [self.view addSubview:cv];
    self.collectionView = cv;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
