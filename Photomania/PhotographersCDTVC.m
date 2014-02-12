//
//  PhotographersCDTVC.m
//  Photomania
//
//  Created by MIMO on 30/01/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "PhotographersCDTVC.h"
#import "Photographer.h"
#import "PhotoDatabaseAvailability.h"

@implementation PhotographersCDTVC

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = [note.userInfo objectForKey:PhotoDatabaseAvailabilityContext];
                                                  }];
}

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = nil;        // Para que busque todos los fotografos sin ningún filtro
    // request.fetchLimit = 100;    // limitar el número de objetos devueltos
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                                selector:@selector(localizedStandardCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];  // Ultimo parámetro no queremos que cacheé resultados
}

// Implementar el método del delegado que devuelve una celda en el indexPath correspondiente
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Photographer Cell"];    // Creamos una celda nueva con ese identificador
    
    Photographer *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];           // Obtener el obj. fotografo en ese indexPath
    
    cell.textLabel.text = photographer.name;                                                            // Completar datos de la celda con el obj fotografo
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [photographer.photos count]];  //
    
    return cell;
}


@end
