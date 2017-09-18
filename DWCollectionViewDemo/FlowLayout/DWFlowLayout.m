//
//  DWFlowLayout.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/9/14.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWFlowLayout.h"

@interface DWFlowLayout()

@property (nonatomic, strong) NSMutableArray *columnHeight;

@property (nonatomic, strong, readwrite) NSMutableArray *attributes;

@property (nonatomic) CGFloat longestHeight;

/*
@property (nonatomic) NSInteger longestIndex;

@property (nonatomic) CGFloat shortestHeight;

@property (nonatomic) NSInteger shortestIndex;
*/
@end

@implementation DWFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    self.longestHeight = self.boundEdgeInsets.top;
    
    [self.columnHeight removeAllObjects];
    
    for (int i = 0; i < self.numberOfColumn; i++) {
        [self.columnHeight addObject:@(self.boundEdgeInsets.top)];
    }
    [self.attributes removeAllObjects];
    NSInteger sectionNumber = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionNumber; section++) {
        
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathWithIndex:section]];
        
        if (headerAttributes) {
            [self.attributes addObject:headerAttributes];
        }
        
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < numberOfItem; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (attributes) {
                [self.attributes addObject:attributes];
            }
            
        }
        
        
        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathWithIndex:section]];
        if (footerAttributes) {
            [self.attributes addObject:footerAttributes];
        }
        
    }
}
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attributes;
    
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s == %@",__func__,indexPath);
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGSize collectionSize = self.collectionView.frame.size;
    
    CGFloat width = ceilf((collectionSize.width - self.boundEdgeInsets.left - self.boundEdgeInsets.right - (self.numberOfColumn - 1) * self.interitemSpace) / self.numberOfColumn);
    
    CGFloat height = 0;
    if (self.itemHeightBlock) {
        height = self.itemHeightBlock(indexPath);
    }
    
    CGFloat shortestHeight = [[self.columnHeight firstObject] floatValue];
    
    NSInteger shortestIndex = 0;
    
    CGFloat longestHeight = [[self.columnHeight firstObject] floatValue];
    
    NSInteger longestIndex = 0;
    
    for (int i = 0; i < self.columnHeight.count; i++) {
        CGFloat itemHeight = [self.columnHeight[i] floatValue];
        if (shortestHeight > itemHeight) {
            shortestHeight = itemHeight;
            shortestIndex = i;
        }
    }
    
    
    CGFloat originX = self.boundEdgeInsets.left + shortestIndex * (width + self.interitemSpace);
    CGFloat originY = shortestHeight;
    
    self.columnHeight[shortestIndex] = @(originY + height + self.interitemSpace);
    
    
    attribute.frame = CGRectMake(originX, originY, width, height);
    
    
    for (int i = 0; i < self.columnHeight.count; i++) {
        CGFloat itemHeight = [self.columnHeight[i] floatValue];
        
        if (longestHeight < itemHeight) {
            longestHeight = itemHeight;
            longestIndex = i;
        }
    }

    self.longestHeight = longestHeight;

    return attribute;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    BOOL header = YES;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        header = YES;
    } else {
        header = NO;
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (header && self.headerEdgeInsets) {
        edgeInsets = self.headerEdgeInsets(indexPath.section);
    }
    if ((!header) && (self.footerEdgeInsets)) {
        edgeInsets = self.footerEdgeInsets(indexPath.section);
    }
    CGFloat originX = edgeInsets.left;
    
    CGFloat originY = self.longestHeight + edgeInsets.top;
    
    CGFloat width = self.collectionView.frame.size.width - edgeInsets.left - edgeInsets.right;
    
    CGFloat height = header?self.headerHeight:self.footerHeight;
    
    attribute.frame = CGRectMake(originX, originY, width, height);
    
    self.longestHeight += height + edgeInsets.top + edgeInsets.bottom;
    
    for (int i = 0; i < self.numberOfColumn; i++) {
        self.columnHeight[i] = @(self.longestHeight);
    }
    
    return attribute;
}


- (CGSize)collectionViewContentSize {
    CGFloat longestHight = 0;
    for (int i = 0; i < self.columnHeight.count; i++) {
        CGFloat height = [self.columnHeight[i] floatValue];
        longestHight = MAX(height, longestHight);
    }
    return CGSizeMake(self.collectionView.frame.size.width, longestHight);
}

#pragma mark - getter && setter

- (NSMutableArray *)columnHeight {
    if (!_columnHeight) {
        _columnHeight = [[NSMutableArray alloc]init];
    }
    return _columnHeight;
}

- (NSMutableArray *)attributes {
    if (!_attributes) {
        _attributes = [[NSMutableArray alloc]init];
    }
    return _attributes;
}

@end
