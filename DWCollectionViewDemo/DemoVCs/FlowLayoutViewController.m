//
//  FlowLayoutViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/11/27.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "FlowLayoutViewController.h"

#import "DWFlowAutoMoveLayout.h"
#import <DWCollection/DWCollection.h>

#import "TeamInfo.h"
#import "TeamInfoCell.h"
#import "LeagueInfo.h"
#import "LeagueHeaderReusableView.h"

#import "DataManager.h"

@interface FlowLayoutViewController ()<UICollectionViewDelegate,DWFlowAutoMoveLayoutDelegate>
@property (nonatomic,strong) DWCollectionView *collectionView;

@end

@implementation FlowLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DWFlowLayout *flowLayout = [[DWFlowLayout alloc] init];
    flowLayout.numberOfColumn = 4;
    flowLayout.boundEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.lineSpace = 10;
    flowLayout.interitemSpace = 10;
    flowLayout.headerEdgeInsets = ^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    };
    
    flowLayout.headerHeight = 40;
    
    DWCollectionView *cv= [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
    cv.backgroundColor = [UIColor whiteColor];
    cv.delegate = self;
    [self.view addSubview:cv];
    self.collectionView = cv;
    
    [self configCollectionView];
    [DataManager teamData:^(NSMutableArray *data) {
        [self.collectionView setData:data];
        [self updateLayout];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configCollectionView {
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        
        maker.registerCell([TeamInfoCell class],[TeamInfo class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(150, 120);
        })
        .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data){
            TeamInfoCell *newCell = (TeamInfoCell *)cell;
            [newCell bindData:data];
            [newCell setBackgroundColor:[weakSelf randomColor]];
        })
        .didSelect(^(NSIndexPath *indexPath, id data){
            NSLog(@"did select block : 如果vc中实现了didSelect的代理方法，则在此block后执行");
        });
        
        
        maker.registerHeader([LeagueHeaderReusableView class],[LeagueInfo class])
        .sizeConfiger(^ CGSize (UICollectionViewLayout *layout , NSInteger section, id data){
            return CGSizeMake(300, height_header);
        })
        .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data){
            LeagueHeaderReusableView *header = (LeagueHeaderReusableView *)reusableView;
            [header bindData:data];
            [header setBackgroundColor:[UIColor redColor]];
        });
        
        
    }];
    
}

- (void)updateLayout {
    if ([self.collectionView.collectionViewLayout isKindOfClass:[DWFlowLayout class]]) {
        DWFlowLayout *flowLayout = (DWFlowLayout *)self.collectionView.collectionViewLayout;
        
        flowLayout.itemHeightBlock = ^CGFloat(NSIndexPath *indexPath) {
             return random()%100 + 30;
            
        };
        
    }
}
#pragma mark - private

-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
