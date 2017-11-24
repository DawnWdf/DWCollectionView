//
//  GDemoViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/10/19.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "GDemoViewController.h"
#import <DWCollection/DWCollection.h>

#import "IconModel.h"
#import "IconCollectionViewCell.h"


@interface GDemoViewController ()<UICollectionViewDelegate>
@property (nonatomic, strong) DWCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation GDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 50;
    layout.minimumInteritemSpacing = 100;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    DWCollectionView *cv= [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    cv.backgroundColor = [UIColor whiteColor];
    cv.delegate = self;
    [self.view addSubview:cv];
    self.collectionView = cv;
    [self configCollectionView];
    [self customCollectionViewData];
    [self.collectionView setData:self.dataSource];
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
- (void)configCollectionView {
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        
        maker.registerCell([IconCollectionViewCell class],[IconModel class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(50, 50);
        })
        .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data){
            cell.backgroundColor = [UIColor redColor];
        })
        .didSelect(^(NSIndexPath *indexPath, id data){
            NSLog(@"did select block : 如果vc中实现了didSelect的代理方法，则在此block后执行");
        });
//
//
//        maker.registerHeader([NormalHeader class],[LeagueInfo class])
//        .sizeConfiger(^ CGSize (UICollectionViewLayout *layout , NSInteger section, id data){
//            return CGSizeMake(300, 40);
//        })
//        .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data){
//            NormalHeader *header = (NormalHeader *)reusableView;
//            [header bindData:data];
//        });
        
        
    }];
}
- (void)customCollectionViewData {
    DWSection *iconSection = [[DWSection alloc] init];
    NSMutableArray *icons = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        IconModel *model = [[IconModel alloc] init];
        [icons addObject:model];
    }
    iconSection.items = icons;
    [self.dataSource addObject:iconSection];
}


#pragma mark - UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
@end
