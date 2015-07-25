#import "AccountOperationsVC.h"
#import "CreditCoop+Model.h"
#import "CreditCoop+ViewModels.h"

#pragma mark AccountOperationCell

@interface AccountOperationCell : UITableViewCell
@property IBOutlet UILabel * amountLabel;
@property IBOutlet UILabel * titleLabel;
@property IBOutlet UILabel * detailLabel;
@end

@implementation AccountOperationCell
@end

#pragma mark AccountOperationsVC

@implementation AccountOperationsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 69;
}

- (void)setAccount:(COOAccount *)account_
{
    if (nil==account_) {
        return;
    }
    
    [self setEntityName:@"Operation"
                context:account_.managedObjectContext
              predicate:[NSPredicate predicateWithFormat:@"%K == %@",@"account", account_]
        sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO],
                          [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:NO]]
     sectionNameKeyPath:@"dayDescription"
    cellReuseIdentifier:@"AccountOperationCell"];
    
    NSDictionary * vm = account_.viewModel;
    self.title = vm[@"subtitle"];
    self.navigationItem.prompt = vm[@"amount"];
}

- (void)configureCell:(AccountOperationCell *)cell_ withObject:(COOOperation*)operation_
{
    NSDictionary * vm = operation_.viewModel;
    cell_.titleLabel.text = vm[@"title"];
    cell_.detailLabel.text = vm[@"subtitle"];
    cell_.amountLabel.text = vm[@"amount"];
    cell_.amountLabel.textColor = vm[@"amountColor"];
}

@end
