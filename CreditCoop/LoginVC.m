#import "LoginVC.h"


@implementation UIControl (FirstResponderIBAction)
- (IBAction) pleaseBecomeFirstResponder
{
    [self becomeFirstResponder];
}
@end

@interface UITextField (More)
@property(nullable, nonatomic,strong) IBOutlet UIView *rightView;
@end

@implementation UITextField (Yo)
- (IBAction)switchSecureText
{
    self.secureTextEntry = !self.secureTextEntry;
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
    [(userCode?_userCodeField:_sesameField) becomeFirstResponder];
}

- (IBAction)login
{
    NSString * userCode = _userCodeField.text;
    NSString * sesame = _sesameField.text;
    [self.creditcoop loginWithUserCode:userCode sesame:sesame completion:^(NSError * __nullable error) {
        if(error==nil) {
            [NSUserDefaults.standardUserDefaults setObject:userCode forKey:@"CreditCoop.Login.userCode"];
            [self.creditcoop refreshAllAccounts:^(NSError * __nullable error) {
                [self presentError:error];
            }];
        } else {
            [self presentError:error];
        }
    }];
}

@end
