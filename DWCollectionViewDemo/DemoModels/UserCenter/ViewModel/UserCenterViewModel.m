//
//  UserCenterViewModel.m
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "UserCenterViewModel.h"
#import "DWSection.h"
//头信息
#import "UserCenterHeaderModel.h"
//用户头
#import "UserCenterInforModel.h"
//快捷入口
#import "UserCenterEntryModel.h"

@interface UserCenterViewModel ()
@property (nonatomic, copy) void(^finishBlcok)(NSArray *result);

@end

@implementation UserCenterViewModel
- (void)getUserCenterData:(void(^)(NSArray *))data {
    self.finishBlcok = data;
    if (self.finishBlcok) {
        self.finishBlcok([self fakeData]);
    }
}

- (NSArray *)fakeData {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    //用户信息
    DWSection *inforSection = [[DWSection alloc] init];
    UserCenterInforModel *inforModel = [[UserCenterInforModel alloc] init];
    inforModel.userName = @"用户名称";
    inforModel.userIconUrl = @"http://e.hiphotos.baidu.com/image/pic/item/ac345982b2b7d0a220c90bbac1ef76094b369a90.jpg";
    
    inforModel.userLevel = @"4";
    inforSection.items = @[inforModel];
    [result addObject:inforSection];
   
    //我的订单
    DWSection *orderSection = [[DWSection alloc] init];
    UserCenterHeaderModel *orderHeader = [[UserCenterHeaderModel alloc]init];
    orderHeader.title = @"我的订单";
    orderSection.headerData = orderHeader;
    NSMutableArray *orders = [NSMutableArray array];
    NSArray *orderImageNames = @[@"demo_icon",@"demo_icon",@"demo_icon",@"demo_icon",@"demo_icon",@"demo_icon",@"demo_icon",@"demo_icon"];
    NSArray *orderTitles = @[@"去支付",@"待支付",@"待评价",@"待收货",@"已发货",@"已完成",@"退款",@"退货"];
    NSArray *orderBadge = @[@(0),@(0),@(3),@(0),@(0),@(5),@(0),@(0)];
   
    for (int i = 0; i < MIN(orderImageNames.count, orderTitles.count); i++) {
        UserCenterEntryModel *entry = [[UserCenterEntryModel alloc]init];
        entry.imageName = orderImageNames[i];
        entry.title = orderTitles[i];
        entry.badgeNumber = [orderBadge[i] integerValue];
        [orders addObject:entry];
    }
    orderSection.items = orders;
    orderSection.footerData = @"footer";
    [result addObject:orderSection];
    
    //用户其他信息
    DWSection *userOtherSection = [[DWSection alloc] init];
    NSMutableArray *userOtherInfo = [NSMutableArray array];
    NSArray *userOtherTitle = @[@"优惠券",@"会员卡",@"兑换券",@"巴拉巴拉"];
    NSArray *userOtherTopTitle = @[@"0",@"0",@"5",@"10"];
    for (int i = 0; i < MIN(userOtherTitle.count, userOtherTopTitle.count); i++) {
        UserCenterEntryModel *model = [[UserCenterEntryModel alloc] init];
        model.title = userOtherTitle[i];
        model.topTitle = userOtherTopTitle[i];
        [userOtherInfo addObject:model];
    }
    userOtherSection.items = userOtherInfo;
    userOtherSection.footerData = @"footer";
    [result addObject:userOtherSection];

    return result;
}


@end
