#import "LoginVC.h"

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
    [self.creditcoop loginWithUserCode:userCode sesame:sesame completion:^(BOOL success) {
        if(success) {
            [NSUserDefaults.standardUserDefaults setObject:userCode forKey:@"CreditCoop.Login.userCode"];
        }
    }];
}

@end


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
- (IBAction) switchSecureText
{
    self.secureTextEntry = !self.secureTextEntry;
}
@end