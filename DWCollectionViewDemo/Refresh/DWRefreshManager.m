//
//  DWRefreshManager.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/11.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWRefreshManager.h"
#import "DWMJRefreshHeader.h"
#import "DWMJRefreshFooter.h"


@interface DWRefreshManager()

@property (nonatomic, weak) UIScrollView *scrollView; ///此处使用weak 避免循环引用

@property (nonatomic, copy) void(^footerRefresh)();

@property (nonatomic, copy) void(^headerRefresh)();

@end

@implementation DWRefreshManager
- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.scrollView = scrollView;
    }
    return self;
}


- (void)setupRefreshType:(DWRefreshType)refreshType {
    switch (refreshType) {
        case DWRefreshTypeHeaderAndFooter:
            [self setupHeader];
            [self setupFooter];
            break;
        case DWRefreshTypeHeader:
            [self setupHeader];
            break;
        case DWRefreshTypeFooter:
            [self setupFooter];
            break;
        default:
            break;
    }
}

- (void)setupHeaderRefresh:(void(^)())header footerRefresh:(void(^)())footer {
    self.footerRefresh = footer;
    self.headerRefresh = header;
}


- (void)setupFooter {
    __weak typeof(self) weakSelf = self;
   DWMJRefreshFooter *footer =  [DWMJRefreshFooter footerWithRefreshingBlock:^{
       __strong typeof(weakSelf) strongSelf = weakSelf;
       
       if (strongSelf && strongSelf.footerRefresh) {
           strongSelf.footerRefresh();
       }
    }];
    
    self.scrollView.mj_footer = footer;
}


- (void)setupHeader {
    __weak typeof(self) weakSelf = self;
    DWMJRefreshHeader *header = [DWMJRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf && strongSelf.headerRefresh) {
            strongSelf.headerRefresh();
        }
    }];
    self.scrollView.mj_header = header;
}

- (void)beginHeaderRefresh {
    [self.scrollView.mj_header beginRefreshing];
}

- (void)endHeaderRefresh {
    [self.scrollView.mj_header endRefreshing];
}

- (void)beginFooterRefresh {
    [self.scrollView.mj_footer beginRefreshing];
}

- (void)endFooterRefresh {
    [self.scrollView.mj_footer endRefreshing];
}
@end
