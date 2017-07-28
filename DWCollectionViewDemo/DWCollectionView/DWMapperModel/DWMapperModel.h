//
//  DWMapperModel.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger , DWMapperType){
    DWMapperType_Cell,
    DWMapperType_Header,
    DWMapperType_Footer
};

@interface DWMapperModel : NSObject

@property (nonatomic, copy) NSString *viewClass;
@property (nonatomic, copy) NSString *modelClass;
@property (nonatomic) DWMapperType type;

@property (nonatomic, strong) id makerConfig;



@end
