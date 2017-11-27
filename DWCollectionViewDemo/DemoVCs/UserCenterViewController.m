//
//  UserCenterViewController.m
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/20.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "UserCenterViewController.h"
#import "DWCollection.h"

#import "UserCenterViewModel.h"

//用户信息
#import "UserCenterInforModel.h"
#import "UserCenterInforCollectionViewCell.h"

//头部
#import "UserCenterHeaderModel.h"
#import "UserCenterHeaderCollectionReusableView.h"

//标准入口
#import "UserCenterEntryModel.h"
#import "UserCenterEntryCollectionViewCell.h"



@interface UserCenterViewController ()<UICollectionViewDelegate>

@property (nonatomic, strong) DWCollectionView *collectionView;

@property (nonatomic, strong) UserCenterViewModel *viewModel;

@property (nonatomic, strong) UserCenterInforCollectionViewCell *userInforCell;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserCenterData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config views
- (void)setupViews {
    [self.view addSubview:self.collectionView];
    [self configNav];
    [self configCollectionView];
}

- (void)configNav {
    
    /// 创建导航

}
- (void)configCollectionView {
    __weak typeof(self) weakSelf = self;
    __block CGFloat screenW = CGRectGetWidth(self.view.frame);
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        //用户信息
        maker.registerCell([UserCenterInforCollectionViewCell class],[UserCenterInforModel class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(screenW, UserCenterInforCellHeight);
        }).adapter(^(UICollectionViewCell *cell , NSIndexPath *indexPath, id data){
            [(UserCenterInforCollectionViewCell *)cell bindData:data];
            weakSelf.userInforCell = (UserCenterInforCollectionViewCell *)cell;
        }).didSelect(^(NSIndexPath*indexPath, id data){

        });
        //快捷入口
        maker.registerCell([UserCenterEntryCollectionViewCell class],[UserCenterEntryModel class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(screenW / 5, 70);
        }).adapter(^(UICollectionViewCell *cell , NSIndexPath *indexPath, id data){
            [(UserCenterEntryCollectionViewCell *)cell bindData:data];
        }).didSelect(^(NSIndexPath*indexPath, id data){
            
        });
        
        //标题头
        maker.registerHeader([UserCenterHeaderCollectionReusableView class],[UserCenterHeaderModel class])
        .sizeConfiger(^(UICollectionViewLayout *layout,NSInteger section, id data){
            return CGSizeMake(screenW, 33);
        })
        .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data) {
            UserCenterHeaderCollectionReusableView *view = (UserCenterHeaderCollectionReusableView *)reusableView;
            [view bindData:data];
        });
        
        //footer
        maker.registerFooter([UICollectionReusableView class],[NSString class])
        .sizeConfiger(^(UICollectionViewLayout *layout,NSInteger section, id data){
            return CGSizeMake(screenW, 10);
        })
        .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data) {
            reusableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        });
    }];
}

#pragma mark - vm

- (void)getUserCenterData {
    __weak typeof(self) weakSelf = self;
    [self.viewModel getUserCenterData:^(NSArray *data) {
        [weakSelf.collectionView setData:data];
    }];
}

#pragma mark - action

- (void)settingButtonTapped:(id)button {
   
    
}



#pragma mark - UIScrollViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if ([self isKindOfClass:[DWCollectionDelegate class]]) {
        DWCollectionDelegate *delegate = (DWCollectionDelegate *)self;
        UserCenterViewController *vc = delegate.originalDelegate;
        [vc updateUserInforView:scrollView];
        [vc updateNav:offset];

    }
}

#pragma mark - update user header
- (void)updateUserInforView:(UIScrollView *)scrollView {
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        CGRect rect =self.userInforCell.bgImageView.frame;
        rect.origin.y = offset.y;
        rect.size.height = UserCenterInforCellHeight - offset.y ;
        self.userInforCell.bgImageView.frame = rect;
    }
}
- (void)updateNav:(CGPoint)offset {
    float minAlpha = 0.0;
    float maxAlpha = 1.0;
    
    float startAlpha = 0.0;
    float alpha = maxAlpha;
    
    /// 焦点图的高度-导航栏高度
    CGFloat refrenceHeight = UserCenterInforCellHeight - 20;
    
    alpha = maxAlpha - ((refrenceHeight - offset.y) / refrenceHeight) * maxAlpha / 1.0 + startAlpha;
    if(refrenceHeight < 0)
    {
        alpha = maxAlpha - alpha;
    }
    alpha = MIN(alpha, maxAlpha);
    alpha = MAX(alpha, minAlpha);
//    self.superNavBarView.imgvBackGround.alpha = alpha;
//    [self.superNavBarView setBackgroundColor:RGBA(0, 0, 0, alpha)];
}

#pragma mark - getter & setter
- (DWCollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[DWCollectionView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.view.frame))];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _collectionView;
}


- (UserCenterViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[UserCenterViewModel alloc]init];
    }
    return _viewModel;
}

@end
