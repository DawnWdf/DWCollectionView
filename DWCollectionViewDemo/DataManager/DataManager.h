//
//  DataManager.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/10/10.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
+ (void)teamData:(void(^)(NSMutableArray *data))data;
@end
