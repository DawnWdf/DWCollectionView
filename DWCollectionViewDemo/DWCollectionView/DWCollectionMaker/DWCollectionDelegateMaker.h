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

@interface DWCollectionDelegateMaker : NSObject

@property (nonatomic, strong) NSMutableDictionary *cellRegister;//modelclass = modelclass
@property (nonatomic, strong) NSMutableDictionary *headerRegister;
@property (nonatomic, strong) NSMutableDictionary *footerRegister; ///<NSString *,DWMapperModel *>


- (DWCollectionCellMaker *(^)(Class cellClass,Class modelClass))registerCell;
- (DWCollectionHeaderFooterMaker *(^)(Class viewClass, Class modelClass))registerHeader;
- (DWCollectionHeaderFooterMaker *(^)(Class viewClass, Class modelClass))registerFooter;
@end
