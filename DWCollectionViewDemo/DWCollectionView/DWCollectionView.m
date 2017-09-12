//
//  DWCollectionView.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/7/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWCollectionView.h"
#import "DWCollectionViewDelegate.h"
#import "DWCollectionDataSource.h"
#import "DWMapperModel.h"


@interface DWCollectionView()

@property (nonatomic, weak) id dw_delegate;

@property (nonatomic, weak) id dw_dataSource;

@property (nonatomic, strong) DWCollectionViewDelegate *dwViewDelegate;
@property (nonatomic, strong) DWCollectionDataSource *dwDataSource;



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
    self.dwViewDelegate.configer = configerDic;
    self.dwViewDelegate.originalDelegate = self.dw_delegate;
    self.dwDataSource.configer = configerDic;
    self.dwDataSource.originalDelegate = self.dw_dataSource;
    self.delegate = self.dwViewDelegate;
    self.dataSource = self.dwDataSource;
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    if ([delegate isKindOfClass:[DWCollectionViewDelegate class]]) {
        [super setDelegate:delegate];
        return;
    }
    self.dw_delegate = delegate;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    if ([dataSource isKindOfClass:[DWCollectionDataSource class]]) {
        [super setDataSource:dataSource];
        return;
    }
    self.dw_dataSource = dataSource;
}

#pragma mark - setter & getter

- (DWCollectionViewDelegate *)dwViewDelegate{
    if (!_dwViewDelegate) {
        _dwViewDelegate = [[DWCollectionViewDelegate alloc] init];
    }
    return _dwViewDelegate;
}

- (DWCollectionDataSource *)dwDataSource {
    if (!_dwDataSource) {
        _dwDataSource = [[DWCollectionDataSource alloc] init];
    }
    return _dwDataSource;
}

- (void)setData:(NSArray<DWSection *> *)data{
    self.dwDataSource.data = data;
    self.dwViewDelegate.data = data;
    if ([[NSThread currentThread] isMainThread]) {
        [self reloadData];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }
    
}

@end
