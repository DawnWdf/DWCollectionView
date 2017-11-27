//
//  UserCenterHeaderCollectionReusableView.m
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "UserCenterHeaderCollectionReusableView.h"
#import "UserCenterHeaderModel.h"

@interface UserCenterHeaderCollectionReusableView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation UserCenterHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}
- (void)bindData:(id)data {
    if ([data isKindOfClass:[UserCenterHeaderModel class]]) {
        UserCenterHeaderModel *model = (UserCenterHeaderModel *)data;
        self.titleLabel.text = model.title;
        self.subTitleLabel.attributedText = model.subTitle;
        self.arrowImageView.hidden = !model.showArrow;
    }
}

- (void)configViews {
   
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.arrowImageView];
    self.titleLabel.frame = CGRectMake(15, 0, 80, CGRectGetHeight(self.frame));
    self.subTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.titleLabel.frame) - 23, CGRectGetHeight(self.frame));
    self.arrowImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 6 - 14, (CGRectGetHeight(self.frame) - 11) / 2, 6, 11);
}

#pragma mark - getter & setter

- (UILabel *)titleLabel {
   
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
   
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:11];
        _subTitleLabel.textColor = [UIColor blackColor];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subTitleLabel;
}

- (UIImageView *)arrowImageView {
   
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.image = [UIImage imageNamed:@"_arrow_right_black"];
    }
    return _arrowImageView;
}
@end
