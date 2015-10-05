#import "AccountOperationsVC.h"
#import "CreditCoop+Model.h"
#import "CreditCoop+ViewModels.h"

#import "CreditCoop+Days.h"

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
{
    COOAccount * _account;
    COOOperation * _referenceOperation; // When searching
}
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
    
    _account = account_;

    [_account makeDays];
    [_account.managedObjectContext save:NULL];

    NSDictionary * vm = _account.viewModel;
    self.title = vm[@"subtitle"];
    
    [self setEntityName:@"Operation"
                context:_account.managedObjectContext
              predicate:[self predicate]
        sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO],
                          [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:NO]]
     sectionNameKeyPath:@"date"
    cellReuseIdentifier:@"AccountOperationCell"];
}

- (NSPredicate*) predicate
{
    return [NSPredicate predicateWithFormat:@"%K == %@",@"account", _account];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section_
{
    COOOperation * operation = self.frc.sections[section_].objects.firstObject;
    NSDictionary * vm = operation.day.viewModel;
    return [NSString stringWithFormat:@"%@\n%@",vm[@"title"],vm[@"amount"]];
}

- (void)configureCell:(AccountOperationCell *)cell_ withObject:(COOOperation*)operation_
{
    NSDictionary * vm = operation_.viewModel;
    cell_.titleLabel.text = vm[@"title"];
    cell_.detailLabel.text = vm[@"subtitle"];
    cell_.amountLabel.text = vm[@"amount"];
    cell_.amountLabel.textColor = vm[@"amountColor"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSFetchedResultsController deleteCacheWithName:nil];
    if(_referenceOperation==nil) {
        _referenceOperation = [self.frc objectAtIndexPath:indexPath];
        self.frc.fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[[self predicate],
                                                                                               [NSPredicate predicateWithFormat:@"%K == %@",@"attributes.cleanName", _referenceOperation.attributes.cleanName]]];
    } else {
        _referenceOperation = nil;
        self.frc.fetchRequest.predicate = [self predicate];
    }
    
    
    NSError * error;
    __unused BOOL ok = [self.frc performFetch:&error];
    NSAssert(ok, @"Fetch failed : %@",error);
    [self.tableView reloadData];
}

@end
