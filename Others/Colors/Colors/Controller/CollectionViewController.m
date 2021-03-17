//
//  CollectionViewController.m
//  Colors
//
//  Created by Qilin Hu on 2020/7/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "CollectionViewController.h"

// Framework
#import "UIScrollView+EmptyDataSet.h"

// Controller
#import "SearchViewController.h"

// Model
#import "Palette.h"
#import "Color.h"

#define kColumnCountMax 7
#define kColumnCountMin 5

static NSString * const cellReuseIdentifier = @"CollectionViewCell";
static NSString * const KSegueIdentifier = @"collection_push_detail";

@interface CollectionViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, strong) NSMutableArray *filteredPalette;

@end

@implementation CollectionViewController

#pragma mark - View life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = @"Collection";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing =  2;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat insert = layout.minimumLineSpacing * 1.5;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(insert, 0.0, insert, 0.0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    // Register cell classes
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:cellReuseIdentifier];
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
}

#pragma mark - Custom Accessors

- (NSInteger)columnCount {
    return UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? kColumnCountMax : kColumnCountMin;
}

- (CGSize)cellSize {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat size = (self.navigationController.view.bounds.size.width/self.columnCount) - flowLayout.minimumLineSpacing;
    return CGSizeMake(size, size);
}

- (NSMutableArray *)filteredPalette {
    // Randomly filtered palette
    if (!_filteredPalette) {
        _filteredPalette = [[NSMutableArray alloc] initWithArray:[[Palette sharedPalette] colors]];
        for (NSInteger i = _filteredPalette.count - 1; i > 0; i--) {
            [_filteredPalette exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i + 1.0)];
        }
    }
    return _filteredPalette;
}

#pragma mark - Actions

- (IBAction)refreshColors:(id)sender {
    [[Palette sharedPalette] reloadAll];
    [self setFilteredPalette:nil];
    
    [self.collectionView reloadData];
}

- (IBAction)removeColors:(id)sender {
    [[Palette sharedPalette] removeAll];
    [_filteredPalette removeAllObjects];
    
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filteredPalette count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    
    Color *color = self.filteredPalette[indexPath.row];
    cell.backgroundColor = color.color;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Color *color = self.filteredPalette[indexPath.row];
    
    if ([self shouldPerformSegueWithIdentifier:KSegueIdentifier sender:color]) {
        [self performSegueWithIdentifier:KSegueIdentifier sender:color];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSize];
}

// MARK: 支持 copy 操作
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
            Color *color = self.filteredPalette[indexPath.row];
            if (color.hex.length > 0) [[UIPasteboard generalPasteboard] setString:color.hex];
        }
    });
}

#pragma mark - <DZNEmptyDataSetSource>

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No colors loaded";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"To show a list of random colors, tap on the refresh icon in the right top corner.\n\nTo clean the list, tap on the trash icon.";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0;
}


#pragma mark - <DZNEmptyDataSetSource>

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{

    NSLog(@"%s",__FUNCTION__);
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{

    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:KSegueIdentifier]) {
        SearchViewController *controller = [segue destinationViewController];
        controller.selectedColor = sender;
    }
}

#pragma mark - View Auto-Rotation

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.collectionView reloadData];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
