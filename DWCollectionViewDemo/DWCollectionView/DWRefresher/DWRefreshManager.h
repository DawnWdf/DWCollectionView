//
//  DWRefreshManager.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/11.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, DWRefreshType) {
    DWRefreshTypeHeaderAndFooter,
    DWRefreshTypeHeader,
    DWRefreshTypeFooter,
};

@interface DWRefreshManager : NSObject


- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView;

- (void)setupRefreshType:(DWRefreshType)refreshType;

- (void)setupHeaderRefresh:(void(^)())header footerRefresh:(void(^)())footer;

- (void)beginHeaderRefresh;

- (void)endHeaderRefresh;

- (void)beginFooterRefresh;

- (void)endFooterRefresh;

@end
