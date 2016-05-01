#import "UserAccountsVC.h"
#import "AccountOperationsVC.h"
#import "CreditCoop+Model.h"
#import "CreditCoop+ViewModels.h"

#pragma mark UserAccountCell

@interface UserAccountCell : UITableViewCell
@property IBOutlet UILabel * titleLabel;
@property IBOutlet UILabel * detailLabel;
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
        sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES],
                          [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES]]
     sectionNameKeyPath:@"category"
    cellReuseIdentifier:@"UserAccountCell"];
    
    self.title = [[user_.accounts valueForKeyPath:@"@sum.balance"] description];
}

- (void)configureCell:(UserAccountCell *)cell_ withObject:(COOAccount*)account_
{
    NSDictionary * vm = account_.viewModel;
    cell_.titleLabel.text = vm[@"title"];
    cell_.detailLabel.text = vm[@"subtitle"];
    cell_.balanceLabel.text = vm[@"amount"];
    cell_.balanceDateLabel.text = vm[@"date"];
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
