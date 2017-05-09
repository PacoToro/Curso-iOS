//
//  Cajero+CoreDataProperties.swift
//  Curso iOS
//
//  Created by Paco Toro Mateo on 9/5/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import Foundation
import CoreData


extension Cajero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cajero> {
        return NSFetchRequest<Cajero>(entityName: "Cajero")
    }

    @NSManaged public var codigo: Int64
    @NSManaged public var direccion: String?
    @NSManaged public var estado: String?
    @NSManaged public var latitud: Double
    @NSManaged public var longitud: Double
    @NSManaged public var pertenece: Oficina?

}
