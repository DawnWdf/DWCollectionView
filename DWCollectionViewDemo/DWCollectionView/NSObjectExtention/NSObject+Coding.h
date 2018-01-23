//
//  NSObject+Coding.h
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/23.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Coding)
- (void)coding_encode:(NSCoder *_Nonnull)aCoder ;
- (nullable instancetype)coding_decode:(NSCoder *_Nonnull)aDecoder ;
@end



#define CodingImplmentation \
- (void)encodeWithCoder:(NSCoder *)aCoder { \
    [self coding_encode:aCoder];    \
}  \
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder { \
    if (self == [super init]){ \
        [self coding_decode:aDecoder];\
    }\
    return  self;\
}\


#define DWObjectCodingImplmentation CodingImplmentation
