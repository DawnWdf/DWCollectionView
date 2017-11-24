//
//  NSObject+Class.h
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/27.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PropertyModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *propertyType;

@end



/**
 扩展类 获取当前对象及所有的父类class 排除NS类型
 */
@interface NSObject (Class)

- (void)enumClass:(void(^)(Class cl, BOOL *stop))enumBlock;

- (void)propertyForClass:(Class)cl finish:(void(^)(PropertyModel *pModel))finish;

@end
