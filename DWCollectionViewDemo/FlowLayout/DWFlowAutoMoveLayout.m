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


typedef enum : NSUInteger {
    DWScrollDirectionDown,
    DWScrollDirectionUp,
    DWScrollDirectionLeft,
    DWScrollDirectionRight,
} DWScrollDirection;

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
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) DWScrollDirection scrollDirectionForMoving;

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

#pragma mark displaylink

- (void)invalidateDisplayLink {
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)autoScroll {
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    CGSize boundsSize = self.collectionView.bounds.size;
    CGSize contentSize = self.collectionView.contentSize;
    NSLog(@"%@\n%@\n%@\n%@\n",NSStringFromCGPoint(contentOffset),[NSValue valueWithUIEdgeInsets:contentInsets],NSStringFromCGSize(boundsSize),NSStringFromCGSize(contentSize));
    self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + 10);
    if (CGRectGetMaxY(self.faceView.frame) - contentOffset.y - boundsSize.height > 0) {
        
    }
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
            [self invalidateDisplayLink];
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
            
            
            [self moveItemsIfNeed];
            
            //自动滚动
            
            if (CGRectGetMaxY(self.faceView.frame) > self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.frame)) {
                //向下滚动
                self.scrollDirectionForMoving = DWScrollDirectionDown;
            }else if (CGRectGetMinY(self.faceView.frame) < self.collectionView.contentOffset.y){
                //向上滚动
                self.scrollDirectionForMoving = DWScrollDirectionUp;
            }

            [self displayLink];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            [self invalidateDisplayLink];
            break;
        default:
            break;
    }
}

- (void)moveItemsIfNeed {
    NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:self.faceView.center];
    
    UICollectionViewCell *toCell = [self.collectionView cellForItemAtIndexPath:toIndexPath];
    
    self.destinationCell = toCell;
    self.destinationIndexPath = toIndexPath;
    self.destinationCellCenter = toCell.center;
    
    if (!toIndexPath || [self.moveingIndexPath isEqual:toIndexPath]) {
        return;
    }
    toCell.alpha = 0.5;
    //将要移动
    
    [NSObject dw_target:self.delegate performSel:@selector(dw_collectionView:willMoveItemAtIndex:toIndex:) arguments:self.collectionView,self.moveingIndexPath,toIndexPath, nil];
    
    __block  NSIndexPath *cachIndexPath = self.cachIndexPathToReorder;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveItemAtIndexPath:cachIndexPath toIndexPath:toIndexPath];
        //已经移动
        [NSObject dw_target:self.delegate performSel:@selector(dw_collectionView:didMoveItemAtIndex:toIndex:) arguments:self.collectionView,cachIndexPath,toIndexPath, nil];
        _cachIndexPathToReorder = toIndexPath;
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([_panGesture isEqual:gestureRecognizer]) {
        //当前为移动的手势，但是长按的手势失败了，则不开识别行移动的手势，因为移动cell要在已经长按选择一个cell后才有效。
        if (_longPressGesture.state == 0 || _longPressGesture.state == 5) {
            return NO;
        }
    }else if ([_longPressGesture isEqual:gestureRecognizer]) {
        //当前为长按的手势，但是正在滚动当前的collectionView，则不开始识别长按的手势。
        if (self.collectionView.panGestureRecognizer.state != 0 && self.collectionView.panGestureRecognizer.state != 5) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([_panGesture isEqual:gestureRecognizer]) {
        //当前为移动的手势，如果长按的手势也识别成功，则两个手势可以同时进行
        //但是如果otherGestureRecognizer=UIScreenEdgePanGestureRecognizer则两个手势不能同时进行
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

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoScroll)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}
@end
