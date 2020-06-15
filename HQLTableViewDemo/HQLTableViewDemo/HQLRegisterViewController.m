//
//  HQLRegisterViewController.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLRegisterViewController.h"

@interface HQLRegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *captchaButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation HQLRegisterViewController


#pragma mark - View life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    [self setupTextFieldDelegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}




#pragma mark - Actions

- (IBAction)captchaButtonDidClicked:(id)sender {
    
}

- (IBAction)registerButtonDidClicked:(id)sender {
    
    
}


#pragma mark - Private

- (void)setupTextFieldDelegate {
    self.phoneTextField.delegate = self;
    self.captchaTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordConfirmTextField.delegate = self;
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - NSNotification

- (void)textFieldTextDidChanged:(NSNotification *)notification {
    BOOL isPhoneNumberNull = self.phoneTextField.text.length == 0;
    BOOL isCaptchaNull = self.captchaTextField.text.length == 0;
    BOOL isPasswordNull = self.passwordTextField.text.length == 0;
    BOOL isPasswordConfirmNull = self.passwordConfirmTextField.text.length == 0;
    
    self.captchaButton.enabled = !isPhoneNumberNull;
    self.registerButton.enabled = !(isPhoneNumberNull && isCaptchaNull && isPasswordNull && isPasswordConfirmNull);
}


@end
