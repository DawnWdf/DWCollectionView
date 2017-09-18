//
//  DWFlowAutoMoveLayout.m
//  DWCollectionViewDemo
//
//  Created by DawnWang on 2017/9/16.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "DWFlowAutoMoveLayout.h"
#import "DWCollectionView.h"
#import <objc/runtime.h>

@interface DWFlowAutoMoveLayout()
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, weak) id<DWFlowAutoMoveLayoutDelegate> delegate;

@end

@implementation DWFlowAutoMoveLayout
- (void)prepareLayout {
    [super prepareLayout];
    [self setupGestureRecogniz];
}

- (void)setupGestureRecogniz {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
    for (UIGestureRecognizer *re in self.collectionView.gestureRecognizers) {
        if ([re isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [re requireGestureRecognizerToFail:self.longPressGesture];
        }
    }
    self.longPressGesture = longPress;
    [self.collectionView addGestureRecognizer:longPress];
}


#pragma mark - action

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self.collectionView bringSubviewToFront:cell];
    BOOL hasChanged = NO;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(dw_collectionView:canMoveItemAtIndex:)]) {
                BOOL canMove = [self.delegate dw_collectionView:self.collectionView canMoveItemAtIndex:indexPath];
                if (!canMove) {
                    return;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            cell.center = point;

            for (UICollectionViewLayoutAttributes *attributes in self.attributes) {
                if (CGRectContainsPoint(attributes.frame, point)) {
                    if (indexPath && (indexPath != attributes.indexPath)) {
                        hasChanged = YES;
                        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:attributes.indexPath];
                    }
                }
            }
        }
            break;
        default:
            if (!hasChanged) {
                cell.center = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath].center;
            }
            break;
    }
}

#pragma mark - getter & setter

- (id<DWFlowAutoMoveLayoutDelegate>)delegate {
    
    return (id<DWFlowAutoMoveLayoutDelegate>)self.collectionView.dataSource?:(id<DWFlowAutoMoveLayoutDelegate>)self.collectionView.delegate;
}
@end
