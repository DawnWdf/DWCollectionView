//
//  NSObject+MulArgPerformSel.m
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/7/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "NSObject+MulArgPerformSel.h"



@implementation NSObject (MulArgPerformSel)

+ (id)dw_target:(id)target performSel:(SEL)sel arguments:(id)firstObj,... NS_REQUIRES_NIL_TERMINATION {
    //获取信号量
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    if(!signature){
        return nil;
    }
        
    NSInteger numberOfArguments = signature.numberOfArguments;
    
    //配置invocation并执行 获取返回参数
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = sel;
    invocation.target = target;
    
    //获取可变参数
    va_list list;
    va_start(list, firstObj);
    int i = 0;
    //由于参数可能是NSInteger所以此处要使用__unsafe_unretained 否则会崩溃，不确定是否因为在ARC情况下使用强引用来setArgument是不安全的，我不知道我在说什么乱七八糟的
    for (__unsafe_unretained id temp = firstObj;temp != nil;temp = va_arg(list, id)){
        if (i >= numberOfArguments - 2){
            break;
        }
        [invocation setArgument:&temp atIndex:i + 2];
        i++;
    }
    
    [invocation retainArguments];
    va_end(list);
    if ([invocation.target respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:invocation.target];
    }else{
        return nil;
    }
    
    const char *returnType = signature.methodReturnType;

    id  returnValue;

    if( !strcmp(returnType, @encode(void)) ){
        returnValue =  nil;
    }else if( !strcmp(returnType, @encode(id)) ){
        [invocation getReturnValue:&returnValue];
    }else{
        NSUInteger length = [signature methodReturnLength];
        
        void *buffer = (void *)malloc(length);
        [invocation getReturnValue:buffer];
        
        if (strcmp(returnType, @encode(char)) == 0) {
            returnValue = [NSNumber numberWithChar:*((char*)buffer)];
        } else if (strcmp(returnType, @encode(int)) == 0) {
            returnValue = [NSNumber numberWithInt:*((int *)buffer)];
        } else if (strcmp(returnType, @encode(short)) == 0) {
            returnValue = [NSNumber numberWithShort:*((short *)buffer)];
        } else if (strcmp(returnType, @encode(long)) == 0) {
            returnValue = [NSNumber numberWithLong:*((long *)buffer)];
        } else if (strcmp(returnType, @encode(long long)) == 0) {
            returnValue = [NSNumber numberWithLongLong:*((long long *)buffer)];
        } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
            returnValue = [NSNumber numberWithUnsignedChar:*((unsigned char *)buffer)];
        } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
            returnValue = [NSNumber numberWithUnsignedInt:*((unsigned int *)buffer)];
        } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
            returnValue = [NSNumber numberWithUnsignedShort:*((unsigned short *)buffer)];
        } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
            returnValue = [NSNumber numberWithUnsignedLong:*((unsigned long *)buffer)];
        } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
            returnValue = [NSNumber numberWithUnsignedLongLong:*((unsigned long long *)buffer)];
        } else if (strcmp(returnType, @encode(float)) == 0) {
            returnValue = [NSNumber numberWithFloat:*((float *)buffer)];
        } else if (strcmp(returnType, @encode(double)) == 0) {
            returnValue = [NSNumber numberWithDouble:*((double *)buffer)];
        } else if (strcmp(returnType, @encode(BOOL)) == 0) {
            returnValue = [NSNumber numberWithBool:*((BOOL *)buffer)];
        } else {
            returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
        }

    }
    return returnValue;

}
@end
