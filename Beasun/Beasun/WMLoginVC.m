//
//  WMLoginVC.m
//  Beasun
//
//  Created by maginawin on 15/9/15.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMLoginVC.h"
#import "WMBasicTBC.h"

@interface WMLoginVC ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *loginNameTag;
@property (weak, nonatomic) IBOutlet UILabel *passwordTag;

@end

@implementation WMLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBase];
    
    [self configureNoti];
}

- (IBAction)loginClick:(id)sender {
    [self.view endEditing:YES];
    
    // 若是正确, 跳
    switch ([self checkUserNameAndPassword]) {
        case 0: {
            [self showBasicTBC];
            break;
        }
            
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)userNameDidEndOnExit:(id)sender {
    if ([(UITextField *)sender text].length > 0) {
        [_passwordTextField becomeFirstResponder];
    }
}
- (IBAction)passDidEndOnExit:(id)sender {
    switch ([self checkUserNameAndPassword]) {
            // Success
        case 0: {
            [self showBasicTBC];
            break;
        }
            // UserName not exist
        case 1: {
            
            break;
        }
            // Password error
        case 2: {
            
            break;
        }
    }

}

#pragma makr - Selector

- (void)keyboardWillShowNotification {
    [UIView animateWithDuration:0.5 animations:^ {
        self.view.transform = CGAffineTransformMakeTranslation(0.f, -64.f);
    }];
}

- (void)keyboardWillHideNotification {
    [UIView animateWithDuration:0.5 animations:^ {
        self.view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Private

/** Check result : 0 is success; 1 is userName not exist; 2 is password error */
- (NSInteger)checkUserNameAndPassword {
    NSString *userName = _userNameTextField.text;
    NSString *password = _passwordTextField.text;
    
    if ([userName isEqualToString:@"test"]) {
        if ([password isEqualToString:@"a1234"]) {
            return 0;
        } else {
            return 2;
        }
    } else {
        return 1;
    }
}

/** Show basic tabbar view controller */
- (void)showBasicTBC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WMBasicTBC *basicTBC = (WMBasicTBC *)[sb instantiateViewControllerWithIdentifier:@"basicTBC"];
    basicTBC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self showViewController:basicTBC sender:self];
}

- (void)configureBase {
    //
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginButton.layer.borderWidth = 0.5f;
    _loginButton.layer.cornerRadius = 4.f;
}

- (void)configureNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification) name:UIKeyboardWillHideNotification object:nil];
}

@end
