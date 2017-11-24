//
//  GASCollectionViewFlowLayout.h
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/28.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, copy) UIEdgeInsets(^dw_insetForSection)(NSInteger section);
@end
