//
//  LeagueHeaderReusableView.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/25.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "LeagueHeaderReusableView.h"
#import "LeagueInfo.h"

@interface LeagueHeaderReusableView()

@property (nonatomic, strong) UILabel *titleLabel;


@end


static int indexC = 0;
@implementation LeagueHeaderReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, height_header)];
        tLabel.backgroundColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:13.0/255.0 alpha:1.0];
        tLabel.textColor = [UIColor blackColor];
        [self addSubview:tLabel];
        self.titleLabel = tLabel;
    }
    return self;
}
- (void)bindData:(id)data {
    if ([data isKindOfClass:[LeagueInfo class]]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ + %d",[(LeagueInfo *)data leagueTypeCn], indexC];
        indexC++;
    }
}
@end
