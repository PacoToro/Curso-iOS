//
//  DAO.swift
//  Curso iOS
//
//  Created by Paco Toro on 18/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit
import CoreData

class DAO {
    
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }

    static func getStoreCoordinator() -> NSPersistentStoreCoordinator {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentStoreCoordinator
    }
    
    static func borrarPOIs(entityName:tiposPOI) {
        
        let context = getContext()
        let storeCoordinator = getStoreCoordinator()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try storeCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print("Error al borrar POIs de tipo \(entityName.rawValue) : \(error)")
        }
    }
    
    static func guardarOficina(codigo:Int, direccion:String, estado:String, latitud:Double, longitud:Double, mail:String, telefono:String) {
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Oficina", in: context)!
        
        let oficina = NSManagedObject(entity: entity, insertInto: context) as! Oficina
        
        oficina.codigo = Int64(codigo)
        oficina.direccion = direccion
        oficina.estado = estado
        oficina.latitud = latitud
        oficina.longitud = longitud
        oficina.mail = mail
        oficina.telefono = telefono
        
        /*
        oficina.setValue(codigo, forKey: "codigo")
        oficina.setValue(direccion, forKey: "direccion")
        oficina.setValue(estado, forKey:"estado")
        oficina.setValue(latitud, forKey:"latitud")
        oficina.setValue(longitud, forKey:"longitud")
        oficina.setValue(mail, forKey:"mail")
        oficina.setValue(telefono, forKey:"telefono")
        */
        
        do {
            try context.save()
            print("Se ha guardado la Oficina con código \(codigo)")
        } catch let error as NSError {
            print("Se ha producido un error al guardar una oficina. \(error)")
        }
    }
    
    static func guardarCajero(codigo:Int, direccion:String, estado:String, latitud:Double, longitud:Double, oficina: Oficina?) {
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Cajero", in: context)!
        
        let cajero = NSManagedObject(entity: entity, insertInto: context) as! Cajero
        
        cajero.codigo = Int64(codigo)
        cajero.direccion = direccion
        cajero.estado = estado
        cajero.latitud = latitud
        cajero.longitud = longitud
        cajero.pertenece = oficina
        
        /*
        cajero.setValue(codigo, forKey: "codigo")
        cajero.setValue(direccion, forKey: "direccion")
        cajero.setValue(estado, forKey:"estado")
        cajero.setValue(latitud, forKey:"latitud")
        cajero.setValue(longitud, forKey:"longitud")
        */
        
        do {
            try context.save()
            print("Se ha guardado el Cajero con código \(codigo)")
        } catch let error as NSError {
            print("Se ha producido un error al guardar una cajero. \(error)")
        }
    }
    
    static func leerPOI(entityName:tiposPOI) -> [NSManagedObject] {
        
        var poiArray:[NSManagedObject] = []
        let context = getContext()
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
            fetchRequest.predicate = NSPredicate(format: "estado == 'activo'")
        do {
            poiArray = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return poiArray
    }
    
    static func obtenerOficina(codigo: Int) -> Oficina? {
        
        var oficina:Oficina?
        let context = getContext()
        
        let request:NSFetchRequest<Oficina> = Oficina.fetchRequest()
        request.predicate = NSPredicate(format: "codigo == %d", codigo)
        do {
            let resultsArray = try context.fetch(request)
            
            if !resultsArray.isEmpty {
                oficina = resultsArray[0]
            }            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return oficina
    }
    
}
