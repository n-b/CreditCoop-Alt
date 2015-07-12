//
//  UserAccountsVC.m
//  CreditCoop
//
//  Created by Nicolas on 02/12/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "UserAccountsVC.h"
#import "AccountOperationsVC.h"
#import "CreditCoop+Model.h"

@interface UserAccountCell : UITableViewCell
@property IBOutlet UILabel * labelLabel;
@property IBOutlet UILabel * numberLabel;
@property IBOutlet UILabel * balanceLabel;
@property IBOutlet UILabel * balanceDateLabel;
@end

@implementation UserAccountCell
@end

#pragma mark -

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
    
    self.title = [[[user_.accounts array] valueForKeyPath:@"@sum.balance"] description];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Comptes"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
}

/****************************************************************************/
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert: [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade]; break;
    }
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert: [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeDelete: [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; break;
        case NSFetchedResultsChangeUpdate: [self configureCell:(UserAccountCell*)[self.tableView cellForRowAtIndexPath:indexPath] withObject:[_frc objectAtIndexPath:indexPath]]; break;
        case NSFetchedResultsChangeMove: [[self tableView] moveRowAtIndexPath:indexPath toIndexPath:newIndexPath]; break;
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}

/****************************************************************************/
#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_frc.sections[section] name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_frc.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserAccountCell * cell = (UserAccountCell *)[self.tableView dequeueReusableCellWithIdentifier:@"UserAccountCell" forIndexPath:indexPath];
    [self configureCell:cell withObject:[_frc objectAtIndexPath:indexPath]];
    return cell;
}

- (void)configureCell:(UserAccountCell *)cell withObject:(COOAccount*)account
{
    cell.labelLabel.text = account.label;
    cell.numberLabel.text = account.number;
    cell.balanceLabel.text = [account.balance description];
    cell.balanceDateLabel.text = account.balanceDate;
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        COOAccount *account = [_frc objectAtIndexPath:indexPath];
        [[segue destinationViewController] setAccount:account];
    }
}

@end
