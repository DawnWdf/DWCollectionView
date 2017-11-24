//
//  CollectionViewBaseViewController.h
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/11/24.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWCollection.h"
#import "DataManager.h"

@interface CollectionViewBaseViewController : UIViewController <UICollectionViewDelegate>
@property (nonatomic,strong) DWCollectionView *collectionView;

@end
