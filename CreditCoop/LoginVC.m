#import "LoginVC.h"
#import "UIViewController+PresentError.h"


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

@implementation LoginVC
{
    IBOutlet UITextField * _userCodeField;
    IBOutlet UITextField * _sesameField;
    IBOutlet UIActivityIndicatorView *_loginIndicator;
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
    
    [self.creditcoop addObserver:self forKeyPath:@"loginStatus" options:NSKeyValueObservingOptionInitial context:__FILE__];
}

- (IBAction)login
{
    NSString * userCode = _userCodeField.text;
    NSString * sesame = _sesameField.text;
    _userCodeField.enabled = _sesameField.enabled = NO;
    [self.creditcoop loginWithUserCode:userCode sesame:sesame completion:^(NSError * __nullable error) {
        if(error==nil) {
            [NSUserDefaults.standardUserDefaults setObject:userCode forKey:@"CreditCoop.Login.userCode"];
        } else {
            [self presentError:error];
        }
        _userCodeField.enabled = _sesameField.enabled = YES;
    }];
}

- (void)updateLoginIndicator
{
    if(self.creditcoop.loginStatus == CreditCoopLoginStatusConnecting) {
        [_loginIndicator startAnimating];
    } else {
        [_loginIndicator stopAnimating];
    }
}

// MARK: KVO

- (void)observeValueForKeyPath:(NSString *)keyPath_ ofObject:(id)object_ change:(NSDictionary *)change_ context:(void *)context_
{
    if (context_==__FILE__) {
        [self updateLoginIndicator];
    } else {
        [super observeValueForKeyPath:keyPath_ ofObject:object_ change:change_ context:context_];
    }
}

@end
