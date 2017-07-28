//
//  DWCollectionCellMaker.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef CGSize(^DWCollectionCellItemSizeBlock)(NSIndexPath *indexPath, id data);

typedef void (^DWCollectionCellAdapterBlock)(UICollectionViewCell *cell , NSIndexPath *indexPath, id data);

@interface DWCollectionCellConfiger : NSObject

@property (nonatomic, copy) DWCollectionCellItemSizeBlock itemSizeBlock;
@property (nonatomic, copy) DWCollectionCellAdapterBlock adapterBlock;

@end

@interface DWCollectionCellMaker : NSObject

@property (nonatomic, strong) DWCollectionCellConfiger *cellConfiger;

- (DWCollectionCellMaker *(^)(DWCollectionCellItemSizeBlock))itemSize;
- (DWCollectionCellMaker *(^)(DWCollectionCellAdapterBlock))adapter;

@end
