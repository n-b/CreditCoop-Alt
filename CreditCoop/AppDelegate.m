@import UIKit;

#import "LoginVC.h"
#import "UserAccountsVC.h"
#import "CreditCoop.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property CreditCoop *creditcoop;
@end

int main(int argc_, char *argv_[])
{
    @autoreleasepool {
        return UIApplicationMain(argc_, argv_, nil, NSStringFromClass([AppDelegate class]));
    }
}

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application_ didFinishLaunchingWithOptions:(NSDictionary *)launchOptions_
{
    self.creditcoop = [CreditCoop new];
    [self.creditcoop logout]; // Force Delete
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self setLoginVCAnimated:NO];
        [self.creditcoop addObserver:self forKeyPath:@"user" options:0 context:__FILE__];
    });
    return YES;
}

- (IBAction)logout
{
    [self.creditcoop logout];
}

- (void)setLoginVCAnimated:(BOOL)animated_
{
    COOUser * user = self.creditcoop.user;
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    UserAccountsVC *controller = (UserAccountsVC *)navigationController.topViewController;
    controller.user = user;
    
    if(user) {
        [self.window.rootViewController dismissViewControllerAnimated:animated_ completion:nil];
    } else {
        LoginVC * loginVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        loginVC.creditcoop = self.creditcoop;
        [self.window.rootViewController presentViewController:loginVC animated:animated_ completion:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath_ ofObject:(id)object_ change:(NSDictionary *)change_ context:(void *)context_
{
    if (context_==__FILE__) {
        [self setLoginVCAnimated:YES];
    } else {
        [super observeValueForKeyPath:keyPath_ ofObject:object_ change:change_ context:context_];
    }
}
@end
