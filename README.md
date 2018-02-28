# DWCollectionView

详细说明文档在：http://www.jianshu.com/p/b8b99a688d6a


支持Carthage安装 github "DawnWdf/DWCollectionView"
支持cocoaPods安装  pod "DWCollectionView"

这是个对UICollectionView的简单封装，当我们在使用多种Cell类型的CollectionView的时候，基本上都是在各个代理类里面进行多个if-else处理。这个类则是通过转换代理对象的方式，将常用的代理方法分离出来，使得在注册一个cell、header、footer的时候可以将代码放在同一个区域内统一管理，提高代码可阅读性。 使用方法如下：

    [self.collectionView registerViewAndModel:^(DWCollectionDelegateMaker *maker) {
    
    maker.registerCell([TeamInfoCell class],[TeamInfo class])
    .itemSize(^(NSIndexPath *indexPath, id data){
        return CGSizeMake(150, 150);
    })
    .adapter(^(UICollectionViewCell *cell, NSIndexPath *indexPath, id data){
        TeamInfoCell *newCell = (TeamInfoCell *)cell;
        [newCell bindData:data];
    });
    
    
    maker.registerHeader([LeagueHeaderReusableView class],[LeagueInfo class])
    .sizeConfiger(^ CGSize (UICollectionViewLayout *layout , NSInteger section, id data){
        return CGSizeMake(300, height_header);
    })
    .adapter(^(UICollectionReusableView *reusableView,NSIndexPath *indexPath, id data){
        LeagueHeaderReusableView *header = (LeagueHeaderReusableView *)reusableView;
        [header bindData:data];
    });
    }];
