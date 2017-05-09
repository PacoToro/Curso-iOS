//
//  Oficina+CoreDataProperties.swift
//  Curso iOS
//
//  Created by Paco Toro Mateo on 9/5/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import Foundation
import CoreData


extension Oficina {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Oficina> {
        return NSFetchRequest<Oficina>(entityName: "Oficina")
    }

    @NSManaged public var codigo: Int64
    @NSManaged public var direccion: String?
    @NSManaged public var estado: String?
    @NSManaged public var latitud: Double
    @NSManaged public var longitud: Double
    @NSManaged public var mail: String?
    @NSManaged public var telefono: String?
    @NSManaged public var tiene: NSSet?

}

// MARK: Generated accessors for tiene
extension Oficina {

    @objc(addTieneObject:)
    @NSManaged public func addToTiene(_ value: Cajero)

    @objc(removeTieneObject:)
    @NSManaged public func removeFromTiene(_ value: Cajero)

    @objc(addTiene:)
    @NSManaged public func addToTiene(_ values: NSSet)

    @objc(removeTiene:)
    @NSManaged public func removeFromTiene(_ values: NSSet)

}
