//
//  DWCollectionHeaderFooterMaker.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionHeaderFooterMaker.h"

@implementation DWCollectionHeaderFooterConfiger


@end

@implementation DWCollectionHeaderFooterMaker

- (instancetype)init {
    self = [super init];
    if (self) {
        self.configer = [[DWCollectionHeaderFooterConfiger alloc] init];
    }
    return self;
}

- (DWCollectionHeaderFooterMaker *(^)(DWCollectionHeaderFooterAdapterBlcok))adapter {
    return ^DWCollectionHeaderFooterMaker*(DWCollectionHeaderFooterAdapterBlcok block){
        self.configer.adapterBlock = block;
        return self;
    };
}
- (DWCollectionHeaderFooterMaker *(^)(DWCollectionHeaderFooterSizeBlock))sizeConfiger {
    return ^DWCollectionHeaderFooterMaker *(DWCollectionHeaderFooterSizeBlock block){
        self.configer.sizeBlock = block;
        return self;
    };
}
@end
