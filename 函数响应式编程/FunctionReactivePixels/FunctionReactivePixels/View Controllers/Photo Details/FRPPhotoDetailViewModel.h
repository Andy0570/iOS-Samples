//
//  FRPPhotoDetailViewModel.h
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import "RVMViewModel.h"

@class FRPPhotoModel;

NS_ASSUME_NONNULL_BEGIN

@interface FRPPhotoDetailViewModel : RVMViewModel

@property (nonatomic, readonly) FRPPhotoModel *model;

@property (nonatomic, readonly) NSString *photoNamel;
@property (nonatomic, readonly) NSString *photoRating;
@property (nonatomic, readonly) NSString *photographerName;
@property (nonatomic, readonly) NSString *votePromptText;

@property (nonatomic, readonly) RACCommand *voteCommand;

@property (nonatomic, readonly) BOOL loggedIn;

@end

NS_ASSUME_NONNULL_END
