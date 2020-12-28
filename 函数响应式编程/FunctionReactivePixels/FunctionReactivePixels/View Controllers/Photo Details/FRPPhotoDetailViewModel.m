//
//  FRPPhotoDetailViewModel.m
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import "FRPPhotoDetailViewModel.h"

// Model
#import "FRPPhotoModel.h"

// Utilities
#import "FRPPhotoImporter.h"

@interface FRPPhotoDetailViewModel ()

@property (nonatomic, strong) NSString *photoNamel;
@property (nonatomic, strong) NSString *photoRating;
@property (nonatomic, strong) NSString *photographerName;
@property (nonatomic, strong) NSString *votePromptText;

@property (nonatomic, strong) RACCommand *voteCommand;

@end

@implementation FRPPhotoDetailViewModel

- (instancetype)initWithModel:(FRPPhotoModel *)model {
    self = [super initWithModel:model];
    if (!self) { return nil; }
    
    RAC(self, photoNamel) = RACObserve(self.model, photoname);
    RAC(self, photoRating) = [RACObserve(self.model, rating) map:^id(id value) {
        return [NSString stringWithFormat:@"%.2f", [value floatValue]];
    }];
    RAC(self, photographerName) = RACObserve(self.model, photographerName);
    RAC(self, votePromptText) = [RACObserve(self.model, votedFor) map:^id(id value) {
        if ([value boolValue]) {
            return @"Voted For!";
        } else {
            return @"Vote";
        }
    }];
    
    @weakify(self);
    self.voteCommand = [[RACCommand alloc] initWithEnabled:[RACObserve(self.model, votedFor) not] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [FRPPhotoImporter voteForPhoto:self.model];
    }];
    
    return self;
}

- (BOOL)loggedIn {
    return [[PXRequest apiHelper] authMode] == PXAPIHelperModeOAuth;
}

@end
