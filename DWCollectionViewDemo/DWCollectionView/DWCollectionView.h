//
//  DWCollectionView.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWCollectionDelegateMaker.h"
#import "DWSection.h"

typedef void (^DWCollectionViewCellMaker)();


@interface DWCollectionView : UICollectionView

- (void)registerViewAndModel:(void(^)(DWCollectionDelegateMaker *maker))maker;

- (void)setData:(NSArray<DWSection *> *)data;

@end
