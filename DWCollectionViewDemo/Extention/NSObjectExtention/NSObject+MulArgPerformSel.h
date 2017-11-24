//
//  NSObject+MulArgPerformSel.h
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/7/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSObject (MulArgPerformSel)

+ (id)dw_target:(id)target performSel:(SEL)sel arguments:(id)firstObj,... NS_REQUIRES_NIL_TERMINATION ;

@end
