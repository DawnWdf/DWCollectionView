//
//  DWCollectionCellMaker.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionCellMaker.h"

@implementation DWCollectionCellConfiger


@end

@implementation DWCollectionCellMaker

- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellConfiger = [[DWCollectionCellConfiger alloc] init];
    }
    return self;
}

- (DWCollectionCellMaker *(^)(DWCollectionCellItemSizeBlock))itemSize {
    return ^DWCollectionCellMaker *(DWCollectionCellItemSizeBlock block){
        self.cellConfiger.itemSizeBlock  = block;
        return self;
    };
    
}
- (DWCollectionCellMaker *(^)(DWCollectionCellAdapterBlock))adapter {
    return ^DWCollectionCellMaker *(DWCollectionCellAdapterBlock block){
        self.cellConfiger.adapterBlock = block;
        return self;
    };
}
@end
