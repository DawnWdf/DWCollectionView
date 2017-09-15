//
//  DWFooterCollectionReusableView.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWFooterCollectionReusableView.h"

@interface DWFooterCollectionReusableView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DWFooterCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}
- (void)bindData:(id)data {
    self.titleLabel.text = data;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    }
    return _titleLabel;
}
@end
