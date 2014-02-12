//
//  Photo+Flickr.m
//  Photomania
//
//  Created by MIMO on 30/01/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"

@implementation Photo (Flickr)


+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *) context
{
    Photo *photo = nil;
    
    // Antes de añadir una nueva foto al core data conocer si existe por el id único
    
    //***********************
    // ANTES DE METER UNA FOTO HACEMOS UNA PETICIÓN A LA BBDD PARA CONOCER SI ES ÚNICO
    // ES INEFICIENTE SI DAMOS DE ALTA DE GOLPE MUCHAS FOTOS
    // QUIZAS HACER UNA CONSULTA EN OTRO SITIO DE CUALES SON  LAS FOTOS CON UNICO ID --
    // opcional
    NSString *unique = photoDictionary[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",unique];
    //***********************
    
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];      // Lanzar la consulta
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
    } else if ([matches count]) {
        // Se ha encontrado la foto, entonces devolverla
        photo = [matches firstObject];
    } else {
        // No se ha encontrado la foto, entonces crearla y devolverla
        
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        // Setter de los datos de la foto
        photo.unique = unique;
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        
        // Setter del fotografo
        NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        photo.whoTook = [Photographer photographerWithName:photographerName inManagedObjectContext:context];
        
        
    }
    return photo;
    
}


+ (void)loadPhotosFromFlickrArray:(NSArray *)photos // of Flickr NSDictionary
         intoManagedObjectContext:(NSManagedObjectContext *) context
{
    for (NSDictionary *photo in photos) {
        [self photoWithFlickrInfo:photo inManagedObjectContext:context];
    }
}

@end
