//
//  NormalViewController.m
//  DWCollectionViewDemo
//
//  Created by Dawn Wang on 2017/10/10.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "NormalViewController.h"
#import <DWCollection/DWCollection.h>
#import "DataManager.h"
#import "TeamInfo.h"
#import "LeagueInfo.h"

#pragma mark - cell

@interface NormalCell : UICollectionViewCell<DWCollectionViewCellProtocol>
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation NormalCell

- (instancetype)initWithFrame:(CGRect)frame {
   
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (void)bindData:(id)data {
    if ([data isKindOfClass:[TeamInfo class]]) {
        TeamInfo *info = (TeamInfo *)data;
        self.titleLabel.text = info.teamNameCn;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor greenColor];
        _titleLabel.layer.cornerRadius = 5.0f;
        _titleLabel.layer.borderColor = [UIColor greenColor].CGColor;
        _titleLabel.clipsToBounds = YES;
        _titleLabel.layer.borderWidth = 1.0f;
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    }
    return _titleLabel;
}
@end

#pragma mark - header
@interface NormalHeader : UICollectionReusableView<DWCollectionViewCellProtocol>
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation NormalHeader
- (instancetype)initWithFrame:(CGRect)frame {
   
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];

    }
    return self;
}
- (void)bindData:(id)data {
    if ([data isKindOfClass:[LeagueInfo class]]) {
        LeagueInfo *info = (LeagueInfo *)data;
        self.titleLabel.text = info.leagueTypeCn;
    }
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor greenColor];
        _titleLabel.layer.cornerRadius = 5.0f;
        _titleLabel.layer.borderColor = [UIColor greenColor].CGColor;
        _titleLabel.clipsToBounds = YES;
        _titleLabel.layer.borderWidth = 1.0f;
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    }
    return _titleLabel;
}
@end

#pragma mark - vc
@interface NormalViewController ()<UICollectionViewDelegate>
@property (nonatomic,strong) DWCollectionView *collectionView;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //------------创建collectionView--------------------------------------
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 50;
    layout.minimumInteritemSpacing = 100;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    DWCollectionView *cv= [[DWCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    cv.backgroundColor = [UIColor whiteColor];
    cv.delegate = self;
    [self.view addSubview:cv];
    self.collectionView = cv;
    [self configCollectionView];
    [DataManager teamData:^(NSMutableArray *data) {
        [self.collectionView setData:data];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)configCollectionView {
    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
        
        maker.registerCell([NormalCell class],[TeamInfo class])
        .itemSize(^(NSIndexPath *indexPath, id data){
            CGSize size = [[(TeamInfo *)data teamNameCn] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]}];
            return CGSizeMake(size.width + 20, 30);
        })
        .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data){
            NormalCell *newCell = (NormalCell *)cell;
            [newCell bindData:data];
        })
        .didSelect(^(NSIndexPath *indexPath, id data){
            NSLog(@"did select block : 如果vc中实现了didSelect的代理方法，则在此block后执行");
        });
        
        
        maker.registerHeader([NormalHeader class],[LeagueInfo class])
        .sizeConfiger(^ CGSize (UICollectionViewLayout *layout , NSInteger section, id data){
            return CGSizeMake(300, 40);
        })
        .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data){
            NormalHeader *header = (NormalHeader *)reusableView;
            [header bindData:data];
        });
        
        
    }];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
@end
