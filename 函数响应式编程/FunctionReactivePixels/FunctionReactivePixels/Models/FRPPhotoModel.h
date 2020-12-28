//
//  FRPPhotoModel.h
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRPPhotoModel : NSObject

@property (nonatomic, strong) NSString *photoname;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *photographerName;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSData *thumbnailData;
@property (nonatomic, strong) NSString *fullsizedURL;
@property (nonatomic, strong) NSData *fullsizedData;
@property (nonatomic, assign, getter = isVotedFor) BOOL votedFor;

@end

NS_ASSUME_NONNULL_END
