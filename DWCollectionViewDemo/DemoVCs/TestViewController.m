//
//  TestViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/12/1.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "TestViewController.h"
#import "DWCollection.h"
#import "UserCenterEntryCollectionViewCell.h"
#import "UserCenterEntryModel.h"
@interface TestViewController ()<UICollectionViewDelegate>
@property (nonatomic, strong) DWCollectionView *collectionView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    DWCollectionView *collection = [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    collection.backgroundColor = [UIColor whiteColor];
    collection.delegate = self;
    self.collectionView = collection;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        maker.registerCell([UICollectionViewCell class], [NSString class])
        .didSelect(^(NSIndexPath *indexPath, id data) {
            NSLog(@"did seletct at : %@",indexPath);
        })
        .itemSize(^CGSize(NSIndexPath *indexPath, id data) {
            return CGSizeMake(160, 40);
        })
        .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data) {
            cell.backgroundColor = [UIColor lightGrayColor];
        });
        //快捷入口
        maker.registerCell([UserCenterEntryCollectionViewCell class],[UserCenterEntryModel class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(160, 80);
        }).adapter(^(UICollectionViewCell *cell , NSIndexPath *indexPath, id data){
            [(UserCenterEntryCollectionViewCell *)cell bindData:data];
            cell.backgroundColor = [UIColor redColor];
        }).didSelect(^(NSIndexPath*indexPath, id data){
            
        });
    }];
    
    
    DWSection *section = [[DWSection alloc] init];
    UserCenterEntryModel *model = [[UserCenterEntryModel alloc] init];
    model.title = @"big title";
    section.items = @[@"a",model,@"b"];
    [self.collectionView setData:@[section]];
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
