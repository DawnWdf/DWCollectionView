//
//  DWCollectionHeaderFooterMaker.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DWCollectionHeaderFooterAdapterBlcok)(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data);
typedef CGSize(^DWCollectionHeaderFooterSizeBlock)(UICollectionViewLayout *layout,NSInteger section, id data);
typedef void (^DWCollectionHeaderFooterDidSelectedBlock)(UITapGestureRecognizer *recognizer, NSInteger section , id data);

@interface DWCollectionHeaderFooterConfiger : NSObject

@property (nonatomic, copy) DWCollectionHeaderFooterAdapterBlcok adapterBlock;
@property (nonatomic, copy) DWCollectionHeaderFooterSizeBlock sizeBlock;
@property (nonatomic, copy) DWCollectionHeaderFooterDidSelectedBlock didSelectBlock;
@end

@interface DWCollectionHeaderFooterMaker : NSObject


@property (nonatomic, strong) DWCollectionHeaderFooterConfiger *configer;

- (DWCollectionHeaderFooterMaker *(^)(DWCollectionHeaderFooterAdapterBlcok))adapter;
- (DWCollectionHeaderFooterMaker *(^)(DWCollectionHeaderFooterSizeBlock))sizeConfiger;
- (DWCollectionHeaderFooterMaker *(^)(DWCollectionHeaderFooterDidSelectedBlock))didSelect;///TODO:
@end
