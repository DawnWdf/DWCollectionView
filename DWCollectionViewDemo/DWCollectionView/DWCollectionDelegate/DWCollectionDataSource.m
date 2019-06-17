//
//  DWCollectionDataSource.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/11.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionDataSource.h"
#import "DWProtocolMethodImplementation.h"
#import "DWMapperModel.h"
#import "DWCollectionCellMaker.h"
#import "DWCollectionHeaderFooterMaker.h"
#import "NSObject+MulArgPerformSel.h"

@interface DWCollectionDataSource()

@property (nonatomic, strong) NSMutableDictionary *visableHeaderFooterViews;


@end

@implementation DWCollectionDataSource
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.originalDelegate respondsToSelector:_cmd]){
        return [self.originalDelegate numberOfSectionsInCollectionView:collectionView];
    }else if (self.data){
        return [self.data count];
    }
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([self.originalDelegate respondsToSelector:_cmd]){
        return [self.originalDelegate collectionView:collectionView numberOfItemsInSection:section];
    }else if(self.data){
        return [[self.data[section] items] count];
    }
    return 0;
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *modelString = [self modelStringForCellForIndexPath:indexPath];
    DWMapperModel *configerModel = self.configer[@"cell"][modelString];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:configerModel.viewClass forIndexPath:indexPath];
    
    if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionCellConfiger class]]) {
        DWCollectionCellConfiger *cellConfiger = (DWCollectionCellConfiger *)configerModel.makerConfig;
        if (cellConfiger.adapterBlock) {
            cellConfiger.adapterBlock(cell, indexPath, [self.data[indexPath.section] items][indexPath.row]);
        }
        
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        NSString *modelString = [self modelStringForHeaderForIndexPath:indexPath];
        DWMapperModel *configerModel = self.configer[@"header"][modelString];
        if (!configerModel) {
            if ([self.originalDelegate respondsToSelector:_cmd]){
                return [self.originalDelegate collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
            }
            return nil;
        }
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:configerModel.viewClass forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        [headerView removeGestureRecognizer:[headerView.gestureRecognizers firstObject]];
        UITapGestureRecognizer *gestur = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewDidSelected:)];
        [headerView addGestureRecognizer:gestur];
        if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionHeaderFooterConfiger class]]) {
            DWCollectionHeaderFooterConfiger *cellConfiger = (DWCollectionHeaderFooterConfiger *)configerModel.makerConfig;
            if (cellConfiger.adapterBlock) {
                cellConfiger.adapterBlock(headerView, indexPath, [self.data[indexPath.section] headerData]);
            }
            
        }
        [self.visableHeaderFooterViews setObject:headerView forKey:indexPath];

        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        NSString *modelString = [self modelStringForFooterForIndexPath:indexPath];
        DWMapperModel *configerModel = self.configer[@"footer"][modelString];
        if (!configerModel) {
            if ([self.originalDelegate respondsToSelector:_cmd]){
                return [self.originalDelegate collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
            }
            return nil;
        }
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:configerModel.viewClass forIndexPath:indexPath];
        if(footerView == nil)
        {
            footerView = [[UICollectionReusableView alloc] init];
        }
        [footerView removeGestureRecognizer:[footerView.gestureRecognizers firstObject]];
        UITapGestureRecognizer *gestur = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footerViewDidSelected:)];
        [footerView addGestureRecognizer:gestur];
        if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionHeaderFooterConfiger class]]) {
            DWCollectionHeaderFooterConfiger *cellConfiger = (DWCollectionHeaderFooterConfiger *)configerModel.makerConfig;
            if (cellConfiger.adapterBlock) {
                cellConfiger.adapterBlock(footerView, indexPath, [self.data[indexPath.section] footerData]);
            }
            
        }
        [self.visableHeaderFooterViews setObject:footerView forKey:indexPath];

        return footerView;
    }
    return nil;
}

#pragma mark - action
- (void)headerViewDidSelected:(UITapGestureRecognizer *)recognizer {
    [self recognizer:recognizer actionOn:@"header"];
}
- (void)footerViewDidSelected:(UITapGestureRecognizer *)recognizer {
    [self recognizer:recognizer actionOn:@"footer"];
}

- (void)recognizer:(UITapGestureRecognizer *)recognizer actionOn:(NSString *)kindString {
    UIView *touchedView = recognizer.view;
    CGPoint pointInCell = [recognizer locationInView:touchedView];
    UIView *superView = [touchedView superview];
    if ([superView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)superView;
        CGPoint pointInCollectionView = [touchedView convertPoint:pointInCell toView:collectionView];
        [self.visableHeaderFooterViews enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            UICollectionReusableView *view = (UICollectionReusableView *)obj;
            if (CGRectContainsPoint(view.frame, pointInCollectionView)) {
                NSIndexPath *indexPath = (NSIndexPath *)key;
                BOOL isHeader = [kindString isEqualToString:@"header"];
                NSString *modelString;
                if (isHeader) {
                    modelString = [self modelStringForHeaderForIndexPath:indexPath];
                }else{
                    modelString = [self modelStringForFooterForIndexPath:indexPath];
                }
                DWMapperModel *configerModel = self.configer[kindString][modelString];
                if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionHeaderFooterConfiger class]]) {
                    DWCollectionHeaderFooterConfiger *cellConfiger = (DWCollectionHeaderFooterConfiger *)configerModel.makerConfig;
                    if (cellConfiger.didSelectBlock) {
                        cellConfiger.didSelectBlock(recognizer, indexPath.section, [self.data[indexPath.section] headerData]);
                    }
                    
                }
            }
        }];
    }
}
#pragma mark - getter & setter
- (void)setOriginalDelegate:(id)originalDelegate{
    [super setOriginalDelegate:originalDelegate];
    
    [DWProtocolMethodImplementation dw_class:[self class] protocolMethodImplementationFrom:[originalDelegate class]];
}

- (NSMutableDictionary *)visableHeaderFooterViews {
    if (!_visableHeaderFooterViews) {
        _visableHeaderFooterViews = [[NSMutableDictionary alloc]init];
    }
    return _visableHeaderFooterViews;
}
@end
