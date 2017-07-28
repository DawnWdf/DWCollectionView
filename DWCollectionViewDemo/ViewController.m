//
//  ViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "ViewController.h"

#import "DWCollectionView.h"

#import "DWCollectionViewCell.h"


#import "TeamInfo.h"
#import "LeagueInfo.h"
#import "TeamInfoCell.h"
#import "LeagueHeaderReusableView.h"

@interface ViewController ()<UICollectionViewDelegate>

@property (nonatomic,strong) DWCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    
    
    DWCollectionView *cv= [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    cv.backgroundColor = [UIColor whiteColor];
    cv.delegate = self;
    [self.view addSubview:cv];
    self.collectionView = cv;
    
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        
        maker.registerCell([TeamInfoCell class],[TeamInfo class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(150, 150);
        })
        .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data){
            TeamInfoCell *newCell = (TeamInfoCell *)cell;
            [newCell bindData:data];
        });
        
        
        maker.registerHeader([LeagueHeaderReusableView class],[LeagueInfo class])
        .sizeConfiger(^ CGSize (UICollectionViewLayout *layout , NSInteger section, id data){
            return CGSizeMake(300, height_header);
        })
        .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data){
            LeagueHeaderReusableView *header = (LeagueHeaderReusableView *)reusableView;
            [header bindData:data];
        })
        
        ;
   

     
        
    }];
    
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
