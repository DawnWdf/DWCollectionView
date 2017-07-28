//
//  DWCollectionDelegateMaker.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWCollectionCellMaker.h"
#import "DWCollectionHeaderFooterMaker.h"

#import "DWMapperModel.h"

@interface DWCollectionDelegateMaker : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSString *,DWMapperModel *> *cellRegister;//modelclass = modelclass
@property (nonatomic, strong) NSMutableDictionary<NSString *,DWMapperModel *> *headerRegister;
@property (nonatomic, strong) NSMutableDictionary<NSString *,DWMapperModel *> *footerRegister;


- (DWCollectionCellMaker *(^)(Class cellClass,Class modelClass))registerCell;
- (DWCollectionHeaderFooterMaker *(^)(Class viewClass, Class modelClass))registerHeader;
- (DWCollectionHeaderFooterMaker *(^)(Class viewClass, Class modelClass))registerFooter;
@end
