//
//  DWCollectionDelegateMaker.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionDelegateMaker.h"

#import "DWMapperModel.h"

@interface DWCollectionDelegateMaker()


@end

@implementation DWCollectionDelegateMaker

- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellRegister = [[NSMutableDictionary alloc] init];
        self.headerRegister = [[NSMutableDictionary alloc] init];
        self.footerRegister = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (DWCollectionCellMaker *(^)(Class cellClass,Class modelClass))registerCell {
    
    return ^DWCollectionCellMaker *(Class cellClass,Class modelClass){
        DWCollectionCellMaker *cellMaker = [[DWCollectionCellMaker alloc] init];

        DWMapperModel *model = [[DWMapperModel alloc] init];
        model.viewClass = NSStringFromClass(cellClass);
        model.modelClass = NSStringFromClass(modelClass);
        model.type = DWMapperType_Cell;
        model.makerConfig = cellMaker.cellConfiger;
        
        self.cellRegister[NSStringFromClass(modelClass)] = model;
       
        return cellMaker;
    };
}
- (DWCollectionHeaderFooterMaker *(^)(Class viewClass, Class modelClass))registerHeader {
    return ^DWCollectionHeaderFooterMaker *(Class viewClss , Class modelClass){
        DWCollectionHeaderFooterMaker *maker = [[DWCollectionHeaderFooterMaker alloc]init];
        DWMapperModel *model = [[DWMapperModel alloc] init];
        model.viewClass = NSStringFromClass(viewClss);
        model.modelClass = NSStringFromClass(modelClass);
        model.type = DWMapperType_Header;
        model.makerConfig = maker.configer;
        self.headerRegister[NSStringFromClass(modelClass)] = model;
        return maker;
    };
}
- (DWCollectionHeaderFooterMaker *(^)(Class viewClass, Class modelClass))registerFooter {
    return ^DWCollectionHeaderFooterMaker *(Class viewClss , Class modelClass){
        DWCollectionHeaderFooterMaker *maker = [[DWCollectionHeaderFooterMaker alloc]init];
        DWMapperModel *model = [[DWMapperModel alloc] init];
        model.viewClass = NSStringFromClass(viewClss);
        model.modelClass = NSStringFromClass(modelClass);
        model.type = DWMapperType_Footer;
        model.makerConfig = maker.configer;
        self.footerRegister[NSStringFromClass(modelClass)] = model;
        return maker;
    };
}


#pragma mark - getter & setter


@end
