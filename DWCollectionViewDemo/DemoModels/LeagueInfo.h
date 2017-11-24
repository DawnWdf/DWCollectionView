//
//  LeagueInfo.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/25.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Coding.h"

@interface LeagueInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *leagueTypeCn;
@property (nonatomic, copy) NSString *season;
@property (nonatomic) long maxRound;

@end
