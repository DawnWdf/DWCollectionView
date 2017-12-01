//
//  DWProtocolMethodImplementation.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWProtocolMethodImplementation.h"

#import <objc/runtime.h>

@implementation DWProtocolMethodImplementation

+ (void)dw_class:(Class)aclass protocolMethodImplementationFrom:(Class)original {
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        //协议需要实现的方法
        unsigned int protocolCount = 0;
        //获取当前类所有的协议
        __unsafe_unretained Protocol **allP = class_copyProtocolList(aclass, &protocolCount);
        for (int i = 0; i < protocolCount; i++) {
            Protocol *protocol = allP[i];
            BOOL conform = class_conformsToProtocol(aclass, protocol);
            if (conform) {
                unsigned int protocolMethodCount = 0;
                
                //获取协议方法描述
                struct objc_method_description *protocolDes = protocol_copyMethodDescriptionList(protocol, NO, YES, &protocolMethodCount);
                
                for (int i = 0; i < protocolMethodCount; i++) {
                    struct objc_method_description protocolObject = protocolDes[i];
                    
                    SEL selector = protocolObject.name;

                    //originalDelegate是否实现此方法
                    BOOL isOriginalResponse = class_respondsToSelector(original , selector);

                    if (isOriginalResponse) {
                    
                        Method originalMethod = class_getInstanceMethod(original, selector);
                        class_replaceMethod(aclass, selector, class_getMethodImplementation(original, selector), method_getTypeEncoding(originalMethod));
                    }

//                    //当前类是否实现此方法
//                    BOOL isResponse = class_respondsToSelector(aclass, selector);
//                    if ((!isResponse) && isOriginalResponse) {
//                        //如果当前类没有实现但是originalDelegate实现了 则替换
//
//                    }
//                    else if((!isOriginalResponse) && isResponse){
//                        //如果当前类实现了，但是originalDelegate没有实现 则将代理中的方法删除
//                        id newRespondsToSelectorBlcok = ^ void (id self, SEL selector)
//                        {
//                        };
//                        class_replaceMethod(original, selector, imp_implementationWithBlock(newRespondsToSelectorBlcok), "v@:");
//                    }
                }
            }
        }

//    });
    

}
@end
