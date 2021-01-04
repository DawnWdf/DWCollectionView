//
//  NSObject+Coding.h
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/23.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Coding)
- (void)dw_coding_encode:(NSCoder *_Nonnull)aCoder ;
- (nullable instancetype)dw_coding_decode:(NSCoder *_Nonnull)aDecoder ;
@end



#define dw_CodingImplmentation \
- (void)encodeWithCoder:(NSCoder *)aCoder { \
    [self dw_coding_encode:aCoder];    \
}  \
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder { \
    if (self == [super init]){ \
        [self dw_coding_decode:aDecoder];\
    }\
    return  self;\
}\


#define DWObjectCodingImplmentation dw_CodingImplmentation
