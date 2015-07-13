@import UIKit;
@import CoreData;

@interface FRCVC : UITableViewController

- (void)setEntityName:(NSString*)entityName_
              context:(NSManagedObjectContext*)context_
            predicate:(NSPredicate*)predicate_
      sortDescriptors:(NSArray*)sortDescriptors_
   sectionNameKeyPath:(NSString*)sectionNameKeyPath_
  cellReuseIdentifier:(NSString*)cellReuseIdentifier_;

@property (readonly) NSFetchedResultsController * frc;

@end

@protocol FRCVC // Subclasses must conform to this protocol
- (void)configureCell:(UITableViewCell*)cell_ withObject:(id)object_;
@end
