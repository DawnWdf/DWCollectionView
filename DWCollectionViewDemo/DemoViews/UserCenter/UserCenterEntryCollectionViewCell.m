//
//  UserCenterEntryCollectionViewCell.m
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "UserCenterEntryCollectionViewCell.h"
#import "UserCenterEntryModel.h"
#import "BadgeView.h"

@interface UserCenterEntryCollectionViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *topLine;
@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, strong) UILabel *leftLine;
@property (nonatomic, strong) UILabel *rightLine;
@property (nonatomic, strong) BadgeView *badgeView;
@end

@implementation UserCenterEntryCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
        [self configLines];
    }
    return self;
}
- (void)bindData:(id)data {
    if ([data isKindOfClass:[UserCenterEntryModel class]]) {
        UserCenterEntryModel *model = (UserCenterEntryModel *)data;
        self.iconImageView.image = [UIImage imageNamed:model.imageName];
        self.titleLabel.text = model.title;
        self.numberLabel.text = model.topTitle;
        self.badgeView.badgeNumber = model.badgeNumber;
        
    }
}

- (void)configViews {
   
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.badgeView];
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    CGFloat imageWidth = 22;
    
    self.iconImageView.frame = CGRectMake((cellWidth - imageWidth) / 2, 13, imageWidth, imageWidth);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame) + 5, cellWidth, 16);
    self.numberLabel.frame = CGRectMake(0, 13, cellWidth, 25);
    self.badgeView.frame = CGRectMake(cellWidth / 2 + 4, 5, 12, 12);
}

- (void)configLines {
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 1)];
    topLine.backgroundColor = _LineColor;
    [self.contentView addSubview:topLine];
    self.topLine = topLine;
    
    UILabel *bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, cellHeight - 1, cellWidth, 1)];
    bottomLine.backgroundColor = _LineColor;
    [self.contentView addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
    UILabel *leftLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, cellHeight)];
    leftLine.backgroundColor = _LineColor;
    [self.contentView addSubview:leftLine];
    self.leftLine = leftLine;
    
    UILabel *rightLine = [[UILabel alloc]initWithFrame:CGRectMake(cellWidth - 1, 0, 1, cellHeight)];
    rightLine.backgroundColor = _LineColor;
    [self.contentView addSubview:rightLine];
    self.rightLine = rightLine;
    
}

#pragma mark - getter & setter
- (UIImageView *)iconImageView {
   
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

- (UILabel *)numberLabel {
   
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [UIFont systemFontOfSize:18];
        _numberLabel.textColor = [UIColor blackColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UILabel *)titleLabel {
   
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (BadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[BadgeView alloc]init];
        _badgeView.hidden = YES;
    }
    return _badgeView;
}
@end
