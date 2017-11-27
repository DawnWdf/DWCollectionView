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

#import "DWFlowAutoMoveLayout.h"



/*
 1：自定义layout与下拉刷新结合，刷新时有闪烁
 2：自定义的layout像系统layout一样支持pin
 3：collectionView依赖其他framework，localDemo在carthage update的时候也会自动加载，去掉？
 4：使用桥接模式将refresh管理起来
 5：自定义瀑布流，可以支持长按移动item，并在不同的section之间移动        ------Done （动画效果需要优化）
 6：当移动item到空白位置时的处理
 */

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSourcePrefetching,UICollectionViewDataSource,DWFlowAutoMoveLayoutDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    //-----------配置自定义的布局--------------------------------------
    DWFlowAutoMoveLayout *flowLayout = [[DWFlowAutoMoveLayout alloc] init];
//    flowLayout.estimatedItemSize
    flowLayout.numberOfColumn = 4;
    flowLayout.boundEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.lineSpace = 10;
    flowLayout.interitemSpace = 10;
    flowLayout.headerEdgeInsets = ^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    };
    flowLayout.footerEdgeInsets = ^UIEdgeInsets(NSInteger section) {
        return UIEdgeInsetsZero;
    };

    flowLayout.headerHeight = 40;
    flowLayout.footerHeight = 40;
    flowLayout.delegate = self;
    
    UICollectionViewFlowLayout *sysLayout = [[UICollectionViewFlowLayout alloc] init];
//    sysLayout.estimatedItemSize = CGSizeMake(100, 150);
//    sysLayout.sectionHeadersPinToVisibleBounds = YES;
//    sysLayout.sectionFootersPinToVisibleBounds = YES;
//    sysLayout.minimumLineSpacing = 50;
    //------------创建collectionView--------------------------------------
    UICollectionView *cv= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:sysLayout];
    cv.backgroundColor = [UIColor whiteColor];
    cv.dataSource = self;
    cv.delegate = self;
    [self.view addSubview:cv];
    self.collectionView = cv;
    
    //-------------在seciontView之上添加视图 如：滚动banner------------------------------------------
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cv.frame), 100)];
    headerView.backgroundColor = [UIColor grayColor];
//    [cv addSubview:headerView];
    
    [self.collectionView registerClass:[TeamInfoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[LeagueHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //--------------注册cell/header/footer，并绑定数据---------------------------------------------------
    /*
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
   
    //-----------------配置下拉刷新等---------------------------------------------
    self.collectionView.refreshManager = [[DWRefreshManager alloc] initWithScrollView:self.collectionView];
    [self.collectionView.refreshManager setupRefreshType:DWRefreshTypeHeaderAndFooter];
    
    __weak typeof(self.collectionView.refreshManager) weakRefreshManager = self.collectionView.refreshManager;
    
    [self.collectionView.refreshManager setupHeaderRefresh:^{
        //strong circle
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf requestData];
    } footerRefresh:^{
        __strong typeof(weakRefreshManager) strongRefreshManager = weakRefreshManager;
        [strongRefreshManager endFooterRefresh];
    }];
     */
    //--------------------ios9 拖拽-----------------------------------------------------------
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnCollectionView:)];
        [self.collectionView addGestureRecognizer:longGesture];
    }
    */
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)longPressOnCollectionView:(UILongPressGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        //不支持多section之间移动
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:
            {
                if (indexPath) {
                    [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
                }
            }
                break;
            case UIGestureRecognizerStateEnded:
            {
                [self.collectionView endInteractiveMovement];
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
                [self.collectionView updateInteractiveMovementTargetPosition:point];
            }
                break;
            default:
                [self.collectionView cancelInteractiveMovement];
                break;
        }
    }
}

- (void)updateLayout {
    if ([self.collectionView.collectionViewLayout isKindOfClass:[DWFlowLayout class]]) {
        DWFlowLayout *flowLayout = (DWFlowLayout *)self.collectionView.collectionViewLayout;
        
        __weak NSMutableArray *weakList = self.list;
        flowLayout.itemHeightBlock = ^CGFloat(NSIndexPath *indexPath) {
            // return 50;
            __strong NSMutableArray *strongList = weakList;
            DWSection *section = strongList[indexPath.section];
            TeamInfo *info = section.items[indexPath.row];
            NSString *name = info.teamNameCn;
#ifdef DEBUG
            NSLog(@"%s",__func__);
#endif
            return name.length * 20;
        };
        
    }
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
               // section.footerData = @"footer";
                
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
    if ([NSThread isMainThread]) {
        [self.collectionView reloadData];
        [self updateLayout];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
            [self updateLayout];
        });
    }

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
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    [self.collectionView.refreshManager endHeaderRefresh];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:resultDic[@"msg"] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alert showViewController:self sender:nil];
                });
            }
        }
    }];
    [task resume];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%s  %@ ~~~~  %ld",__func__,NSStringFromCGPoint(scrollView.contentOffset),(long)scrollView.contentInset.top);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   
    return self.list.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[[self.list objectAtIndex:section] items] count];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TeamInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    id data = [[[self.list objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
    [cell bindData:data];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LeagueHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    id data = [[self.list objectAtIndex:indexPath.section] headerData];
    [view bindData:data];
    return view;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    return YES;
}
/*
/// Returns a list of index titles to display in the index view (e.g. ["A", "B", "C" ... "Z", "#"])
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView API_AVAILABLE(tvos(10.2));

/// Returns the index path that corresponds to the given title / index. (e.g. "B",1)
/// Return an index path with a single index to indicate an entire section, instead of a specific item.
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index API_AVAILABLE(tvos(10.2));
*/
#pragma mark - UICollectionViewDelegate

/* 单击
 -[ViewController collectionView:shouldHighlightItemAtIndexPath:]
 -[ViewController collectionView:didHighlightItemAtIndexPath:]
   {长按
        -[ViewController collectionView:shouldShowMenuForItemAtIndexPath:]
        -[ViewController collectionView:canPerformAction:forItemAtIndexPath:withSender:]//每一个sel/cell都调用一次
        -[ViewController collectionView:didUnhighlightItemAtIndexPath:]
        点击一个sel
        -[ViewController collectionView:canPerformAction:forItemAtIndexPath:withSender:]//再次确认
        -[ViewController collectionView:performAction:forItemAtIndexPath:withSender:]
   }
 -[ViewController collectionView:didUnhighlightItemAtIndexPath:]
 -[ViewController collectionView:shouldSelectItemAtIndexPath:]
 -[ViewController collectionView:didDeselectItemAtIndexPath:]
 -[ViewController collectionView:didSelectItemAtIndexPath:]
 */


#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id data = [[[self.list objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];

    CGSize size = [[(TeamInfo *)data teamNameCn] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightRegular]}];

    
    return CGSizeMake(size.width + 20, 30);
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(320, 40);
}



#pragma mark - UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0) {
//    NSLog(@"%s   ---------    %@",__func__, indexPaths);
}
#pragma mark - DWFlowAutoMoveLayoutDelegate
- (BOOL)dw_collectionView:(UICollectionView *)collectionView canMoveItemAtIndex:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return NO;
    }
    return YES;
}

- (void)dw_collectionView:(UICollectionView *)collectionView didMoveItemAtIndex:(NSIndexPath *)fromIndexPath toIndex:(NSIndexPath *)toIndexPath {
    
    DWSection *sourceSection = self.list[fromIndexPath.section];
    id sourceObj = sourceSection.items[fromIndexPath.row];
    
    DWSection *destinationSection = self.list[toIndexPath.section];
    
    NSMutableArray *fromItem = [sourceSection.items mutableCopy];
    NSMutableArray *toItem = [destinationSection.items mutableCopy];
    if (sourceSection == destinationSection) {
        [fromItem removeObject:sourceObj];
        [fromItem insertObject:sourceObj atIndex:toIndexPath.row];
        sourceSection.items = fromItem;
    } else {
        [fromItem removeObject:sourceObj];
        sourceSection.items = fromItem;
        [toItem insertObject:sourceObj atIndex:toIndexPath.row];
        destinationSection.items = toItem;
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
