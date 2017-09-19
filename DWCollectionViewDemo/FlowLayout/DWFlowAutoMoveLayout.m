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


@property (nonatomic, strong) UICollectionViewCell *moveingCell;

@property (nonatomic, strong) NSIndexPath *moveingIndexPath;

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
    BOOL hasChanged = NO;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(dw_collectionView:canMoveItemAtIndex:)]) {
                BOOL canMove = [self.delegate dw_collectionView:self.collectionView canMoveItemAtIndex:indexPath];
                if (!canMove) {
                    return;
                }
                self.moveingCell = cell;
                self.moveingIndexPath = indexPath;
                [self.collectionView bringSubviewToFront:cell];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.moveingCell.center = point;
        }
            break;
        default:
        {
            BOOL blankSpce = YES;
            for (UICollectionViewLayoutAttributes *attributes in [self.attributes mutableCopy]) {
                blankSpce = NO;
                if (CGRectContainsPoint(CGRectMake(attributes.frame.origin.x - self.interitemSpace / 2, attributes.frame.origin.y - self.lineSpace / 2, attributes.frame.size.width + self.interitemSpace, attributes.frame.size.height + self.lineSpace), point)) {
                    if (self.moveingIndexPath != attributes.indexPath) {
                        hasChanged = YES;
                        if ([self.delegate respondsToSelector:@selector(dw_collectionView:didMoveItemAtIndex:toIndex:)]) {
                            [self.delegate dw_collectionView:self.collectionView didMoveItemAtIndex:self.moveingIndexPath toIndex:attributes.indexPath];
                            [self.collectionView moveItemAtIndexPath:self.moveingIndexPath toIndexPath:attributes.indexPath];
                        }
                    }
                }
            }
            if (blankSpce) {
                NSLog(@"blank space");
            }
            if (!hasChanged) {
                self.moveingCell.center = [self.collectionView layoutAttributesForItemAtIndexPath:self.moveingIndexPath].center;
            }
        }
            break;
    }
}

#pragma mark - getter & setter


@end
