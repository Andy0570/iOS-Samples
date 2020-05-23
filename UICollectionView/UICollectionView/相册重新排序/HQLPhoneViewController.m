//
//  HQLPhoneViewController.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/10.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLPhoneViewController.h"

// View
#import "CollectionReusableView.h"
#import "CollectionViewCell.h"

// Model
#import "SimpleModel.h"


static NSString * const cellReuseIdentifier = @"UICollectionViewCell";
static NSString * const headerReuseIdentifier = @"CollectionReusableViewHeader";
static NSString * const footerReuseIdentifier = @"CollectionReusableViewFooter";

@interface HQLPhoneViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SimpleModel *simpleModel; // 数据源模型

@end

@implementation HQLPhoneViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加数据源模型
    self.simpleModel = [[SimpleModel alloc] init];
    
    // 添加集合视图
    [self.view addSubview:self.collectionView];
    
    // 为 Collection View 集合视图添加长按手势
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(reorderCollectionView:)];
//    [self.collectionView addGestureRecognizer:longPressGesture];
    
    // 开启拖放手势，设置代理。
    self.collectionView.dragInteractionEnabled = YES;
    self.collectionView.dragDelegate = self;
    self.collectionView.dropDelegate = self;
}


#pragma mark - Custom Accessors

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        // 初始化 UICollectionViewFlowLayout 对象
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        // 也可以通过属性的方式设置布局属性
        /**
         _flowLayout.itemSize = CGSizeMake(153, 128);
         _flowLayout.footerReferenceSize = CGSizeMake(35, 35);
         _flowLayout.minimumLineSpacing = 20;
         _flowLayout.minimumInteritemSpacing = 20;
         _flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
         */
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // 设置集合视图内容区域、layout、背景颜色
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];

        // 设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;

        // 注册重用 cell、header cell 和 footer cell
        [_collectionView registerClass:[CollectionViewCell class]
            forCellWithReuseIdentifier:cellReuseIdentifier];
        [_collectionView registerClass:[CollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:headerReuseIdentifier];
        [_collectionView registerClass:[CollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:footerReuseIdentifier];
    }
    return _collectionView;
}


#pragma mark - Actions


// 长按手势响应方法。
//- (void)reorderCollectionView:(UILongPressGestureRecognizer *)longPressGesture {
//    switch (longPressGesture.state) {
//        case UIGestureRecognizerStateBegan: {
//            /**
//             手势开始
//
//             要开始交互式移动 item，Collection View 调用 beginInteractiveMovementForItemAtIndexPath: 方法；
//             */
//            CGPoint touchPoint = [longPressGesture locationInView:self.collectionView];
//            NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];
//            if (selectedIndexPath) {
//                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
//            }
//            break;
//        }
//
//        case UIGestureRecognizerStateChanged: {
//            /**
//             手势变化
//
//             当手势识别器跟踪到手势变化时，集合视图调用 updateInteractiveMovementTargetPosition: 方法报告最新触摸位置；
//             */
//            CGPoint touchPoint = [longPressGesture locationInView:self.collectionView];
//            [self.collectionView updateInteractiveMovementTargetPosition:touchPoint];
//            break;
//        }
//
//        case UIGestureRecognizerStateEnded: {
//            /**
//             手势结束
//
//             当手势结束时，UICollectionView 调用 endInteractiveMovement 方法结束交互并更新视图；
//             */
//            [self.collectionView endInteractiveMovement];
//            break;
//        }
//
//        default:{
//            /**
//             当手势中途取消或识别失败，UICollectionView 调用 cancelInteractiveMovement 方法结束交互。
//             */
//            [self.collectionView cancelInteractiveMovement];
//            break;
//        }
//    }
//}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.simpleModel.model.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.simpleModel.model[section] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 分别配置每个 cell
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    // cell.backgroundColor = [UIColor colorWithDisplayP3Red:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    // 设置imageView图片，label文字。
    NSString *imageName = [self.simpleModel.model[indexPath.section] objectAtIndex:indexPath.item];
    cell.imageView.image = [UIImage imageNamed:imageName];
    NSString *labelText = [NSString stringWithFormat:@"(%li, %li)",indexPath.section, indexPath.item];
    cell.label.text = labelText;
    return cell;
}

// 设置头、尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionReusableView *reuseableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 设置 header view
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        reuseableView.label.textAlignment = NSTextAlignmentCenter;
        reuseableView.label.text = [NSString stringWithFormat:@"Section %li", indexPath.section];
    } else  if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        // 设置 foot view
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseIdentifier forIndexPath:indexPath];
        reuseableView.label.textAlignment = NSTextAlignmentNatural;
        reuseableView.label.text = [NSString stringWithFormat:@"Section %li have %li items",indexPath.section,[collectionView numberOfItemsInSection:indexPath.section]];
    }
    
    return reuseableView;
}


#pragma mark - <UICollectionViewDelegateFlowLayout>

// 设置 item 大小。
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(153, 128);
}

// 设置 cell 边缘插入量。
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

// 设置item间距。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

// 设置行间距。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

// 设置 section header 大小。
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGSizeMake(40, 40) : CGSizeMake(45, 45);
}

// 设置 section footer 大小。
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(35, 35);
}


// 💡 以下两个实现用于处理长按手势数据源更新
////// 是否允许移动 item。
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//// 更新数据源。
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    NSString *sourceObject = [self.simpleModel.model[sourceIndexPath.section] objectAtIndex:sourceIndexPath.item];
//    [self.simpleModel.model[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.item];
//    [self.simpleModel.model[destinationIndexPath.section] insertObject:sourceObject atIndex:destinationIndexPath.item];
//    // 重新加载当前显示的item。
//    [collectionView reloadItemsAtIndexPaths:[collectionView indexPathsForVisibleItems]];
//}



#pragma mark - UICollectionViewDragDelegate

- (NSArray <UIDragItem *>*)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    // 获取当前要托动的对象
    NSString *imageName = [self.simpleModel.model[indexPath.section] objectAtIndex:indexPath.item];
    
    // 创建一个或多个 NSItemProvider，使用 NSItemProvider 传递集合视图 item 内容。
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:imageName];
    
    // 将每个 NSItemProvider 封装在对应 UIDragItem 对象中。
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    
    /**
     考虑为每个 dragItem 的 localObject 分配要传递的数据。
     这一步骤是可选的，但在同一 app 内拖放时，localObject 可以加快数据传递。
     */
    dragItem.localObject = imageName;
    
    // 返回 dragItem
    return @[dragItem];
}


#pragma mark - UICollectionViewDropDelegate

// 设置拖动预览信息
// 自定义拖动过程中 cell 的外观
- (nullable UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 使用 UIDragPreviewParameters 可以指定 cell 的可视部分，或改变 cell 背景颜色
    // 设置预览图为圆角，背景色为 clearColor。
    UIDragPreviewParameters *previewParameters = [[UIDragPreviewParameters alloc] init];
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:10];
    previewParameters.backgroundColor = [UIColor clearColor];
    return previewParameters;
}

// 是否接收拖动的item。
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[NSString class]];
}

// 拖动过程中不断反馈item位置。
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    UICollectionViewDropProposal *dropProposal;
    if (session.localDragSession) {
        // 拖动手势源自同一app。
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    } else {
        // 拖动手势源自其它app。
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    return dropProposal;
}

- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    // 如果coordinator.destinationIndexPath存在，直接返回；如果不存在，则返回（0，0)位置。
    NSIndexPath *destinationIndexPath = coordinator.destinationIndexPath ? coordinator.destinationIndexPath : [NSIndexPath indexPathForItem:0 inSection:0];

    // 在collectionView内，重新排序时只能拖动一个cell。
    if (coordinator.items.count == 1 && coordinator.items.firstObject.sourceIndexPath) {
        NSIndexPath *sourceIndexPath = coordinator.items.firstObject.sourceIndexPath;

        // 将多个操作合并为一个动画。
        [collectionView performBatchUpdates:^{
            // 将拖动内容从数据源删除，插入到新的位置。
            NSString *imageName = coordinator.items.firstObject.dragItem.localObject;
            [self.simpleModel.model[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.item];
            [self.simpleModel.model[destinationIndexPath.section] insertObject:imageName atIndex:destinationIndexPath.item];

            // 更新collectionView。
            [collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        } completion:nil];
        
        // 以动画形式移动cell。
        [coordinator dropItem:coordinator.items.firstObject.dragItem toItemAtIndexPath:destinationIndexPath];
    }
}


@end
