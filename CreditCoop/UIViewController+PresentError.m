#import "UIViewController+PresentError.h"

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
