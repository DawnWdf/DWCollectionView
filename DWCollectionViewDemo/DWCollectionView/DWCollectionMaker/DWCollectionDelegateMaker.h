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
@property (nonatomic, copy, readonly) DWCollectionCellMaker *(^registerCell)(Class cellClass, Class modelClass);
@property (nonatomic, copy, readonly) DWCollectionHeaderFooterMaker *(^registerHeader)(Class viewClass, Class modelClass);
@property (nonatomic, copy, readonly) DWCollectionHeaderFooterMaker *(^registerFooter)(Class viewClass, Class modelClass);


@end
