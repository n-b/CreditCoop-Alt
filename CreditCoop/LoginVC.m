#import "LoginVC.h"


@implementation UIControl (FirstResponderIBAction)
- (IBAction) pleaseBecomeFirstResponder
{
    [self becomeFirstResponder];
}
@end

@interface UITextField (MoreOutlets)
@property(nullable, nonatomic,strong) IBOutlet UIView *rightView;
@end

@implementation UITextField (Yo)
- (IBAction)switchSecureText:(UIButton*)sender_
{
    [self resignFirstResponder]; // prevent the font and caret from going bonkers
    self.secureTextEntry = !self.secureTextEntry;
    [self becomeFirstResponder];
    [sender_ setTitle:self.secureTextEntry?@"🙈":@"🐵" forState:UIControlStateNormal];
}
@end

@implementation UIViewController (PresentError)
- (void)presentError:(NSError*)error_
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:error_.localizedDescription message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end


@implementation LoginVC
{
    IBOutlet UITextField * _userCodeField;
    IBOutlet UITextField * _sesameField;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sesameField.rightViewMode = UITextFieldViewModeAlways;
    
    NSString * userCode = [NSUserDefaults.standardUserDefaults stringForKey:@"CreditCoop.Login.userCode"];
    _userCodeField.text = userCode;
    [(userCode?_sesameField:_userCodeField) becomeFirstResponder];
    
#if DEBUG
    _sesameField.text = [NSUserDefaults.standardUserDefaults stringForKey:@"CreditCoop.Debug.Login.sesame"];
#endif
}

- (IBAction)login
{
    NSString * userCode = _userCodeField.text;
    NSString * sesame = _sesameField.text;
    _userCodeField.enabled = _sesameField.enabled = NO;
    [self.creditcoop loginWithUserCode:userCode sesame:sesame completion:^(NSError * __nullable error) {
        if(error==nil) {
            [NSUserDefaults.standardUserDefaults setObject:userCode forKey:@"CreditCoop.Login.userCode"];
            [self.creditcoop refreshAllAccounts:^(NSError * __nullable error) {
                [self presentError:error];
            }];
        } else {
            [self presentError:error];
        }
        _userCodeField.enabled = _sesameField.enabled = YES;
    }];
}

@end
