//
//  NSObject+Coding.m
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/23.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "NSObject+Coding.h"

#import <objc/runtime.h>
#import "NSObject+Class.h"



@implementation NSObject (Coding)
- (void)dw_enumPropertyList:(void(^)(id key, id value))emunBlock {
    
    //获取当前类及父类
    [self dw_enumClass:^(__unsafe_unretained Class cl, BOOL *stop) {
        //根据获取的类的名称得到所有属性相关信息
        [self dw_propertyForClass:cl finish:^(PropertyModel *pModel) {
            NSString *attributeTypeString = pModel.propertyType;//此处为了方便只获取了属性名称 使用PropertyModel便于扩展
            NSString *name = pModel.name;
            //判断当前属性是否支持coding协议
            if ([attributeTypeString hasPrefix:@"@\""]) {//对象类型都是以@"开头
                attributeTypeString = [attributeTypeString substringWithRange:NSMakeRange(2, attributeTypeString.length - 3)];
                
                Class attributeClass = NSClassFromString(attributeTypeString);
                
                
                BOOL isConformCoding = class_conformsToProtocol(attributeClass, NSProtocolFromString(@"NSCoding"));
                NSString *message = [NSString stringWithFormat:@"model:%@ 不支持NSCoding协议",attributeTypeString];
                NSAssert(isConformCoding, message);
            }
            
            if (emunBlock) {
                emunBlock(name,[self valueForKey:name]);
            }
        }];
    }];
}

- (void)dw_coding_encode:(NSCoder *)aCoder {
    //获取当前类属性名称及值
    [self dw_enumPropertyList:^(id key, id value) {
        //归档常规方法
        [aCoder encodeObject:value forKey:key];
    }];
}
- (nullable instancetype)dw_coding_decode:(NSCoder *)aDecoder {
    [self dw_enumPropertyList:^(id key, id value) {
        
        [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
    }];
    
    return self;
}

@end
