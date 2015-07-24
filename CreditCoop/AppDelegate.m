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
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    LoginVC *controller = (LoginVC *)navigationController.topViewController;
    controller.creditcoop = self.creditcoop;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.creditcoop addObserver:self forKeyPath:@"user" options:NSKeyValueObservingOptionInitial context:__FILE__];
    });
    return YES;
}

- (IBAction)logout
{
    [self.creditcoop logout];
}

- (void)setLoginVisibleAnimated:(BOOL)animated_
{
    if(self.creditcoop.user) {
        UINavigationController * accountsNavC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"UserAccounts"];
        ((UserAccountsVC*)accountsNavC.visibleViewController).user = self.creditcoop.user;
        [self.window.rootViewController presentViewController:accountsNavC animated:animated_ completion:nil];
    } else {
        [self.window.rootViewController dismissViewControllerAnimated:animated_ completion:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath_ ofObject:(id)object_ change:(NSDictionary *)change_ context:(void *)context_
{
    if (context_==__FILE__) {
        [self setLoginVisibleAnimated:YES];
    } else {
        [super observeValueForKeyPath:keyPath_ ofObject:object_ change:change_ context:context_];
    }
}

@end
