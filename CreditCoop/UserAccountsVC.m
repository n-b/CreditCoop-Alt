#import "UserAccountsVC.h"
#import "AccountOperationsVC.h"
#import "CreditCoop+Model.h"

#pragma mark UserAccountCell

@interface UserAccountCell : UITableViewCell
@property IBOutlet UILabel * labelLabel;
@property IBOutlet UILabel * numberLabel;
@property IBOutlet UILabel * balanceLabel;
@property IBOutlet UILabel * balanceDateLabel;
@end

@implementation UserAccountCell
@end

#pragma mark UserAccountsVC

@implementation UserAccountsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 69;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) setUser:(COOUser *)user_
{
    if (nil==user_) {
        return;
    }

    [self setEntityName:@"Account"
                context:user_.managedObjectContext
              predicate:[NSPredicate predicateWithFormat:@"%K == %@",@"user", user_]
        sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES],
                          [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]]
     sectionNameKeyPath:@"category"
    cellReuseIdentifier:@"UserAccountCell"];
    
    self.title = [[user_.accounts valueForKeyPath:@"@sum.balance"] description];
}

- (void)configureCell:(UserAccountCell *)cell_ withObject:(COOAccount*)account_
{
    cell_.labelLabel.text = account_.label;
    cell_.numberLabel.text = account_.number;
    cell_.balanceLabel.text = account_.balance.description;
    cell_.balanceDateLabel.text = account_.balanceDate;
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue_ sender:(id)sender_
{
    if ([segue_.identifier isEqualToString:@"showDetail"]) {
        COOAccount *account = [self.frc objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [segue_.destinationViewController setAccount:account];
    }
}

@end
