//
//  HQLRecordButton.m
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//

#import "HQLRecordButton.h"

@implementation HQLRecordButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(touchDragInside) forControlEvents:UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(touchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(touchDragExit) forControlEvents:UIControlEventTouchDragExit];
    return self;
}

#pragma mark - Public

- (void)setButtonStateWithRecording {
    self.backgroundColor = [UIColor lightGrayColor];
    [self setTitle:@"松开 结束" forState:UIControlStateNormal];
}

- (void)setButtonStateWithNormal {
    self.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
}

#pragma mark - Actions

- (void)touchDown {
    if (self.touchDownAction) {
        self.touchDownAction(self);
    }
}

- (void)touchUpOutside {
    if (self.touchUpOutsideAction) {
        self.touchUpOutsideAction(self);
    }
}

- (void)touchUpInside {
    if (self.touchUpInsideAction) {
        self.touchUpInsideAction(self);
    }
}

- (void)touchDragEnter {
    if (self.touchDragEnterAction) {
        self.touchDragEnterAction(self);
    }
}

- (void)touchDragInside {
    if (self.touchDragInsideAction) {
        self.touchDragInsideAction(self);
    }
}

- (void)touchDragOutside {
    if (self.touchDragOutsideAction) {
        self.touchDragOutsideAction(self);
    }
}

- (void)touchDragExit {
    if (self.touchDragExitAction) {
        self.touchDragExitAction(self);
    }
}

@end
