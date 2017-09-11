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

@interface DWCollectionDelegate : NSObject

@property (nonatomic, weak) id originalDelegate;

@property (nonatomic, strong) NSDictionary *configer;

@property (nonatomic, strong) NSArray<DWSection *> *data;



- (NSString *)modelStringForCellForIndexPath:(NSIndexPath *)indexPath ;

- (NSString *)modelStringForHeaderForIndexPath:(NSIndexPath *)indexPath ;

- (NSString *)modelStringForFooterForIndexPath:(NSIndexPath *)indexPath ;

@end
