//
//  CollectionViewBaseViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/11/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "CollectionViewBaseViewController.h"
#import "DWCollectionViewFlowLayout.h"
#import "DWRefreshManager.h"

@interface CollectionViewBaseViewController ()

@end

@implementation CollectionViewBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
    
    DWCollectionViewFlowLayout *layout = [[DWCollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.dw_insetForSection = ^UIEdgeInsets(NSInteger section) {
        if (section == 0) {
            return UIEdgeInsetsMake(12, 10, 0, 10);
        }
        
        return UIEdgeInsetsZero;
    };
    DWCollectionView *cv= [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
    cv.backgroundColor = [UIColor whiteColor];
    cv.delegate = self;
    [self.view addSubview:cv];
    self.collectionView = cv;
    self.collectionView.refreshManager = [[DWRefreshManager alloc] initWithScrollView:self.collectionView];
    [self.collectionView.refreshManager setupRefreshType:DWRefreshTypeHeaderAndFooter];
    
    __weak typeof(self.collectionView.refreshManager) weakRefreshManager = self.collectionView.refreshManager;
    [self.collectionView.refreshManager setupHeaderRefresh:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(12);
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakRefreshManager) strongRefreshManager = weakRefreshManager;
                [strongRefreshManager endHeaderRefresh];
            });
        });
        
    } footerRefresh:^{
        __strong typeof(weakRefreshManager) strongRefreshManager = weakRefreshManager;
        [strongRefreshManager endFooterRefresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
