//
//  UserCenterViewModel.h
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterViewModel : NSObject
- (void)getUserCenterData:(void(^)(NSArray *))data;
@end
