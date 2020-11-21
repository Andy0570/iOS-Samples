//
//  NSData+AFDecompression.m
//  Performance Problems Example
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "NSData+AFDecompression.h"

//Just a utility class to round numbers up
int roundUp(int numToRound, int multiple)
{
	if(multiple == 0)
	{
		return numToRound;
	}
	
	int remainder = numToRound % multiple;
	if (remainder == 0)
		return numToRound;
	return numToRound + multiple - remainder;
}

@implementation NSData (AFDecompression)

-(void)af_decompressedImageFromJPEGDataWithCallback:(JPEGWasDecompressedCallback)callback
{
    uint8_t character;
    [self getBytes:&character length:1];
    
    if (character != 0xFF)
    {
        //This is not a valid JPEG.
        
        callback(nil);
        
        return;
    }
    
    // get a data provider referencing the relevant file
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)self);
    
    // use the data provider to get a CGImage; release the data provider
    CGImageRef image = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    // make a bitmap context of a suitable size to draw to, forcing decode
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
	size_t bytesPerRow = roundUp(width * 4, 16);
	size_t byteCount = roundUp(height * bytesPerRow, 16);
	
	void *imageBuffer = malloc(byteCount);
    
    if (width == 0 || height == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(nil);
        });
    }
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef imageContext =
    CGBitmapContextCreate(imageBuffer, width, height, 8, bytesPerRow, colourSpace,
						  kCGImageAlphaNone | kCGImageAlphaNoneSkipLast); //Depsite what the docs say these are not the same thing
    
    CGColorSpaceRelease(colourSpace);
    
    // draw the image to the context, release it
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), image);
    CGImageRelease(image);
    
    // now get an image ref from the context
    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
    
    CGContextRelease(imageContext);
    free(imageBuffer);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *decompressedImage = [UIImage imageWithCGImage:outputImage];
        callback(decompressedImage);
        CGImageRelease(outputImage);
    });
}

@end
