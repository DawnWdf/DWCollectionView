//
//  DWCollectionViewDelegate.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/11.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionViewDelegate.h"
#import "NSObject+MulArgPerformSel.h"
#import "DWProtocolMethodImplementation.h"
#import "DWMapperModel.h"
#import "DWCollectionCellMaker.h"
#import "DWCollectionHeaderFooterMaker.h"
#import <objc/runtime.h>

@implementation DWCollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    NSValue *value = [NSObject dw_target:self.originalDelegate performSel:_cmd arguments:collectionView,collectionViewLayout,section, nil];
    if (value) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        [value getValue:&insets];
        return insets;
    }
    if(collectionViewLayout){
        if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            return [(UICollectionViewFlowLayout *)collectionViewLayout sectionInset];
        }
    }
    return UIEdgeInsetsZero;
}




- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    NSNumber *value = [NSObject dw_target:self.originalDelegate performSel:_cmd arguments:collectionView,collectionViewLayout,section, nil];
    
    if (value) {
        return [value floatValue];
    }
    
    if(collectionViewLayout){
        if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            return [(UICollectionViewFlowLayout *)collectionViewLayout minimumLineSpacing];
        }
    }
    return CGFLOAT_MIN;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    NSNumber *value = [NSObject dw_target:self.originalDelegate performSel:_cmd arguments:collectionView,collectionViewLayout,section, nil];
    if (value) {
        return [value floatValue];
    }
    if(collectionViewLayout){
        if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            return [(UICollectionViewFlowLayout *)collectionViewLayout minimumInteritemSpacing];
        }
    }
    return CGFLOAT_MIN;
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
    if ([self.originalDelegate respondsToSelector:_cmd]){
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]){
        return [(UICollectionViewFlowLayout *)collectionViewLayout itemSize];
        
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
    if ([self.originalDelegate respondsToSelector:_cmd]){
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]){
        return [(UICollectionViewFlowLayout *)collectionViewLayout headerReferenceSize];
        
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
    if ([self.originalDelegate respondsToSelector:_cmd]){
        return [self.originalDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]){
        return [(UICollectionViewFlowLayout *)collectionViewLayout footerReferenceSize];
        
    }
    
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *modelString = [self modelStringForCellForIndexPath:indexPath];
    DWMapperModel *configerModel = self.configer[@"cell"][modelString];
    
    if ((configerModel.makerConfig) && [configerModel.makerConfig isKindOfClass:[DWCollectionCellConfiger class]]) {
        DWCollectionCellConfiger *cellConfiger = (DWCollectionCellConfiger *)configerModel.makerConfig;
        if (cellConfiger.didSelectBlock) {
            
            cellConfiger.didSelectBlock(indexPath, [self.data[indexPath.section] items][indexPath.row]);
        }
        
    }
      
    if ([self.originalDelegate respondsToSelector:_cmd]){
     
        [self.originalDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}
#pragma mark - UICollectionViewDelegate

#pragma mark - getter & setter
- (void)setOriginalDelegate:(id)originalDelegate{
    [super setOriginalDelegate:originalDelegate];
    
    [DWProtocolMethodImplementation dw_class:[self class] protocolMethodImplementationFrom:[originalDelegate class]];
}
@end
