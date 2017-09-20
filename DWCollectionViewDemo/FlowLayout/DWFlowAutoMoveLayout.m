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

#import "UIImage+DWViewShot.h"

@interface DWFlowAutoMoveLayout()<UIGestureRecognizerDelegate>

//手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
//移动中的cell
@property (nonatomic, strong) UICollectionViewCell *moveingCell;
@property (nonatomic, strong) NSIndexPath *moveingIndexPath;
@property (nonatomic) CGPoint moveingCellCenter;
//假视图
@property (nonatomic, strong) UIView *faceView;
//辅助参数
@property (nonatomic, assign) CGPoint panTranslation;


@end

@implementation DWFlowAutoMoveLayout

static dispatch_once_t onceToken;
- (void)dealloc {
    self.longPressGesture = nil;
    self.panGesture = nil;
    onceToken = 0;
}
- (void)prepareLayout {
    [super prepareLayout];
    [self setupGestureRecogniz];
}

- (void)setupGestureRecogniz {
    
    dispatch_once(&onceToken, ^{
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        for (UIGestureRecognizer *re in self.collectionView.gestureRecognizers) {
            if ([re isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [re requireGestureRecognizerToFail:self.longPressGesture];
            }
        }
        longPress.delegate = self;
        self.longPressGesture = longPress;
        [self.collectionView addGestureRecognizer:longPress];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
        pan.delegate = self;
        self.panGesture = pan;
        [self.collectionView addGestureRecognizer:pan];
    });
    
}


#pragma mark - action


- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.collectionView];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            if ([self.delegate respondsToSelector:@selector(dw_collectionView:canMoveItemAtIndex:)]) {
                BOOL canMove = [self.delegate dw_collectionView:self.collectionView canMoveItemAtIndex:indexPath];
                if (!canMove) {
                    return;
                }
                self.moveingCell = cell;
                self.moveingIndexPath = indexPath;
                self.moveingCellCenter = cell.center;
                //创建所选cell的替身
                self.faceView = [[UIView alloc]initWithFrame:cell.frame];
                self.faceView.layer.shadowColor = [UIColor blackColor].CGColor;
                self.faceView.layer.shadowOffset = CGSizeMake(0, 0);
                self.faceView.layer.shadowOpacity = .5f;
                self.faceView.layer.shadowRadius = 3.f;
                UIImageView *cellFakeImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
                cellFakeImageView.contentMode = UIViewContentModeScaleAspectFill;
                cellFakeImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                cellFakeImageView.backgroundColor = [UIColor clearColor];
                cellFakeImageView.image = [UIImage dw_imageShotFor:cell];
                
                [self.collectionView addSubview:self.faceView];
                [self.faceView addSubview:cellFakeImageView];
                //[self invalidateLayout];
                //animation
                [UIView animateWithDuration:0.3f animations:^{
                    self.faceView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                } completion:^(BOOL finished) {
                }];
                

            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
        }
            break;
        default:
        {
            /*
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
             */
        }
            break;
    }
}


- (void)panRecognizer:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:
        {
            self.panTranslation = [recognizer translationInView:self.collectionView];
            self.faceView.center = CGPointMake(self.moveingCellCenter.x + _panTranslation.x, self.moveingCellCenter.y + _panTranslation.y);
            
            NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:self.faceView.center];
            
            if (!toIndexPath || [self.moveingIndexPath isEqual:toIndexPath]) {
                return;
            }
            
            //判断是否可以移动
            //将要移动
            __block  NSIndexPath *cachIndexPath = self.moveingIndexPath;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView moveItemAtIndexPath:cachIndexPath toIndexPath:toIndexPath];
                
                if ([self.delegate respondsToSelector:@selector(dw_collectionView:didMoveItemAtIndex:toIndex:)]) {
                    [self.delegate dw_collectionView:self.collectionView didMoveItemAtIndex:cachIndexPath toIndex:toIndexPath];
                }
                cachIndexPath = toIndexPath;
                
            } completion:^(BOOL finished) {
                
            }];

        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([_panGesture isEqual:gestureRecognizer]) {
        if (_longPressGesture.state == 0 || _longPressGesture.state == 5) {
            return NO;
        }
    }else if ([_longPressGesture isEqual:gestureRecognizer]) {
        if (self.collectionView.panGestureRecognizer.state != 0 && self.collectionView.panGestureRecognizer.state != 5) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([_panGesture isEqual:gestureRecognizer]) {
        if (_longPressGesture.state != 0 && _longPressGesture.state != 5) {
            if ([_longPressGesture isEqual:otherGestureRecognizer]) {
                return YES;
            }
            return NO;
        }
    }else if ([_longPressGesture isEqual:gestureRecognizer]) {
        if ([_panGesture isEqual:otherGestureRecognizer]) {
            return YES;
        }
    }else if ([self.collectionView.panGestureRecognizer isEqual:gestureRecognizer]) {
        if (_longPressGesture.state == 0 || _longPressGesture.state == 5) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - getter & setter


@end
