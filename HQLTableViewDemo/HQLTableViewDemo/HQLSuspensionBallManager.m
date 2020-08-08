//
//  HQLSuspensionBallManager.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/8/8.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLSuspensionBallManager.h"
#import "HQLSuspensionButton.h"

static HQLSuspensionBallManager *sharedSuspensionBallManager = nil;

@interface HQLSuspensionBallManager()

@property (nonatomic, strong) HQLSuspensionButton *suspensionButton;
@property (nonatomic, assign) BOOL delegateFlag;

@end

@implementation HQLSuspensionBallManager

#pragma mark - Initialize

+ (HQLSuspensionBallManager *)sharedSuspensionBallManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSuspensionBallManager = [[self alloc] init];
    });
    return sharedSuspensionBallManager;
}

#pragma mark - Custom Accessors

- (HQLSuspensionButton *)suspensionButton {
    if (!_suspensionButton) {
        CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height - 150, 50, 50);
        _suspensionButton = [[HQLSuspensionButton alloc] initWithFrame:frame color:[UIColor clearColor]];
        [_suspensionButton setImage:[UIImage imageNamed:@"SuspensionButton"] forState:UIControlStateNormal];
        [_suspensionButton addTarget:self action:@selector(suspensionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _suspensionButton;
}

- (void)setDelegate:(id<HQLSuspensionBallDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag = [delegate respondsToSelector:@selector(suspensionBallClickAction:)];
}

#pragma mark - Actions

- (void)suspensionButtonAction:(id)sender {
    if (_delegateFlag) {
        [self.delegate suspensionBallClickAction:self];
    }
}

#pragma mark - Public

- (void)createSuspensionBall {
    [self.suspensionButton show];
}

- (void)displaySuspensionBall {
    self.suspensionButton.hidden = NO;
}

- (void)hideSuspensionBall {
    self.suspensionButton.hidden = YES;
}

- (void)changeSuspensionBallAlpha:(CGFloat)alpha {
    self.suspensionButton.alpha = alpha;
}

@end
