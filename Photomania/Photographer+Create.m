//
//  Photographer+Create.m
//  Photomania
//
//  Created by MIMO on 30/01/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)

+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Photographer *photographer = nil;
    
    if ([name length]) {
        // Antes de añadir un nuevo fotógrafo al core data conocer si existe por el id único
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
        
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];  // Lanzar la consulta
        
        if (!matches || error || ([matches count] > 1)) {
            // handle error
        } else if ([matches count]) {
            // Se ha encontrado el fotografo, entonces devolverlo
            photographer = [matches firstObject];
        } else {
            // No se ha encontrado el fotografo, entonces crearlo y devolverlo
            photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer"
                                                         inManagedObjectContext:context];
            // Setter de los datos del fotografo
            photographer.name = name;
        }

    }
    return  photographer;
}
    
@end