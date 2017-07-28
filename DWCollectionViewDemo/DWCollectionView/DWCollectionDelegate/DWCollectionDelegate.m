//
//  DWCollectionDelegate.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionDelegate.h"
#import "DWProtocolMethodImplementation.h"
#import "DWCollectionDelegateMaker.h"
#import <objc/runtime.h>
#import "NSObject+MulArgPerformSel.h"

typedef struct{
    CGFloat dw_f;
    UIEdgeInsets dw_inset;
}DWReturnValue;

@implementation DWCollectionDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - custom

- (NSString *)modelStringForCellForIndexPath:(NSIndexPath *)indexPath {
    if (!self.data) {
        return nil;
    }
    
    DWSection *section = self.data[indexPath.section];
    id model = [[section items] objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[NSString class]] || [model isKindOfClass:[@"" class]]) {
        return @"NSString";
    }
    return NSStringFromClass([model class]);
}

- (NSString *)modelStringForHeaderForIndexPath:(NSIndexPath *)indexPath {
    if (!self.data) {
        return nil;
    }
    
    DWSection *section = self.data[indexPath.section];
    id model = section.headerData;
    if ([model isKindOfClass:[NSString class]] || [model isKindOfClass:[@"" class]]) {
        return @"NSString";
    }
    return NSStringFromClass([model class]);
}

- (NSString *)modelStringForFooterForIndexPath:(NSIndexPath *)indexPath {
    if (!self.data) {
        return nil;
    }
    
    DWSection *section = self.data[indexPath.section];
    id model = section.footerData;
    if ([model isKindOfClass:[NSString class]] || [model isKindOfClass:[@"" class]]) {
        return @"NSString";
    }
    return NSStringFromClass([model class]);
}

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
/*
#define OriginalDelegateResponse(method) \
if ([self.originalDelegate respondsToSelector:]) {\
return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];\
}
*/
#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    NSValue *value = [NSObject dw_target:self.originalDelegate performSel:_cmd arguments:collectionView,collectionViewLayout, nil];
    UIEdgeInsets insets = UIEdgeInsetsZero;
    [value getValue:&insets];
    return insets;
}




- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    NSNumber *value = [NSObject dw_target:self.originalDelegate performSel:_cmd arguments:collectionView,collectionViewLayout,@(section), nil];

    if (!value) {
        return CGFLOAT_MIN;
    }
    return [value floatValue];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    NSNumber *value = [NSObject dw_target:self.originalDelegate performSel:_cmd arguments:collectionView,collectionViewLayout,@(section), nil];
    if (!value) {
        return CGFLOAT_MIN;
    }
    return [value floatValue];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *modelString = [self modelStringForCellForIndexPath:indexPath];
    DWMapperModel *configerModel = self.configer[@"cell"][modelString];
    
    if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionCellConfiger class]]) {
        DWCollectionCellConfiger *cellConfiger = (DWCollectionCellConfiger *)configerModel.makerConfig;
        if (cellConfiger.itemSizeBlock) {

            return cellConfiger.itemSizeBlock(indexPath, [self.data[indexPath.section] items][indexPath.row]);
        }
        
    }

    return CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    NSString *modelString = [self modelStringForHeaderForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    DWMapperModel *configerModel = self.configer[@"header"][modelString];
    if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionHeaderFooterConfiger class]]) {
        DWCollectionHeaderFooterConfiger *cellConfiger = (DWCollectionHeaderFooterConfiger *)configerModel.makerConfig;
        if (cellConfiger.sizeBlock) {

            return cellConfiger.sizeBlock(collectionViewLayout,section,self.data[section].headerData);
        }
        
    }

    return CGSizeZero;
    //如果使用CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN) 会导致was not retrieved by calling -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPat的崩溃信息
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    NSString *modelString = [self modelStringForFooterForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    DWMapperModel *configerModel = self.configer[@"footer"][modelString];

    if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionHeaderFooterConfiger class]]) {
        DWCollectionHeaderFooterConfiger *cellConfiger = (DWCollectionHeaderFooterConfiger *)configerModel.makerConfig;
        if (cellConfiger.sizeBlock) {

          return cellConfiger.sizeBlock(collectionViewLayout, section, self.data[section].footerData);
        }
        
    }

    return CGSizeZero;
}




#pragma mark - getter & setter
- (void)setOriginalDelegate:(id)originalDelegate{
    _originalDelegate = originalDelegate;

    [DWProtocolMethodImplementation dw_class:[self class] protocolMethodImplementationFrom:[originalDelegate class]];
}
@end
