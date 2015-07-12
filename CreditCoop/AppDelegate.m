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
    UserAccountsVC *controller = (UserAccountsVC *)navigationController.topViewController;
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                                    style:UIBarButtonItemStylePlain
                                                                                   target:self
                                                                                   action:@selector(logout)];

    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.creditcoop addObserver:self
                          forKeyPath:@"user"
                             options:NSKeyValueObservingOptionInitial
                             context:(__bridge void *)([AppDelegate class])];
    });
    return YES;
}

- (void) logout
{
    [self.creditcoop logout];
}

- (void) userDidChange
{
    COOUser * user = self.creditcoop.user;
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    UserAccountsVC *controller = (UserAccountsVC *)navigationController.topViewController;
    controller.user = user;
    
    if(user)
    {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        LoginVC * loginVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        loginVC.creditcoop = self.creditcoop;
        [self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath_ ofObject:(id)object_ change:(NSDictionary *)change_ context:(void *)context_
{
    if (context_ == (__bridge void *)([AppDelegate class])) {
        if(object_==self.creditcoop && [keyPath_ isEqualToString:@"user"])
            [self userDidChange];
    } else {
        [super observeValueForKeyPath:keyPath_ ofObject:object_ change:change_ context:context_];
    }
}
@end
