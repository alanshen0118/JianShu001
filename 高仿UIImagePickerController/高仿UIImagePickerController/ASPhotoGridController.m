//
//  ASPhotoGridController.m
//  高仿UIImagePickerController
//
//  Created by alan on 9/12/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASPhotoGridController.h"
#import "ASPhotoGridCell.h"

@interface ASPhotoGridController () <PHPhotoLibraryChangeObserver, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation ASPhotoGridController
static NSString * const CellReuseIdentifier = @"Cell";
static CGSize AssetGridThumbnailSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self customPageViews];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
}

- (void)dealloc {
    //销毁观察相册变化的观察者
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - public method
- (void)customPageViews {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"select" style:UIBarButtonItemStylePlain target:self action:@selector(e__confirmImagePickerAction)];
    [self.view addSubview:self.collectionView];
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

- (NSArray *)indexPathsFromIndexes:(NSIndexSet *)indexSet section:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:indexSet.count];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}



#pragma mark - event response(e__method)
- (void)e__confirmImagePickerAction {
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSArray *selectedAssets = [self assetsAtIndexPaths:[self.collectionView indexPathsForSelectedItems]];
    __block NSInteger requestCompletedIndex = 0;
    for (PHAsset *asset in selectedAssets) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) [imageDatas addObject:imageData];
            requestCompletedIndex++;
            if (requestCompletedIndex > selectedAssets.count - 1) {
                if ([self.delegate respondsToSelector:@selector(as_didFinishPickingImageData:)]) {
                    [self.delegate as_didFinishPickingImageData:imageDatas];
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

#pragma mark -- PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // 检测是否有资源变化
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    // 通知在后台队列，重定位到主队列进行界面更新
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = self.collectionView;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            [collectionView reloadData];
            
        } else {
            // 如果相册有变化，collectionview动画增删改
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexes:removedIndexes section:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexes:insertedIndexes section:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [collectionView reloadItemsAtIndexPaths:[self indexPathsFromIndexes:changedIndexes section:0]];
                }
            } completion:NULL];
        }
        
    });
}


#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    
    ASPhotoGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    // 请求图片
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeDefault
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  
                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.thumbnailImage = result;
                                  }
                              }];
    
    return cell;
}

#pragma mark - getters and setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        CGFloat row = 4;
        CGFloat itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - row + 1) / row;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[ASPhotoGridCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
