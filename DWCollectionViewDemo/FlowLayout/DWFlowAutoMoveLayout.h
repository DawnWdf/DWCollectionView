//
//  DWFlowAutoMoveLayout.h
//  DWCollectionViewDemo
//
//  Created by DawnWang on 2017/9/16.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWFlowLayout.h"

@protocol DWFlowAutoMoveLayoutDelegate <NSObject>

- (BOOL)dw_collectionView:(UICollectionView *)collectionView canMoveItemAtIndex:(NSIndexPath *)indexPath;
- (void)dw_collectionView:(UICollectionView *)collectionView didMoveItemAtIndex:(NSIndexPath *)fromIndexPath toIndex:(NSIndexPath *)toIndexPath;
@end

@interface DWFlowAutoMoveLayout : DWFlowLayout

@end
