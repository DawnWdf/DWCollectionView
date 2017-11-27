//
//  BadgeView.m
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/11/1.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "BadgeView.h"

@interface BadgeView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation BadgeView

- (instancetype)initWithFrame:(CGRect)frame {
   
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView {
    [self addSubview:self.titleLabel];
    self.layer.cornerRadius = 6.0f;
    self.backgroundColor = [UIColor redColor];
    self.layer.masksToBounds = YES;

}

#pragma mark - getter & setter

- (void)setBadgeNumber:(NSInteger)badgeNumber {
    self.hidden = !badgeNumber;
    NSString *string = [NSString stringWithFormat:@"%ld",badgeNumber];
    if (badgeNumber >= 100) {
        string = @"99+";
    }
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(3, 0, size.width, 12);
    self.titleLabel.text = string;
    CGRect originRect = self.frame;
    originRect.size.width = CGRectGetWidth(self.titleLabel.frame) + 6;
    self.frame = CGRectMake(originRect.origin.x, originRect.origin.y, originRect.size.width, originRect.size.height);
}
- (UILabel *)titleLabel {
   
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:8];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
@end
