//
//  TeamInfoCell.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/25.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "TeamInfoCell.h"
#import "TeamInfo.h"

@interface TeamInfoCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation TeamInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self.contentView addSubview:imageView];
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), frame.size.width, frame.size.height - CGRectGetMaxX(imageView.frame))];
        tLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
        tLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:tLabel];

        self.logoImageView = imageView;
        self.titleLabel = tLabel;
    }
    return self;
}
- (void)bindData:(id)data {
    if ([data isKindOfClass:[TeamInfo class]]) {
        self.titleLabel.text = [(TeamInfo *)data teamNameCn];
        NSString *logoString = [(TeamInfo *)data teamLogoUrl];
        if (logoString && logoString.length && self.showImage) {
            
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoString]];
        }else{
            self.logoImageView.image = nil;
        }
        CGRect frame = self.frame;
        if (self.showImage) {
            self.logoImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
            self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame), frame.size.width, frame.size.height - CGRectGetMaxX(self.logoImageView.frame));
            
        }else {
            self.logoImageView.frame = CGRectZero;
            self.titleLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }
    }
}


@end
