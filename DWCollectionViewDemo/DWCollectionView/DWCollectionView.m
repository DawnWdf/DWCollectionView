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
{
    DWCollectionDelegateMaker *_maker_ojb;
}

@property (nonatomic, strong) DWCollectionViewDelegate *dwViewDelegate;
@property (nonatomic, strong) DWCollectionDataSource *dwDataSource;


@property (nonatomic, weak) id originalDelegate;

@property (nonatomic, weak) id originalDataSource;

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

#pragma mark - public method
- (void)registerViewAndModel:(void(^)(DWCollectionDelegateMaker *maker))maker {
    if (!maker) {
        return;
    }
    if (!_maker_ojb) {
        DWCollectionDelegateMaker *maker_ojb = [[DWCollectionDelegateMaker alloc] init];
        _maker_ojb = maker_ojb;
    }
    maker(_maker_ojb);
    
    for (DWMapperModel *mapperModel in _maker_ojb.cellRegister.allValues) {
        [self registerClass:NSClassFromString(mapperModel.viewClass) forCellWithReuseIdentifier:mapperModel.viewClass];
    }
    
    for (DWMapperModel *mapperModel in _maker_ojb.headerRegister.allValues) {
        [self registerClass:NSClassFromString(mapperModel.viewClass) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:mapperModel.viewClass];
    }
    
    for (DWMapperModel *mapperModel in _maker_ojb.footerRegister.allValues) {
        [self registerClass:NSClassFromString(mapperModel.viewClass) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:mapperModel.viewClass];
    }
    NSMutableDictionary *configerDic = [NSMutableDictionary dictionary];
    if (_maker_ojb.cellRegister.count) {
        [configerDic setObject:_maker_ojb.cellRegister forKey:@"cell"];
    }
    if (_maker_ojb.headerRegister.count) {
        [configerDic setObject:_maker_ojb.headerRegister forKey:@"header"];
    }
    if (_maker_ojb.footerRegister.count) {
        [configerDic setObject:_maker_ojb.footerRegister forKey:@"footer"];
    }
    self.dwViewDelegate.configer = configerDic;
    self.dwViewDelegate.originalDelegate = self.originalDelegate;
    self.dwDataSource.configer = configerDic;
    self.dwDataSource.originalDelegate = self.originalDataSource;
    self.delegate = self.dwViewDelegate;
    self.dataSource = self.dwDataSource;
}


#pragma mark - setter & getter
#pragma mark - super
- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    if ([delegate isKindOfClass:[DWCollectionViewDelegate class]]) {
        [super setDelegate:delegate];
        return;
    }
    self.originalDelegate = delegate;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    if ([dataSource isKindOfClass:[DWCollectionDataSource class]]) {
        [super setDataSource:dataSource];
        return;
    }
    self.originalDataSource = dataSource;
}

#pragma mark - private
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
#pragma mark - public
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
