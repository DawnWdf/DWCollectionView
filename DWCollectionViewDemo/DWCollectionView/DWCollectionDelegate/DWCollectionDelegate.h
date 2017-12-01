//
//  DWCollectionDelegate.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DWSection.h"

#define DW_CheckSelfClass(calssName) \
calssName *trueSelf = self; \
if ([self isKindOfClass:[DWCollectionDelegate class]]) { \
DWCollectionDelegate *delegate = (DWCollectionDelegate *)self; \
id original = delegate.originalDelegate; \
if ([original isKindOfClass:[calssName class]]) { \
calssName *vc = (calssName *)original; \
trueSelf = vc;\
}else{ \
return; \
} \
}else if([self isKindOfClass:[calssName class]]){ \
trueSelf = self; \
} \
\

@interface DWCollectionDelegate : NSObject

@property (nonatomic, weak) id originalDelegate;

@property (nonatomic, strong) NSDictionary *configer;

@property (nonatomic, strong) NSArray<DWSection *> *data;



- (NSString *)modelStringForCellForIndexPath:(NSIndexPath *)indexPath ;

- (NSString *)modelStringForHeaderForIndexPath:(NSIndexPath *)indexPath ;

- (NSString *)modelStringForFooterForIndexPath:(NSIndexPath *)indexPath ;

@end
