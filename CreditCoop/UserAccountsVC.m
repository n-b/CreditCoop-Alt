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

@interface UserAccountsVC () <NSFetchedResultsControllerDelegate>
@end

@implementation UserAccountsVC
{
    NSFetchedResultsController * _frc;
}

- (void) setUser:(COOUser *)user_
{
    if (nil==user_) {
        return;
    }
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"user", user_];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES],
                                     [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]];
    
    _frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:user_.managedObjectContext
            sectionNameKeyPath:@"category"
            cacheName:nil];
    _frc.delegate = self;
    
    NSError * error;
    __unused BOOL ok = [_frc performFetch:&error];
    NSAssert(ok, @"Fetch failed : %@",error);
    
    [self.tableView reloadData];
    
    self.title = [[user_.accounts valueForKeyPath:@"@sum.balance"] description];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Comptes"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller_
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller_ didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo_
           atIndex:(NSUInteger)sectionIndex_ forChangeType:(NSFetchedResultsChangeType)type_
{
    switch(type_) {
        case NSFetchedResultsChangeInsert: [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex_] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex_] withRowAnimation:UITableViewRowAnimationFade]; break;
        default: break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller_ didChangeObject:(id)anObject_
       atIndexPath:(NSIndexPath *)indexPath_ forChangeType:(NSFetchedResultsChangeType)type_
      newIndexPath:(NSIndexPath *)newIndexPath_
{
    switch(type_) {
        case NSFetchedResultsChangeInsert: [self.tableView insertRowsAtIndexPaths:@[newIndexPath_] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [self.tableView deleteRowsAtIndexPaths:@[indexPath_] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeUpdate: [self configureCell:(UserAccountCell*)[self.tableView cellForRowAtIndexPath:indexPath_] withObject:[_frc objectAtIndexPath:indexPath_]]; break;
        case NSFetchedResultsChangeMove: [self.tableView moveRowAtIndexPath:indexPath_ toIndexPath:newIndexPath_]; break;
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller_
{
    [self.tableView endUpdates];
}

#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView_ titleForHeaderInSection:(NSInteger)section_
{
    return [_frc.sections[section_] name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView_
{
    return [_frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section_
{
    return [_frc.sections[section_] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath_
{
    UserAccountCell * cell = (UserAccountCell *)[self.tableView dequeueReusableCellWithIdentifier:@"UserAccountCell" forIndexPath:indexPath_];
    [self configureCell:cell withObject:[_frc objectAtIndexPath:indexPath_]];
    return cell;
}

- (void)configureCell:(UserAccountCell *)cell_ withObject:(COOAccount*)account_
{
    cell_.labelLabel.text = account_.label;
    cell_.numberLabel.text = account_.number;
    cell_.balanceLabel.text = [account_.balance description];
    cell_.balanceDateLabel.text = account_.balanceDate;
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue_ sender:(id)sender_
{
    if ([segue_.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        COOAccount *account = [_frc objectAtIndexPath:indexPath];
        [segue_.destinationViewController setAccount:account];
    }
}

@end
