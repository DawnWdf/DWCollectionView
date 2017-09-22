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
#import "NSObject+MulArgPerformSel.h"

#import "UIImage+DWViewShot.h"

@interface DWFlowAutoMoveLayout()<UIGestureRecognizerDelegate>

//手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
//移动中的cell
@property (nonatomic, strong) UICollectionViewCell *moveingCell;
@property (nonatomic, strong) NSIndexPath *moveingIndexPath;
@property (nonatomic) CGPoint moveingCellCenter;
@property (nonatomic) BOOL canMove;
//目标cell
@property (nonatomic, strong) UICollectionViewCell *destinationCell;
@property (nonatomic, strong) NSIndexPath *destinationIndexPath;
@property (nonatomic) CGPoint destinationCellCenter;
//假视图
@property (nonatomic, strong) UIView *faceView;
//辅助参数
@property (nonatomic, assign) CGPoint panTranslation;
@property (nonatomic, strong) NSIndexPath *cachIndexPathToReorder;


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
                self.canMove = canMove;
                if (!canMove) {
                    return;
                }
                self.moveingCell = cell;
                self.moveingIndexPath = indexPath;
                self.cachIndexPathToReorder = indexPath;
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
                //animation
                [UIView animateWithDuration:0.3f animations:^{
                    self.faceView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                } completion:^(BOOL finished) {
                }];
                

            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [NSObject dw_target:self.delegate performSel:@selector(dw_collectionView:willEndMoveItemAtIndex:toIndex:) arguments:self.collectionView,self.moveingIndexPath,self.destinationIndexPath, nil];
            [UIView animateWithDuration:0.3 animations:^{
                self.faceView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                self.faceView.center = self.destinationCellCenter;
                
            } completion:^(BOOL finished) {
                self.destinationCell.alpha = 1.0;
                [self.faceView removeFromSuperview];
                [NSObject dw_target:self.delegate performSel:@selector(dw_collectionView:didEndMoveItemAtIndex:toIndex:) arguments:self.collectionView,self.moveingIndexPath,self.destinationIndexPath, nil];
            }];
        }
            break;
        default:
        {
        }
            break;
    }
}


- (void)panRecognizer:(UIPanGestureRecognizer *)recognizer {
    if (!self.canMove) {
        return;
    }
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:
        {
            self.panTranslation = [recognizer translationInView:self.collectionView];
            self.faceView.center = CGPointMake(self.moveingCellCenter.x + _panTranslation.x, self.moveingCellCenter.y + _panTranslation.y);
            
            NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:self.faceView.center];
            
            UICollectionViewCell *toCell = [self.collectionView cellForItemAtIndexPath:toIndexPath];
            toCell.alpha = 0.5;
            
            self.destinationCell = toCell;
            self.destinationIndexPath = toIndexPath;
            self.destinationCellCenter = toCell.center;
            
            if (!toIndexPath || [self.moveingIndexPath isEqual:toIndexPath]) {
                return;
            }

            //将要移动
            
            [NSObject dw_target:self.delegate performSel:@selector(dw_collectionView:willMoveItemAtIndex:toIndex:) arguments:self.collectionView,self.moveingIndexPath,toIndexPath, nil];
            
            __block  NSIndexPath *cachIndexPath = self.cachIndexPathToReorder;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView moveItemAtIndexPath:cachIndexPath toIndexPath:toIndexPath];
                
                [NSObject dw_target:self.delegate performSel:@selector(dw_collectionView:didMoveItemAtIndex:toIndex:) arguments:self.collectionView,cachIndexPath,toIndexPath, nil];
                _cachIndexPathToReorder = toIndexPath;
                
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
