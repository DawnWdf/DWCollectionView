//
//  DWCollectionDelegate.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DWSection.h"

@interface DWCollectionDelegate : NSObject<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id originalDelegate;

@property (nonatomic, strong) NSDictionary *configer;

@property (nonatomic, strong) NSArray<DWSection *> *data;

@property (nonatomic, strong) UICollectionViewFlowLayout *vfLayout;

@end
