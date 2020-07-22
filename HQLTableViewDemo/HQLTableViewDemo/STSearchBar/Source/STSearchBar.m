//
//  STSearchBar.m
//  STSearchBar
//
//  Created by 沈兆良 on 16/8/17.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import "STSearchBar.h"

NS_ASSUME_NONNULL_BEGIN
static const CGFloat STSearchBarHeight = 44;
static const CGFloat STTextFieldHeight = 28;
static const CGFloat STSearchBarMargin = 8;

@interface STSearchBar ()<UITextFieldDelegate>
/** 1.输入框 */
@property (nonatomic, strong) UITextField *textField;
/** 2.取消按钮 */
@property (nonatomic, strong) UIButton *buttonCancel;
/** 3.搜索图标 */
@property (nonatomic, strong) UIImageView *imageIcon;
/** 4.中间视图 */
@property (nonatomic, strong) UIButton *buttonCenter;

@end

NS_ASSUME_NONNULL_END

@implementation STSearchBar

#pragma mark - --- 1. init 视图初始化 ---
- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI{
    _placeholder = @"";
    _showsCancelButton = YES;
    _placeholderColor = [UIColor colorWithWhite:0.35 alpha:1];

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, STSearchBarHeight);
    self.backgroundColor = [UIColor colorWithRed:(201.0/255) green:(201.0/255) blue:(206.0/255) alpha:1];
    self.clipsToBounds = YES;
    [self addSubview:self.buttonCancel];
    [self addSubview:self.textField];
    [self addSubview:self.buttonCenter];
}

#pragma mark - --- 2. delegate 视图委托 ---

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect frameButtonCenter = self.buttonCenter.frame;
    frameButtonCenter.origin.x = CGRectGetMinX(self.textField.frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.buttonCenter.frame = frameButtonCenter;
        if (self.showsCancelButton) {
            self.buttonCancel.frame = CGRectMake(self.frame.size.width - 60, 0, 60, STSearchBarHeight);
            self.textField.frame = CGRectMake(STSearchBarMargin, STSearchBarMargin, self.buttonCancel.frame.origin.x-STSearchBarMargin, STTextFieldHeight);
        }
    } completion:^(BOOL finished) {
        [self.buttonCenter setHidden:YES];
        [self.imageIcon setHidden:NO];
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:self.placeholderColor}];
    }];

    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
    {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
    {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)])
    {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.buttonCenter setHidden:NO];
    [self.imageIcon setHidden:YES];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:self.placeholderColor}];
    [UIView animateWithDuration:0.3 animations:^{
        if (self.showsCancelButton) {
            self.buttonCancel.frame = CGRectMake(self.frame.size.width, 0, 60, STSearchBarHeight);
            self.textField.frame = CGRectMake(STSearchBarMargin, STSearchBarMargin, self.frame.size.width-STSearchBarMargin*2, STTextFieldHeight);
        }
        self.buttonCenter.center = self.textField.center;
    } completion:^(BOOL finished) {

    }];

    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
    {
        [self.delegate searchBarTextDidEndEditing:self];
    }

    self.textField.text = @"";
}
-(void)textFieldDidChange:(UITextField *)textField
{

    if (textField.text.length > 0) {
        [self.buttonCancel setHighlighted:YES];
    }else {
        [self.buttonCancel setHighlighted:NO];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:@""];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}
#pragma mark - --- 3. event response 事件相应 ---
-(void)cancelButtonTouched
{
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}
#pragma mark - --- 4. private methods 私有方法 ---
- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textField resignFirstResponder];
}
#pragma mark - --- 5. setters 属性 ---
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self.buttonCenter setTitle:placeholder forState:UIControlStateNormal];
    [self.buttonCenter sizeToFit];
    self.buttonCenter.center = self.textField.center;
}

- (void)setText:(NSString *)text
{
    self.textField.text = text?:@"";
    if (text.length > 0) {
        [self textFieldShouldBeginEditing:self.textField];
    }
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView
{
    _inputAccessoryView = inputAccessoryView;
    self.textField.inputAccessoryView = inputAccessoryView;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textField.textColor = textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    NSAssert(_placeholder, @"Please set placeholder before setting placeholdercolor");
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    [self.buttonCenter setTitleColor:placeholderColor forState:UIControlStateNormal];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.textField.font = font;
    self.buttonCenter.titleLabel.font = font;
    [self.buttonCenter sizeToFit];
}

#pragma mark - --- 6. getters 属性 —

- (NSString *)text
{
    return self.textField.text;
}

- (UITextField *)textField
{
    if (!_textField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(STSearchBarMargin, STSearchBarMargin, self.frame.size.width-STSearchBarMargin*2, STTextFieldHeight)];
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleNone;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeySearch;
        textField.enablesReturnKeyAutomatically = YES;
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        textField.borderStyle=UITextBorderStyleNone;
        textField.layer.cornerRadius = 4.0f;
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor = [[UIColor colorWithWhite:0.783 alpha:1.000] CGColor];
        textField.layer.borderWidth= 0.5f;
        textField.backgroundColor = [UIColor whiteColor];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        textField.leftView = self.imageIcon;
        [textField setClipsToBounds:YES];
        _textField = textField;

    }
    return _textField;
}

- (UIButton *)buttonCancel
{
    if (!_buttonCancel) {
        UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancel.frame = CGRectMake(self.frame.size.width, 0, 60, STSearchBarHeight);
        buttonCancel.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [buttonCancel addTarget:self
                         action:@selector(cancelButtonTouched)
               forControlEvents:UIControlEventTouchUpInside];
        [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
        [buttonCancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonCancel setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        buttonCancel.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;

        _buttonCancel = buttonCancel;
    }
    return _buttonCancel;
}

- (UIButton *)buttonCenter
{
    if (!_buttonCenter) {
        UIButton *buttonCenter = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonCenter setImage:[UIImage imageNamed:@"icon_STSearchBar"] forState:UIControlStateNormal];
        [buttonCenter setTitleColor:[UIColor colorWithRed:(142.0/255) green:(142.0/255) blue:(147.0/255) alpha:1] forState:UIControlStateNormal];
        [buttonCenter.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonCenter setEnabled:NO];
        buttonCenter.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [buttonCenter sizeToFit];
        _buttonCenter = buttonCenter;
    }
    return _buttonCenter;
}

- (UIImageView *)imageIcon
{
    if (!_imageIcon) {
        UIImageView *imageIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_STSearchBar"]];
        [imageIcon setHidden:YES];
        _imageIcon = imageIcon;
    }
    return _imageIcon;
}
@end
