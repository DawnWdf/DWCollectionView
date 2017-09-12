//
//  DWMJRefreshFooter.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/11.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWMJRefreshFooter.h"
@interface DWMJRefreshFooter()

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation DWMJRefreshFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)prepare {
    [super prepare];
    [self addSubview:self.titleLabel];
}

- (void)placeSubviews {
    [super placeSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.titleLabel.text = @"闲置状态";
            break;
        case MJRefreshStatePulling:
            self.titleLabel.text = @"松开就可以刷新了";
            break;
        case MJRefreshStateNoMoreData:
            self.titleLabel.text = @"没有更多数据了";
            break;
        case MJRefreshStateRefreshing:
            self.titleLabel.text = @"正在刷新";
            break;
        case MJRefreshStateWillRefresh:
            self.titleLabel.text = @"即将刷新";
            break;
        default:
            break;
    }
    
}
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}

#pragma mark - getter && setter
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
