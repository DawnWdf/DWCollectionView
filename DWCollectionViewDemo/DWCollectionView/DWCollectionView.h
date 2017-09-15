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
#import "DWRefreshManagerProtocol.h"


typedef void (^DWCollectionViewCellMaker)();


@interface DWCollectionView : UICollectionView


@property (nonatomic, strong) id <DWRefreshManagerProtocol> refreshManager;

/**
    警惕循环引用
 */
- (void)registerViewAndModel:(void(^)(DWCollectionDelegateMaker *maker))maker;

- (void)setData:(NSArray<DWSection *> *)data;

@end
