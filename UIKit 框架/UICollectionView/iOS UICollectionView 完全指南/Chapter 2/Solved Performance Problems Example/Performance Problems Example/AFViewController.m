//
//  AFViewController.m
//  Performance Problems Example
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"

//Model
#import "AFCollectionViewCell.h"

//Utility classes
#import "NSData+AFDecompression.h"

@interface AFViewController (Private)

-(void)setupModel;
-(NSData *)downloadImageDataWithURLString:(NSString *)urlString;

@end

static NSString *CellIdentifier = @"CellIdentifier";

@implementation AFViewController
{
    UICollectionView *photoCollectionView;
    UICollectionViewFlowLayout *photoFlowLayout;
    
    NSArray *photoURLStringArray;
    NSCache *photoDataCache;
}

-(void)loadView
{
    //Create our view
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    
    photoDataCache = [[NSCache alloc] init];
    
    //Set up our model
    [self setupModel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create a basic two-column flow layout (more columns in landscape)
    photoFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    photoFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    photoFlowLayout.minimumInteritemSpacing = 10.0f;
    photoFlowLayout.minimumLineSpacing = 10.0f;
    photoFlowLayout.itemSize = CGSizeMake(145, 100);
    
    //Create a new collection view with our flow layout and set ourself as delegate and data source
    photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:photoFlowLayout];
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    
    //Register our class so we can use our custom subclass cell
    [photoCollectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    //Set up the collection view geometry to cover the whole screen in any orientation and other view properties
    photoCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    photoCollectionView.opaque = NO;
    photoCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    photoCollectionView.backgroundColor = [UIColor clearColor];
    
    //Create a background view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat.jpg"]];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeCenter;
    
    //Finally, assemble our view complete hierarchy
    [self.view addSubview:imageView];
    [self.view addSubview:photoCollectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [photoURLStringArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath withURLString:photoURLStringArray[indexPath.row]];
    
    return cell;
}

#pragma mark - Private Custom Methods

-(void)configureCell:(AFCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withURLString:(NSString *)urlString
{
    // 尝试从缓存中调出一个 NSData 的缓存实例。
    id data = [photoDataCache objectForKey:urlString];
    
    if (data) {
        // 如果 objectForKey:是非 nil，也就是说我们之前下载了图片，这个分支就会执行。
        if ([data isKindOfClass:[NSNull class]]) {
            // 这表明该实例是NSNull，所以我们不应该使用它。
            
            //nop
        } else {
            // 我们可以成功解压我们的JPEG数据
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [data af_decompressedImageFromJPEGDataWithCallback:^(UIImage *decompressedImage) {
                    [cell setImage:decompressedImage];
                }];
            });
        }
    } else {
        // 在后台队列中下载图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [self downloadImageDataWithURLString:urlString];
            
            //Now that we have the data, dispatch back to the main queue
            //to use it. UIImage is part of UIKit and can *only* be accessed on
            //the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image = [UIImage imageWithData:data];
                
                if (image) {
                    // 这个作为参数传入的单元格实例现在可能已经被重用了。
                    // 调用 reloadItemsAtIndexPaths: 代替。
                    [photoDataCache setObject:data forKey:urlString];
                    [photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                } else {
                    // 这表明 JPEG 解压失败。在我们的缓存中设置NSNull
                    [photoDataCache setObject:[NSNull null] forKey:urlString];
                }
            });
        });
    }
}

@end









@implementation AFViewController (Private)

/*
 
 Please pay no attention to these methods. Read their descriptions at the top
 of this file, but not their implementations - they aren't part of the case study.
 
 */

-(void)setupModel
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    const NSInteger kMaxPhotoNumber = 26;
    
    /*
     Here's the magic bit: We're going to use photos stored locally, in our
     bundle, but we're going to simulate them coming from the internet
     by adding a delay in downloadImageDataWithURLString:
     */
    
    for (NSInteger i = 1; i <= kMaxPhotoNumber; i++)
    {
        [mutableArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    photoURLStringArray = [NSArray arrayWithArray:mutableArray];
}

-(NSData *)downloadImageDataWithURLString:(NSString *)urlString
{
    NSString *path = [[NSBundle mainBundle] pathForResource:urlString ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //This delay simulates the delay it would take to download some image from the Internet
    CGFloat delay = (25 + arc4random() % 100) * 1000.0f;
    usleep(delay);
    
    return data;
}

@end
