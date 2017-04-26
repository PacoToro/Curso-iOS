//
//  OficinasCajerosViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 18/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

enum tiposPOI: String {
    case Oficina = "Oficina"
    case Cajero = "Cajero"
}

class OficinasCajerosViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    var tipoPOI = tiposPOI.Oficina
    var pois:[NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        mostarPOIsEnMapa()
        
        obtenerDatosActualizados()
    }
    
    func obtenerDatosActualizados() {
        
        guard Utils.isInternetAvailable() else {
            print("No se ha podido actualizar los datos de Oficinas y Cajeros porque no hay acceso a Internet")
            return
        }
        
        let url = URL(string: "http://\(Utils.endPoint())/\(tipoPOI)s.json")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]

            DAO.borrarPOIs(entityName: self.tipoPOI)

            for poi in json {
                if self.tipoPOI == .Oficina {
                    DAO.guardarOficina(codigo: poi["codigo"] as! Int,
                                   direccion: poi["direccion"] as! String,
                                   estado: poi["estado"] as! String,
                                   latitud: poi["latitud"] as! Double,
                                   longitud: poi["longitud"] as! Double,
                                   mail: poi["mail"] as! String,
                                   telefono: poi["telefono"] as! String)
                } else if self.tipoPOI == .Cajero {
                    DAO.guardarCajero(codigo: poi["codigo"] as! Int,
                                       direccion: poi["direccion"] as! String,
                                       estado: poi["estado"] as! String,
                                       latitud: poi["latitud"] as! Double,
                                       longitud: poi["longitud"] as! Double)
                }
            }
            
            self.mostarPOIsEnMapa()
            
        }
        
        task.resume()
    }
    
    func mostarPOIsEnMapa() {
        pois = DAO.leerPOI(entityName: tipoPOI)
        
        for poi in pois {
            let latitud = poi.value(forKey: "latitud") as! Double
            let longitud = poi.value(forKey: "longitud") as! Double
            let codigo = poi.value(forKey: "codigo") as! Int
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
            annotation.title = tipoPOI == tiposPOI.Oficina ? "Oficina \(codigo)" : "Cajero \(codigo)"
            annotation.subtitle = poi.value(forKey: "direccion") as? String
            mapView.addAnnotation(annotation)
        }
        
        // Muestra la región de mapa que incluye todos los POIs
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // mapView.centerCoordinate = userLocation.location!.coordinate
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
}
