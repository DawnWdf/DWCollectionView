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

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) DWMJRefreshHeader *header;

@property (nonatomic, strong) DWMJRefreshFooter *footer;

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
@end
