//
//  NSObject+Class.m
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/27.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "NSObject+Class.h"
#import <objc/runtime.h>


@implementation PropertyModel
@end


@implementation NSObject (Class)

NSSet *foundationClasses(){
    return [NSSet setWithObjects:
            [NSURL class],
            [NSDate class],
            [NSValue class],
            [NSData class],
            [NSError class],
            [NSArray class],
            [NSDictionary class],
            [NSString class],
            [NSAttributedString class],
            nil];

}

BOOL isClassForFoundatation(Class class){
    __block BOOL result = NO;
    [foundationClasses() enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([class isSubclassOfClass:obj] || (class == [NSObject class])) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}


- (void)enumClass:(void(^)(Class cl, BOOL *stop))enumBlock {
    if (!enumBlock) {
        return;
    }
    BOOL sstop = NO;
    
    Class c = self.class;
    
    while (c && !sstop) {
        
        enumBlock(c,&sstop);
        
        c = class_getSuperclass(c);
        
        
        if (isClassForFoundatation(c)) {
            break ;
        }
    }
    
    
}


- (void)propertyForClass:(Class)cl finish:(void(^)(PropertyModel *pModel))finish {
    if (!finish) {
        return;
    }
    
    unsigned int count;

    objc_property_t *properties = class_copyPropertyList(cl, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t p = properties[i];
        NSString *name = @(property_getName(p));
        if ([name isEqualToString:@"primaryKey"] ||[name isEqualToString:@"rowid"]
            || [name isEqualToString:@"hash"]|| [name isEqualToString:@"superclass"]||[name isEqualToString:@"description"] ||[name isEqualToString:@"debugDescription"]){
            continue;
        }
        NSString *attribute = @(property_getAttributes(p));
        NSRange dotLocation = [attribute rangeOfString:@","];
        NSString *attributeTypeString ;
        if (dotLocation.location == NSNotFound) {
            attributeTypeString = [attribute substringFromIndex:1];
        }else{
            attributeTypeString = [attribute substringWithRange:NSMakeRange(1, dotLocation.location - 1)];
        }
        
        PropertyModel *model = [PropertyModel new];
        model.name = name;
        model.propertyType = attributeTypeString;
        
        finish(model);
    }
    free(properties);

}


@end
