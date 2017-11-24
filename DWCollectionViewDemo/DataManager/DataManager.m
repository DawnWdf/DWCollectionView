//
//  DataManager.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/10/10.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DataManager.h"
#import <DWCollection/DWCollection.h>
#import "LeagueInfo.h"
#import "TeamInfo.h"

@interface DataManager ()
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, copy) void(^dataBlock)(NSMutableArray *result);
@end

@implementation DataManager

+ (void)teamData:(void(^)(NSMutableArray *data))data {
    DataManager *manager = [[DataManager alloc] init];
    id result = [manager getTeamData];
    manager.dataBlock = data;
    if (result && [result isKindOfClass:[NSArray class]]) {
        if (data) {
            data(result);
        }
    }else{
        [manager requestData];
    }
}


- (void)requestData {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://apicloud.mob.com/football/league/queryParam?key=1c3d999f473ee"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        NSError *jsonError = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        if ((!jsonError) && [result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = (NSDictionary *)result;
            NSInteger code = [resultDic[@"retCode"] integerValue];
            if (code == 200) {
                [self listFrom:resultDic[@"result"]];
            }else{
            }
        }
    }];
    [task resume];
}
- (void)listFrom:(NSDictionary *)dic {
    NSMutableArray *result = [NSMutableArray array];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *value = (NSArray *)obj;
            [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DWSection *section = [[DWSection alloc] init];
                LeagueInfo *league = [[LeagueInfo alloc] init];
                league.leagueTypeCn = obj[@"leagueTypeCn"];
                league.maxRound = [obj[@"maxRound"] longValue];
                league.season = obj[@"season"];
                section.headerData = league;
                NSArray *teamInfos = obj[@"teamInfoSet"];
                NSMutableArray *teams = [NSMutableArray array];
                [teamInfos enumerateObjectsUsingBlock:^(id  _Nonnull sobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TeamInfo *info = [[TeamInfo alloc] init];
                    info.teamNameCn = sobj[@"teamNameCn"];
                    info.teamLogoUrl = sobj[@"teamLogoUrl"];
                    [teams addObject:info];
                }];
                section.items = teams;
                [result addObject:section];
            }];
        }
    }];
    self.teams = result;
    if (self.dataBlock) {
        self.dataBlock(result);
    }
    [self saveData:result];
}

- (void)saveData:(id)data {
    BOOL success = NO;
    if ([data isKindOfClass:[NSData class]]) {
        
        success = [(NSData *)data writeToFile:[self filePath] atomically:YES];
    }else {
        NSMutableData *resultData = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:resultData];
        [archiver encodeObject:data forKey:@"teamData"];
        [archiver finishEncoding];
        success = [resultData writeToFile:[self filePath] atomically:YES];
    }
}


- (id)getTeamData {
    NSData *data = [NSData dataWithContentsOfFile:[self filePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id result = [unarchiver decodeObjectForKey:@"teamData"];
    [unarchiver finishDecoding];
    return result;
}

- (NSString *)filePath {
   
   return  [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"data"];
}
@end
