//
//  UserCenterInforCollectionViewCell.h
//  GomeAfterSales
//
//  Created by Dawn Wang on 2017/10/26.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWCollectionViewCellProtocol.h"
#define UserCenterInforCellHeight  ceil(375 / 320 * 195) + 20

@interface UserCenterInforCollectionViewCell : UICollectionViewCell<DWCollectionViewCellProtocol>
@property (nonatomic, strong) UIImageView *bgImageView;

@end
