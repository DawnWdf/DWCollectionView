//
//  UserCenterHeaderModel.h
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterHeaderModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *subTitle;
@property (nonatomic) BOOL showArrow;
@end
