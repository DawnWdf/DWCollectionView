//
//  NormalViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/10/10.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "NormalViewController.h"
#import <DWCollection/DWCollection.h>
#import "DataManager.h"
#import "TeamInfo.h"
#import "TeamInfoCell.h"
#import "LeagueInfo.h"
#import "LeagueHeaderReusableView.h"

@interface NormalViewController ()
@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //------------创建collectionView--------------------------------------
    [self configCollectionView];
    [DataManager teamData:^(NSMutableArray *data) {
        [self.collectionView setData:data];
    }];
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
        maker.registerCell([TeamInfoCell class],[TeamInfo class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(100, 140);
        })
        .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data){
            TeamInfoCell *newCell = (TeamInfoCell *)cell;
            newCell.showImage = YES;
            [newCell bindData:data];
        })
        .didSelect(^(NSIndexPath *indexPath, id data){
            NSLog(@"did select block : 如果vc中实现了didSelect的代理方法，则在此block后执行");
        });
 
    }];
    
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        
        
        maker.registerHeader([LeagueHeaderReusableView class],[LeagueInfo class])
        .sizeConfiger(^ CGSize (UICollectionViewLayout *layout , NSInteger section, id data){
            return CGSizeMake(CGRectGetWidth(self.view.frame), height_header);
        })
        .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data){
            LeagueHeaderReusableView *header = (LeagueHeaderReusableView *)reusableView;
            [header bindData:data];
        });
    }];
}


@end
