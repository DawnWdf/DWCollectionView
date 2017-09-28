//
//  DWRefreshManagerProtocol.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/12.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DWRefreshType) {
    DWRefreshTypeHeaderAndFooter,
    DWRefreshTypeHeader,
    DWRefreshTypeFooter,
};

@protocol DWRefreshManagerProtocol <NSObject>

- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView;

- (void)setupRefreshType:(DWRefreshType)refreshType;

- (void)setupHeaderRefresh:(void(^)(void))header footerRefresh:(void(^)(void))footer;

- (void)beginHeaderRefresh;

- (void)endHeaderRefresh;

- (void)beginFooterRefresh;

- (void)endFooterRefresh;


@end
