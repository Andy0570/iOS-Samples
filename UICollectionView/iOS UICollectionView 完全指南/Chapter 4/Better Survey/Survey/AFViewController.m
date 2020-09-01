//
//  AFViewController.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"

//Views
#import "AFCollectionHeaderView.h"
#import "AFCollectionViewCell.h"
#import "AFCollectionViewFlowLayout.h"

//Models
#import "AFPhotoModel.h"
#import "AFSelectionModel.h"

@interface AFViewController (Private)

//Private method to set up the model. Treat this like a stub - pay no attention to this method.
-(void)setupModel;

@end

@implementation AFViewController
{
    //Array of selection objects
    NSArray *selectionModelArray;
    //Our current index within the selectionModelArray
    NSUInteger currentModelArrayIndex;
    //Whether or not we've completed the survey
    BOOL isFinished;
}

//Static identifiers for cells and supplementary views
static NSString *CellIdentifier = @"CellIdentifier";
static NSString *HeaderIdentifier = @"HeaderIdentifier";

-(void)loadView
{
    //Create our view
    //Create a basic flow layout that will accomodate three columns in portrait
    AFCollectionViewFlowLayout *surveyFlowLayout = [[AFCollectionViewFlowLayout alloc] init];
    
    //Create a new collection view with our flow layout and set ourself as delegate and data source
    UICollectionView *surveyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:surveyFlowLayout];
    surveyCollectionView.dataSource = self;
    surveyCollectionView.delegate = self;
    
    //Register our classes so we can use our custom subclassed cell and header
    [surveyCollectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [surveyCollectionView registerClass:[AFCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    
    //Set up the collection view geometry to cover the whole screen in any orientation
    surveyCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //Finally, set our collectionView (since we are a collection view controller, this also sets self.view)
    self.collectionView = surveyCollectionView;
    
    //Set up our model
    [self setupModel];
    
    //We start at zero
    currentModelArrayIndex = 0;
}

#pragma mark - Private Custom Methods

//A handy method to implement — returns the photo model at any index path
-(AFPhotoModel *)photoModelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= selectionModelArray.count) return nil;
    if (indexPath.row >= [[selectionModelArray[indexPath.section] photoModels] count]) return nil;
    
    return [selectionModelArray[indexPath.section] photoModels][indexPath.item];
}

//Configures a cell for a given index path
-(void)configureCell:(AFCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    //Set the image for the cell
    [cell setImage:[[self photoModelForIndexPath:indexPath] image]];
    
    //By default, assume the cell is not disabled and not selected
    [cell setDisabled:NO];
    [cell setSelected:NO];
    
    //If the cell is not in our current last index, disable it
    if (indexPath.section < currentModelArrayIndex)
    {
        [cell setDisabled:YES];
        
        //If the cell was selected by the user previously, select it now
        if (indexPath.row == [selectionModelArray[indexPath.section] selectedPhotoModelIndex])
        {
            [cell setSelected:YES];
        }
    }
}

#pragma mark - UICollectionViewDataSource 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //Return the smallest of either our curent model index plus one, or our total number of sections.
    //This will show 1 section when we only want to display section zero, etc.
    //It will prevent us from returning 11 when we only have 10 sections.
    return MIN(currentModelArrayIndex + 1, selectionModelArray.count);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Return the number of photos in the section model
    return [[selectionModelArray[currentModelArrayIndex] photoModels] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Configure the cell
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

#pragma mark UICollectionViewDelegateFlowLayout Methods

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Provides a different size for each invidual cell
    
    //Grab the photo model for the cell
    AFPhotoModel *photoModel = [self photoModelForIndexPath:indexPath];
    
    //Determine the size and aspect ratio for the model's image
    CGSize photoSize = photoModel.image.size;
    CGFloat aspectRatio = photoSize.width / photoSize.height;
    
    //start out with the detail image size of the maximum size
    CGSize itemSize = kMaxItemSize;
    
    if (aspectRatio < 1)
    {
        //The photo is taller than it is wide, so constrain the width
        itemSize = CGSizeMake(kMaxItemSize.width * aspectRatio, kMaxItemSize.height);
    }
    else if (aspectRatio > 1)
    {
        //The photo is wider than it is tall, so constrain the height
        itemSize = CGSizeMake(kMaxItemSize.width, kMaxItemSize.height / aspectRatio);
    }
    
    return itemSize;
}

#pragma mark Header

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //Provides a view for the headers in the collection view
    
    AFCollectionHeaderView *headerView = (AFCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        //If this is the first header, display a prompt to the user
        [headerView setText:@"Tap on a photo to start the recommendation engine."];
    }
    else if (indexPath.section <= currentModelArrayIndex)
    {
        //Otherwise, display a prompt using the selected photo from the previous section
        AFSelectionModel *selectionModel = selectionModelArray[indexPath.section - 1];
        
        AFPhotoModel *selectedPhotoModel = [self photoModelForIndexPath:[NSIndexPath indexPathForItem:selectionModel.selectedPhotoModelIndex inSection:indexPath.section - 1]];
        
        [headerView setText:[NSString stringWithFormat:@"Because you liked %@...", selectedPhotoModel.name]];
    }
    
    return headerView;
}

#pragma mark Interaction 

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //The user has selected a cell
    
    //No matter what, deselect that cell
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    //Set the selected photo index
    [selectionModelArray[currentModelArrayIndex] setSelectedPhotoModelIndex:indexPath.item];
    
    if (currentModelArrayIndex >= selectionModelArray.count - 1)
    {
        //Let’s just present some dialogue to indicate things are done.
        
        isFinished = YES;
        
        [[[UIAlertView alloc] initWithTitle:@"Recommendation Engine" message:@"Based on your selections, we have concluded you have excellent taste in photography!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Awesome!", nil] show];
        
        return;
    }
    
    [collectionView performBatchUpdates:^{
        currentModelArrayIndex++;
        [collectionView insertSections:[NSIndexSet indexSetWithIndex:currentModelArrayIndex]];
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:currentModelArrayIndex-1]];
    } completion:^(BOOL finished) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:currentModelArrayIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == currentModelArrayIndex && !isFinished;
}

#pragma mark Tap and Hold Gesture

-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        return YES;
    }
    
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[[self photoModelForIndexPath:indexPath] name]];
    }
}

@end















@implementation AFViewController (Private)

-(void)setupModel
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    [mutableArray addObjectsFromArray:@[[AFSelectionModel
                                         selectionModelWithPhotoModels:@[
                                         [AFPhotoModel photoModelWithName:@"Purple Flower" image:[UIImage imageNamed:@"0.jpg"]],
                                         [AFPhotoModel photoModelWithName:@"WWDC Hypertable" image:[UIImage imageNamed:@"1.jpg"]],
                                         [AFPhotoModel photoModelWithName:@"Purple Flower II" image:[UIImage imageNamed:@"2.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"Castle" image:[UIImage imageNamed:@"3.jpg"]],
      [AFPhotoModel photoModelWithName:@"Skyward Look" image:[UIImage imageNamed:@"4.jpg"]],
      [AFPhotoModel photoModelWithName:@"Kakabeka Falls" image:[UIImage imageNamed:@"5.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"Puppy" image:[UIImage imageNamed:@"6.jpg"]],
      [AFPhotoModel photoModelWithName:@"Thunder Bay Sunset" image:[UIImage imageNamed:@"7.jpg"]],
      [AFPhotoModel photoModelWithName:@"Sunflower I" image:[UIImage imageNamed:@"8.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"Sunflower II" image:[UIImage imageNamed:@"9.jpg"]],
      [AFPhotoModel photoModelWithName:@"Sunflower I" image:[UIImage imageNamed:@"10.jpg"]],
      [AFPhotoModel photoModelWithName:@"Squirrel" image:[UIImage imageNamed:@"11.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"Montréal Subway" image:[UIImage imageNamed:@"12.jpg"]],
      [AFPhotoModel photoModelWithName:@"Geometrically Intriguing Flower" image:[UIImage imageNamed:@"13.jpg"]],
      [AFPhotoModel photoModelWithName:@"Grand Lake" image:[UIImage imageNamed:@"17.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"Spadina Subway Station" image:[UIImage imageNamed:@"15.jpg"]],
      [AFPhotoModel photoModelWithName:@"Staircase to Grey" image:[UIImage imageNamed:@"14.jpg"]],
      [AFPhotoModel photoModelWithName:@"Saint John River" image:[UIImage imageNamed:@"16.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"Purple Bokeh Flower" image:[UIImage imageNamed:@"18.jpg"]],
      [AFPhotoModel photoModelWithName:@"Puppy II" image:[UIImage imageNamed:@"19.jpg"]],
      [AFPhotoModel photoModelWithName:@"Plant" image:[UIImage imageNamed:@"21.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"Peggy's Cove I" image:[UIImage imageNamed:@"21.jpg"]],
      [AFPhotoModel photoModelWithName:@"Peggy's Cove II" image:[UIImage imageNamed:@"22.jpg"]],
      [AFPhotoModel photoModelWithName:@"Sneaky Cat" image:[UIImage imageNamed:@"23.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"King Street West" image:[UIImage imageNamed:@"24.jpg"]],
      [AFPhotoModel photoModelWithName:@"TTC Streetcar" image:[UIImage imageNamed:@"25.jpg"]],
      [AFPhotoModel photoModelWithName:@"UofT at Night" image:[UIImage imageNamed:@"26.jpg"]]]],
     [AFSelectionModel
      selectionModelWithPhotoModels:@[
      [AFPhotoModel photoModelWithName:@"Mushroom" image:[UIImage imageNamed:@"27.jpg"]],
      [AFPhotoModel photoModelWithName:@"Montréal Subway Selective Colour" image:[UIImage imageNamed:@"28.jpg"]],
      [AFPhotoModel photoModelWithName:@"On Air" image:[UIImage imageNamed:@"29.jpg"]]]]]];
    
    selectionModelArray = [NSArray arrayWithArray:mutableArray];
}

@end

