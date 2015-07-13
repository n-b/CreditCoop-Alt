//
//  FRCVC.m
//
//
//  Created by Nicolas on 03/12/12.
//  
//

#import "FRCVC.h"

@interface FRCVC () <NSFetchedResultsControllerDelegate>
@end

@interface FRCVC (FRCVC) <FRCVC> // Allow me to call methods implemented by subclasses
@end

@implementation FRCVC
{
    NSFetchedResultsController * _frc;
    Class _cellClass;
    UINib * _cellNib;
    NSString* _cellReuseIdentifier;
}

- (void) setEntityName:(NSString*)entityName_
               context:(NSManagedObjectContext*)context_
             predicate:(NSPredicate*)predicate_
       sortDescriptors:(NSArray*)sortDescriptors_
             cellClass:(Class)cellClass_
   cellReuseIdentifier:(NSString*)cellReuseIdentifier_
{
    [self setEntityName:entityName_ context:context_ predicate:predicate_ sortDescriptors:sortDescriptors_ cellClass:cellClass_ cellNib:nil cellReuseIdentifier:cellReuseIdentifier_];
}

- (void) setEntityName:(NSString*)entityName_
               context:(NSManagedObjectContext*)context_
             predicate:(NSPredicate*)predicate_
       sortDescriptors:(NSArray*)sortDescriptors_
               cellNib:(UINib*)cellNib_
   cellReuseIdentifier:(NSString*)cellReuseIdentifier_
{
    [self setEntityName:entityName_ context:context_ predicate:predicate_ sortDescriptors:sortDescriptors_ cellClass:nil cellNib:cellNib_ cellReuseIdentifier:cellReuseIdentifier_];
}

- (void) setEntityName:(NSString*)entityName_
               context:(NSManagedObjectContext*)context_
             predicate:(NSPredicate*)predicate_
       sortDescriptors:(NSArray*)sortDescriptors_
             cellClass:(Class)cellClass_
               cellNib:(UINib*)cellNib_
   cellReuseIdentifier:(NSString*)cellReuseIdentifier_
{
    // Prepare FRC
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName_];
    fetchRequest.predicate = predicate_;
    fetchRequest.sortDescriptors = sortDescriptors_;
    
    _frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fetchRequest
            managedObjectContext:context_
            sectionNameKeyPath:nil
            cacheName:nil];
    _frc.delegate = self;
    
    NSError * error;
    __unused BOOL ok = [_frc performFetch:&error];
    NSAssert(ok, @"Fetch failed : %@",error);
    
    // Register Cell
    _cellReuseIdentifier = cellReuseIdentifier_;
    if([self isViewLoaded])
    {
        if(cellClass_)
            [[self tableView] registerClass:cellClass_ forCellReuseIdentifier:_cellReuseIdentifier];
        if(cellNib_)
            [[self tableView] registerNib:cellNib_ forCellReuseIdentifier:_cellReuseIdentifier];
    }
    else
    {
        _cellClass = cellClass_;
        _cellNib = cellNib_;
    }

    // Reload
    [[self tableView] reloadData];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if(_cellClass)
        [[self tableView] registerClass:_cellClass forCellReuseIdentifier:_cellReuseIdentifier];
    if(_cellNib)
        [[self tableView] registerNib:_cellNib forCellReuseIdentifier:_cellReuseIdentifier];
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
        case NSFetchedResultsChangeUpdate: [self configureCell:[[self tableView] cellForRowAtIndexPath:indexPath] withObject:[_frc objectAtIndexPath:indexPath]]; break;
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
    UITableViewCell * cell = [[self tableView] dequeueReusableCellWithIdentifier:_cellReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell withObject:[_frc objectAtIndexPath:indexPath]];
    return cell;
}

@end
