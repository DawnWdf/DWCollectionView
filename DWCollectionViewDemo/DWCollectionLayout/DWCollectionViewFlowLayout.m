//
//  CollectionViewFlowLayout.m
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/28.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionViewFlowLayout.h"
@interface DWCollectionViewFlowLayout()

@property (nonatomic, copy) UIEdgeInsets(^insetForSection)(NSInteger section);

@end

@implementation DWCollectionViewFlowLayout
- (UIEdgeInsets (^)(NSInteger section))dw_insetForSection {
    return self.insetForSection;
}
- (void)setDw_insetForSection:(UIEdgeInsets(^)(NSInteger section))insetForSection {
    self.insetForSection = insetForSection;
}
@end
