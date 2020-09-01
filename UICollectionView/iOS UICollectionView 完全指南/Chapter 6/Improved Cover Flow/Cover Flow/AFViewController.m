//
//  AFViewController.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"

//Views
#import "AFCollectionViewCell.h"
#import "AFCoverFlowFlowLayout.h"

//Models
#import "AFPhotoModel.h"

@interface AFViewController (Private)

//Private method to set up the model. Treat this like a stub - pay no attention to this method.
-(void)setupModel;

@end

@implementation AFViewController
{
    //Array of selection objects
    NSArray *photoModelArray;
    
    UISegmentedControl *layoutChangeSegmentedControl;
    
    AFCoverFlowFlowLayout *coverFlowCollectionViewLayout;
    UICollectionViewFlowLayout *boringCollectionViewLayout;
}

//Static identifiers for cells and supplementary views
static NSString *CellIdentifier = @"CellIdentifier";

-(void)loadView
{
    // Create our view
    
    // Create our awesome cover flow layout
    coverFlowCollectionViewLayout = [[AFCoverFlowFlowLayout alloc] init];
    
    //Create a basic flow layout that will accommodate three columns in portrait
    boringCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    boringCollectionViewLayout.itemSize = CGSizeMake(140, 140);
    boringCollectionViewLayout.minimumLineSpacing = 10.0f;
    boringCollectionViewLayout.minimumInteritemSpacing = 10.0f;
    
    // Create a new collection view with our flow layout and set ourself as delegate and data source
    UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:boringCollectionViewLayout];
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    
    // Register our classes so we can use our custom subclassed cell and header
    [photoCollectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    // Set up the collection view geometry to cover the whole screen in any orientation and other view properties
    photoCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    photoCollectionView.allowsSelection = NO;
    photoCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // Finally, set our collectionView (since we are a collection view controller, this also sets self.view)
    self.collectionView = photoCollectionView;
    
    // Set up gesture recognizers
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.collectionView addGestureRecognizer:tapGestureRecognizer];
    
    // Set up our model
    [self setupModel];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Crate a segmented control to sit in our navigation bar
    layoutChangeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Boring", @"Cover Flow"]];
    layoutChangeSegmentedControl.selectedSegmentIndex = 0;
    layoutChangeSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [layoutChangeSegmentedControl addTarget:self action:@selector(layoutChangeSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = layoutChangeSegmentedControl;
}

#pragma mark - Private Custom Methods

//A handy method to implement — returns the photo model at any index path
-(AFPhotoModel *)photoModelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= [photoModelArray count]) return nil;
    
    return photoModelArray[indexPath.item];
}

//Configures a cell for a given index path
-(void)configureCell:(AFCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    //Set the image for the cell
    [cell setImage:[[self photoModelForIndexPath:indexPath] image]];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Return the number of photos in the section model
    return [photoModelArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Configure the cell
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionViewLayout == boringCollectionViewLayout)
    {
        // A basic flow layout that will accommodate three columns in portrait
        return UIEdgeInsetsMake(10, 20, 10, 20);
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            // Portrait is the same in either orientation
            return UIEdgeInsetsMake(0, 70, 0, 70);
        }
        else
        {
            // We need to get the height of the main screen to see if we're running
            // on a 4" screen. If so, we need extra side padding.
            if (CGRectGetHeight([[UIScreen mainScreen] bounds]) > 480)
            {
                return UIEdgeInsetsMake(0, 190, 0, 190);
            }
            else
            {
                return UIEdgeInsetsMake(0, 150, 0, 150);
            }
        }
    }
}

#pragma mark - UIGestureRecognizer Methods

-(void)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer
{
    if (self.collectionView.collectionViewLayout != coverFlowCollectionViewLayout) return;
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    
    CGPoint point = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (!indexPath)
    {
        return;
    }
    
    BOOL centered = [coverFlowCollectionViewLayout indexPathIsCentered:indexPath];
    
    if (centered)
    {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        [UIView transitionWithView:cell duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            cell.bounds = cell.bounds;
        } completion:nil];
    }
    else
    {
        CGPoint proposedOffset = CGPointMake(0, 0);
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            proposedOffset.x = indexPath.item * (coverFlowCollectionViewLayout.itemSize.width + coverFlowCollectionViewLayout.minimumLineSpacing);
        }
        else
        {
            proposedOffset.x = (indexPath.item - 1) * (coverFlowCollectionViewLayout.itemSize.width + coverFlowCollectionViewLayout.minimumLineSpacing);
        }
        
        CGPoint contentOffset = [coverFlowCollectionViewLayout targetContentOffsetForProposedContentOffset:proposedOffset withScrollingVelocity:CGPointMake(0, 0)];
        
        [self.collectionView setContentOffset:contentOffset animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f", scrollView.contentOffset.x);
}

#pragma mark - User Interface Interaction

-(void)layoutChangeSegmentedControlDidChangeValue:(id)sender
{
    // Change to the alternate layout
    
    if (layoutChangeSegmentedControl.selectedSegmentIndex == 0)
    {
        [self.collectionView setCollectionViewLayout:boringCollectionViewLayout animated:NO];
    }
    else
    {
        [self.collectionView setCollectionViewLayout:coverFlowCollectionViewLayout animated:NO];
    }
    
    // Invalidate the new layout
    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end















@implementation AFViewController (Private)

-(void)setupModel
{
    photoModelArray = @[
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"1.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"2.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"3.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"4.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"5.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"6.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"7.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"8.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"9.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"10.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"11.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"12.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"13.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"17.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"15.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"14.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"16.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"18.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"19.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"21.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"21.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"22.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"23.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"24.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"25.jpg"]],
    [AFPhotoModel photoModelWithImage:[UIImage imageNamed:@"26.jpg"]]];
}

@end

