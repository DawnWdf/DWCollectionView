//
//  DWFlowAutoMoveLayout.h
//  DWCollectionViewDemo
//
//  Created by DawnWang on 2017/9/16.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWFlowLayout.h"

@protocol DWFlowAutoMoveLayoutDelegate <NSObject>

@required

- (BOOL)dw_collectionView:(UICollectionView *)collectionView canMoveItemAtIndex:(NSIndexPath *)indexPath;
//在移动的过程中所有位置改变的cell都会调用这个方法
- (void)dw_collectionView:(UICollectionView *)collectionView didMoveItemAtIndex:(NSIndexPath *)fromIndexPath toIndex:(NSIndexPath *)toIndexPath;

@optional
- (void)dw_collectionView:(UICollectionView *)collectionView willMoveItemAtIndex:(NSIndexPath *)fromIndexPath toIndex:(NSIndexPath *)toIndexPath;
//手势结束，确定最终位置时执行
- (void)dw_collectionView:(UICollectionView *)collectionView willEndMoveItemAtIndex:(NSIndexPath *)fromIndexPath toIndex:(NSIndexPath *)toIndexPath;
- (void)dw_collectionView:(UICollectionView *)collectionView didEndMoveItemAtIndex:(NSIndexPath *)fromIndexPath toIndex:(NSIndexPath *)toIndexPath;

@end

@interface DWFlowAutoMoveLayout : DWFlowLayout

@property (nonatomic, weak) id<DWFlowAutoMoveLayoutDelegate> delegate;

@end
