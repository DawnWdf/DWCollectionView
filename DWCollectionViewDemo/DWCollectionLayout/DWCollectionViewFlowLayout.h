//
//  CollectionViewFlowLayout.h
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/28.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWCollectionViewFlowLayout : UICollectionViewFlowLayout

- (UIEdgeInsets (^)(NSInteger section))dw_insetForSection;
- (void)setDw_insetForSection:(UIEdgeInsets(^)(NSInteger section))insetForSection;

@end
