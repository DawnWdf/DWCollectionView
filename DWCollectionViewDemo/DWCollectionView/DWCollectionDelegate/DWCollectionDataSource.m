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


@implementation DWCollectionDataSource
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.data count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[self.data[section] items] count];
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
        if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionHeaderFooterConfiger class]]) {
            DWCollectionHeaderFooterConfiger *cellConfiger = (DWCollectionHeaderFooterConfiger *)configerModel.makerConfig;
            if (cellConfiger.adapterBlock) {
                cellConfiger.adapterBlock(headerView, indexPath, [self.data[indexPath.section] headerData]);
            }
            
        }
        
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
        if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionHeaderFooterConfiger class]]) {
            DWCollectionHeaderFooterConfiger *cellConfiger = (DWCollectionHeaderFooterConfiger *)configerModel.makerConfig;
            if (cellConfiger.adapterBlock) {
                cellConfiger.adapterBlock(footerView, indexPath, [self.data[indexPath.section] footerData]);
            }
            
        }
        return footerView;
    }
    return nil;
}


#pragma mark - getter & setter
- (void)setOriginalDelegate:(id)originalDelegate{
    [super setOriginalDelegate:originalDelegate];
    
    [DWProtocolMethodImplementation dw_class:[self class] protocolMethodImplementationFrom:[originalDelegate class]];
}
@end
