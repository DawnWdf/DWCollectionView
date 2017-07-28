//
//  DWSection.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWSection : NSObject
@property (nonatomic, strong) id headerData;
@property (nonatomic, strong) id footerData;
@property (nonatomic, strong) NSArray *items;
@end
