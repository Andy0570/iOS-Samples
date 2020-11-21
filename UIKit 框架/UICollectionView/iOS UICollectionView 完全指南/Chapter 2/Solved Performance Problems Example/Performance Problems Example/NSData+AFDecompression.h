//
//  NSData+AFDecompression.h
//  Performance Problems Example
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JPEGWasDecompressedCallback)(UIImage *decompressedImage);

@interface NSData (AFDecompression)

// callback block is executed on the main thread.
-(void)af_decompressedImageFromJPEGDataWithCallback:(JPEGWasDecompressedCallback)callback;

@end
