//
//  DWSection.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWSection.h"

@implementation DWSection
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.headerData forKey:@"header"];
    [aCoder encodeObject:self.footerData forKey:@"footer"];
    [aCoder encodeObject:self.items forKey:@"items"];

}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]){
        self.headerData = [aDecoder decodeObjectForKey:@"header"];
        self.footerData = [aDecoder decodeObjectForKey:@"footer"];
        self.items = [aDecoder decodeObjectForKey:@"items"];
    }
    return  self;
}
@end
