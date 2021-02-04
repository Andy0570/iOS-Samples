//
//  CFileUtile.m
//  CoolLibrary
//
//  Created by Chentao on 16/3/5.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CFileUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "KCLFileManager.h"

#define FileHashDefaultChunkSizeForReadingData 1024 * 8

//用户信息存放目录
NSString *const UserInfo_Directory = @"userinfodirectory";

//用户信息存放文件名
NSString *const UserInfo_FileName = @"userinfo";

@implementation CFileUtils

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (NSString *)userpath {
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];

    NSString *cacheFilePath = [[KCLFileManager cachesDir] stringByAppendingPathComponent:identifier];
    if (![KCLFileManager isExistsAtPath:cacheFilePath]) {
        [KCLFileManager createDirectoryAtPath:cacheFilePath];
    }

    NSString *userpath = [cacheFilePath stringByAppendingPathComponent:UserInfo_Directory];
    if (![KCLFileManager isExistsAtPath:userpath]) {
        [KCLFileManager createDirectoryAtPath:userpath];
    }
    return userpath;
}

+ (NSString *)getMD5WithData:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

+ (NSString *)getFileMD5WithPath:(NSString *)path {
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath, size_t chunkSizeForReadingData) {

    // Declare needed variables

    CFStringRef result = NULL;

    CFReadStreamRef readStream = NULL;

    // Get the file URL

    CFURLRef fileURL =

    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,

                                  (CFStringRef)filePath,

                                  kCFURLPOSIXPathStyle,

                                  (Boolean) false);

    if (!fileURL)
        goto done;

    // Create and open the read stream

    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,

                                            (CFURLRef)fileURL);

    if (!readStream)
        goto done;

    bool didSucceed = (bool)CFReadStreamOpen(readStream);

    if (!didSucceed)
        goto done;

    // Initialize the hash object

    CC_MD5_CTX hashObject;

    CC_MD5_Init(&hashObject);

    // Make sure chunkSizeForReadingData is valid

    if (!chunkSizeForReadingData) {

        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }

    // Feed the data to the hash object

    bool hasMoreData = true;

    while (hasMoreData) {

        uint8_t buffer[chunkSizeForReadingData];

        CFIndex readBytesCount = CFReadStreamRead(readStream, (UInt8 *)buffer, (CFIndex)sizeof(buffer));

        if (readBytesCount == -1)
            break;

        if (readBytesCount == 0) {

            hasMoreData = false;

            continue;
        }

        CC_MD5_Update(&hashObject, (const void *)buffer, (CC_LONG)readBytesCount);
    }

    // Check if the read operation succeeded

    didSucceed = !hasMoreData;

    // Compute the hash digest

    unsigned char digest[CC_MD5_DIGEST_LENGTH];

    CC_MD5_Final(digest, &hashObject);

    // Abort if the read operation failed

    if (!didSucceed)
        goto done;

    // Compute the string result

    char hash[2 * sizeof(digest) + 1];

    for (size_t i = 0; i < sizeof(digest); ++i) {

        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }

    result = CFStringCreateWithCString(kCFAllocatorDefault, (const char *)hash, kCFStringEncodingUTF8);

done:

    if (readStream) {

        CFReadStreamClose(readStream);

        CFRelease(readStream);
    }

    if (fileURL) {

        CFRelease(fileURL);
    }

    return result;
}

@end
