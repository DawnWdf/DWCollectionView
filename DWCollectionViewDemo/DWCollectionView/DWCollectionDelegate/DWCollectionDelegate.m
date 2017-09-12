//
//  DWCollectionDelegate.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionDelegate.h"
#import "DWProtocolMethodImplementation.h"
#import "DWCollectionDelegateMaker.h"
#import <objc/runtime.h>
//#import "NSObject+MulArgPerformSel.h"

typedef struct{
    CGFloat dw_f;
    UIEdgeInsets dw_inset;
}DWReturnValue;

@implementation DWCollectionDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - custom

- (NSString *)modelStringForCellForIndexPath:(NSIndexPath *)indexPath {
    if (!self.data) {
        return nil;
    }
    
    DWSection *section = self.data[indexPath.section];
    id model = [[section items] objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[NSString class]] || [model isKindOfClass:[@"" class]]) {
        return @"NSString";
    }
    return NSStringFromClass([model class]);
}

- (NSString *)modelStringForHeaderForIndexPath:(NSIndexPath *)indexPath {
    if (!self.data) {
        return nil;
    }
    
    DWSection *section = self.data[indexPath.section];
    id model = section.headerData;
    if ([model isKindOfClass:[NSString class]] || [model isKindOfClass:[@"" class]]) {
        return @"NSString";
    }
    return NSStringFromClass([model class]);
}

- (NSString *)modelStringForFooterForIndexPath:(NSIndexPath *)indexPath {
    if (!self.data) {
        return nil;
    }
    
    DWSection *section = self.data[indexPath.section];
    id model = section.footerData;
    if ([model isKindOfClass:[NSString class]] || [model isKindOfClass:[@"" class]]) {
        return @"NSString";
    }
    return NSStringFromClass([model class]);
}


#pragma mark - getter & setter
- (void)setOriginalDelegate:(id)originalDelegate NS_REQUIRES_SUPER {
    _originalDelegate = originalDelegate;
}
@end
