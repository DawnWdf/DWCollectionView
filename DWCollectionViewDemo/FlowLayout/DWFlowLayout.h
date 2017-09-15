//
//  DWFlowLayout.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/14.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef CGFloat(^DWCollectionViewFlowLayoutItemHeightBlock)(NSIndexPath *indexPath);
typedef UIEdgeInsets(^DWCollectionViewFlowLayoutHeaderEdgeInsets)(NSInteger section);
typedef UIEdgeInsets(^DWCollectionViewFlowLayoutFooterEdgeInsets)(NSInteger section);

@interface DWFlowLayout : UICollectionViewFlowLayout

///collectionView的边距
@property (nonatomic) UIEdgeInsets boundEdgeInsets;

//flow layout
///collectionView列数
@property (nonatomic) NSInteger numberOfColumn;
///行与行之间的距离
@property (nonatomic) CGFloat lineSpace;
///列与列之间的距离
@property (nonatomic) CGFloat interitemSpace;
///头尾高度
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;
///item 高度
@property (nonatomic, copy) DWCollectionViewFlowLayoutItemHeightBlock itemHeightBlock;
///头的边距
@property (nonatomic, copy) DWCollectionViewFlowLayoutHeaderEdgeInsets headerEdgeInsets;
///尾的边距
@property (nonatomic, copy) DWCollectionViewFlowLayoutFooterEdgeInsets footerEdgeInsets;

@end
