//
//  DWCollectionView.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionView.h"
#import "DWCollectionDelegate.h"

@interface DWCollectionView()

@property (nonatomic, weak) id dw_delegate;

@property (nonatomic, weak) id dw_dataSource;

@property (nonatomic, strong) DWCollectionDelegate *dwDelegate;
@end

@implementation DWCollectionView

#pragma mark - over write
- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
    }
    return self;
}

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

- (void)registerViewAndModel:(void(^)(DWCollectionDelegateMaker *maker))maker {
    if (!maker) {
        return;
    }
    
    DWCollectionDelegateMaker *maker_ojb = [[DWCollectionDelegateMaker alloc] init];
    maker(maker_ojb);
    
    for (DWMapperModel *mapperModel in maker_ojb.cellRegister.allValues) {
        [self registerClass:NSClassFromString(mapperModel.viewClass) forCellWithReuseIdentifier:mapperModel.viewClass];
    }
    
    for (DWMapperModel *mapperModel in maker_ojb.headerRegister.allValues) {
        [self registerClass:NSClassFromString(mapperModel.viewClass) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:mapperModel.viewClass];
    }
    
    for (DWMapperModel *mapperModel in maker_ojb.footerRegister.allValues) {
        [self registerClass:NSClassFromString(mapperModel.viewClass) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:mapperModel.viewClass];
    }
    NSMutableDictionary *configerDic = [NSMutableDictionary dictionary];
    if (maker_ojb.cellRegister.count) {
        [configerDic setObject:maker_ojb.cellRegister forKey:@"cell"];
    }
    if (maker_ojb.headerRegister.count) {
        [configerDic setObject:maker_ojb.headerRegister forKey:@"header"];
    }
    if (maker_ojb.footerRegister.count) {
        [configerDic setObject:maker_ojb.footerRegister forKey:@"footer"];
    }
    self.dwDelegate.configer = configerDic;
    self.dwDelegate.originalDelegate = self.dw_delegate?:self.dw_dataSource;
    self.delegate = self.dwDelegate;
    self.dataSource = self.dwDelegate;
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    if ([delegate isKindOfClass:[DWCollectionDelegate class]]) {
        [super setDelegate:delegate];
        return;
    }
    self.dw_delegate = delegate;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    if ([dataSource isKindOfClass:[DWCollectionDelegate class]]) {
        [super setDataSource:dataSource];
        return;
    }
    self.dw_dataSource = dataSource;
}

#pragma mark - setter & getter

- (DWCollectionDelegate *)dwDelegate{
    if (!_dwDelegate) {
        _dwDelegate = [[DWCollectionDelegate alloc] init];
    }
    return _dwDelegate;
}

- (void)setData:(NSArray<DWSection *> *)data{
    self.dwDelegate.data = data;
    if ([[NSThread currentThread] isMainThread]) {
        [self reloadData];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }
    
}
@end
