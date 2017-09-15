//
//  ViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "ViewController.h"

#import <DWCollection/DWCollection.h>
#import "DWCollectionViewCell.h"

#import "DWRefreshManager.h"


#import "TeamInfo.h"
#import "LeagueInfo.h"
#import "TeamInfoCell.h"
#import "LeagueHeaderReusableView.h"
#import "DWFooterCollectionReusableView.h"

#import "DWFlowLayout.h"



/*
 1：自定义layout与下拉刷新结合，刷新时有闪烁
 */

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSourcePrefetching>

@property (nonatomic,strong) DWCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    
    DWFlowLayout *flowLayout = [[DWFlowLayout alloc] init];
//    flowLayout.estimatedItemSize
    flowLayout.numberOfColumn = 4;
    flowLayout.boundEdgeInsets = UIEdgeInsetsMake(30, 10, 10, 10);
    flowLayout.lineSpace = 10;
    flowLayout.interitemSpace = 10;
    flowLayout.headerEdgeInsets = ^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    };
    flowLayout.footerEdgeInsets = ^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    };
    
    flowLayout.headerHeight = 40;
    flowLayout.footerHeight = 20;
    
    DWCollectionView *cv= [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
    cv.backgroundColor = [UIColor whiteColor];
    cv.delegate = self;
    cv.prefetchDataSource = self;
//    cv.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    [self.view addSubview:cv];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, CGRectGetWidth(cv.frame), 100)];
//    headerView.backgroundColor = [UIColor grayColor];
//    [cv addSubview:headerView];
    self.collectionView = cv;
    
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        
        maker.registerCell([TeamInfoCell class],[TeamInfo class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(150, 150);
        })
        .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data){
            TeamInfoCell *newCell = (TeamInfoCell *)cell;
        
//            NSLog(@"bind data -========== %@",indexPath);
            [newCell bindData:data];
            [newCell setBackgroundColor:[self randomColor]];
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
        
        maker.registerFooter([DWFooterCollectionReusableView class],[NSString class])
        .sizeConfiger(^ CGSize (UICollectionViewLayout *layout , NSInteger section, id data){
            return CGSizeMake(300, height_header);
        })
        .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data){
            DWFooterCollectionReusableView *header = (DWFooterCollectionReusableView *)reusableView;
            [header bindData:data];
            [header setBackgroundColor:[UIColor yellowColor]];
        });
    }];
    self.collectionView.refreshManager = [[DWRefreshManager alloc] initWithScrollView:self.collectionView];
    [self.collectionView.refreshManager setupRefreshType:DWRefreshTypeHeaderAndFooter];
    
    __weak typeof(self.collectionView.refreshManager) weakRefreshManager = self.collectionView.refreshManager;
    [self.collectionView.refreshManager setupHeaderRefresh:^{
        //strong circle
        [self requestData];
    } footerRefresh:^{
        __strong typeof(weakRefreshManager) strongRefreshManager = weakRefreshManager;
        [strongRefreshManager endFooterRefresh];
    }];
    
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLayout {
    DWFlowLayout *flowLayout = (DWFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemHeightBlock = ^CGFloat(NSIndexPath *indexPath) {
        return random()%100 + 50;
    };
}

#pragma mark - data corperation

- (void)listFrom:(NSDictionary *)dic {
    NSMutableArray *result = [NSMutableArray array];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *value = (NSArray *)obj;
            [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DWSection *section = [[DWSection alloc] init];
                LeagueInfo *league = [[LeagueInfo alloc] init];
                league.leagueTypeCn = obj[@"leagueTypeCn"];
                league.maxRound = [obj[@"maxRound"] longValue];
                league.season = obj[@"season"];
                section.headerData = league;
                section.footerData = @"footer";
                
                NSArray *teamInfos = obj[@"teamInfoSet"];
                NSMutableArray *teams = [NSMutableArray array];
                [teamInfos enumerateObjectsUsingBlock:^(id  _Nonnull sobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TeamInfo *info = [[TeamInfo alloc] init];
                    info.teamNameCn = sobj[@"teamNameCn"];
                    info.teamLogoUrl = sobj[@"teamLogoUrl"];
                    [teams addObject:info];
                }];
                section.items = teams;
                [result addObject:section];
            }];
        }
    }];
    
    self.list = result;
    [self.collectionView setData:self.list];
    [self updateLayout];

}

#pragma mark - request

- (void)requestData {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://apicloud.mob.com/football/league/queryParam?key=1c3d999f473ee"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        NSError *jsonError = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        if ((!jsonError) && [result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = (NSDictionary *)result;
            NSInteger code = [resultDic[@"retCode"] integerValue];
            if (code == 200) {
                [self listFrom:resultDic[@"result"]];
                [self.collectionView.refreshManager endHeaderRefresh];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:resultDic[@"msg"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert showViewController:self sender:nil];
            }
        }
    }];
    [task resume];
}

#pragma mark - UICollectionViewDataSource

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 30, 10, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 40;
}

#pragma mark - UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0) {
//    NSLog(@"%s   ---------    %@",__func__, indexPaths);
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
