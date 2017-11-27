//
//  UserCenterInforCollectionViewCell.m
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "UserCenterInforCollectionViewCell.h"
#import "UserCenterInforModel.h"

@interface UserCenterInforCollectionViewCell()
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *userLevelImageView;
@property (nonatomic, strong) UILabel *userLevelLabel;
@end

@implementation UserCenterInforCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}
- (void)bindData:(id)data {
    if ([data isKindOfClass:[UserCenterInforModel class]]) {
        UserCenterInforModel *model = (UserCenterInforModel *)data;
        self.userNameLabel.text = model.userName;
        self.userLevelLabel.text = [NSString stringWithFormat:@"%@  查看会员",model.userLevel];
        if (model.userIconUrl) {
            [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] placeholderImage:nil];
        }
    }
}
- (void)configViews {
   
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.userLevelImageView];
    [self.contentView addSubview:self.userLevelLabel];
    CGFloat screenW = CGRectGetWidth(self.frame);
    self.bgImageView.frame = CGRectMake(0, 0, screenW, CGRectGetHeight(self.frame));
    self.userImageView.frame = CGRectMake((screenW - 73) / 2, 45 + 20, 80, 80);
    self.userNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.userImageView.frame) + 8, screenW, 21);
    self.userLevelImageView.frame = CGRectMake((screenW - 62) / 2, CGRectGetMaxY(self.userNameLabel.frame) + 6, 62, 17);
    self.userLevelLabel.frame = CGRectMake(CGRectGetMinX(self.userLevelImageView.frame) + 2, CGRectGetMinY(self.userLevelImageView.frame), CGRectGetWidth(self.userLevelImageView.frame), CGRectGetHeight(self.userLevelImageView.frame));
}
#pragma mark - getter & setter
- (UIImageView *)bgImageView {
   
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@""];
        _bgImageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIImageView *)userImageView {
   
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init];
        _userImageView.image = [UIImage imageNamed:@""];
        _userImageView.layer.cornerRadius = ceilf(80)/2;
        _userImageView.layer.borderWidth = 2;
        _userImageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
        _userImageView.clipsToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}

- (UILabel *)userNameLabel {
   
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLabel;
}

- (UIImageView *)userLevelImageView {
   
    if (!_userLevelImageView) {
        _userLevelImageView = [[UIImageView alloc]init];
        _userLevelImageView.image = [UIImage imageNamed:@""];
    }
    return _userLevelImageView;
}

- (UILabel *)userLevelLabel {
   
    if (!_userLevelLabel) {
        _userLevelLabel = [[UILabel alloc]init];
        _userLevelLabel.font = [UIFont systemFontOfSize:9];
        _userLevelLabel.textColor = [UIColor blackColor];
    }
    return _userLevelLabel;
}
@end
