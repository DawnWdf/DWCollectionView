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

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSourcePrefetching,UICollectionViewDataSource,DWFlowAutoMoveLayoutDelegate>

@property (nonatomic,strong) DWCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    __weak typeof(self) weakSelf = self;

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
    sysLayout.minimumLineSpacing = 50;
    //------------创建collectionView--------------------------------------
    DWCollectionView *cv= [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
    cv.backgroundColor = [UIColor whiteColor];
    cv.dataSource = self;
    cv.delegate = self;
    cv.prefetchDataSource = self;
    [self.view addSubview:cv];
    self.collectionView = cv;
    
    //-------------在seciontView之上添加视图 如：滚动banner------------------------------------------
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cv.frame), 100)];
    headerView.backgroundColor = [UIColor grayColor];
//    [cv addSubview:headerView];
    
    //--------------注册cell/header/footer，并绑定数据---------------------------------------------------
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        
        maker.registerCell([TeamInfoCell class],[TeamInfo class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            return CGSizeMake(150, 120);
        })
        .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data){
            TeamInfoCell *newCell = (TeamInfoCell *)cell;
            [newCell bindData:data];
            [newCell setBackgroundColor:[weakSelf randomColor]];
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
    [self.collectionView setData:result];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);

}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);

    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);

    return YES;
} // called when the user taps on an already-selected item in multi-select mode
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);

}

//将要展示cell
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    NSLog(@"%s",__func__);

}
//将要展示头尾
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    NSLog(@"%s",__func__);

}
//cell划出屏幕
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);

}
//头尾滑动出屏幕
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);

}

// These methods provide support for copy/paste actions on cells.
// All three should be implemented if any are.
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);

    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSLog(@"%s",__func__);
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSLog(@"%s",__func__);

}

// support for custom transition layout
//- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout;

// Focus
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    NSLog(@"%s",__func__);
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0) {
    NSLog(@"%s",__func__);
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0) {
    NSLog(@"%s",__func__);

}
//- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView NS_AVAILABLE_IOS(9_0);

//- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0);

//- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(9_0); // customize the content offset to be applied during transition or update animations

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 30, 10, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 100;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 40;
}

#pragma mark - UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0) {
//    NSLog(@"%s   ---------    %@",__func__, indexPaths);
}
#pragma mark - DWFlowAutoMoveLayoutDelegate
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
