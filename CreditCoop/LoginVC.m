#import "LoginVC.h"

@interface LoginVC ()
@property IBOutlet UITextField * userCodeField;
@property IBOutlet UITextField * sesameField;
@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userCodeField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"CreditCoop.Login.userCode"];
}

- (IBAction)login
{
    [self.creditcoop loginWithUserCode:self.userCodeField.text sesame:self.sesameField.text completion:^(NSString *error) {
        if(error)
            [[[UIAlertView alloc] initWithTitle:@"Login Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        else
            [[NSUserDefaults standardUserDefaults] setObject:self.userCodeField.text forKey:@"CreditCoop.Login.userCode"];
    }];
}

@end
