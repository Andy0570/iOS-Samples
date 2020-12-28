//
//  FRPPhotoImporter.h
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

NS_ASSUME_NONNULL_BEGIN

@interface FRPPhotoImporter : NSObject

+ (RACSignal *)importPhotos;

+ (RACSignal *)fetchPhotoDetails:(FRPPhotoModel *)photoModel;

+ (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password;

+ (RACSignal *)voteForPhoto:(FRPPhotoModel *)photoModel;

@end

NS_ASSUME_NONNULL_END
