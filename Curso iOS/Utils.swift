//
//  Utils.swift
//  Curso iOS
//
//  Created by Paco Toro on 12/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class Utils {
    
    static func idioma() -> String {
        let idioma = Locale.current.languageCode ?? "es"
        
        if idioma == "en" {
            return idioma
        } else {
            return "es"
        }
    }
    
    static func abrirApp(nombre: String, urlScheme: String, urlStore: String, sender: UIViewController) {
        let URLScheme = URL(string: urlScheme)
        
        if URLScheme != nil && UIApplication.shared.canOpenURL(URLScheme!) && UIApplication.shared.openURL(URLScheme!) {
            print("Se abre la aplicación de \(nombre) con éxito")
        } else {
            let mensaje = String(format: NSLocalizedString("Utils_Se ha detectado que no tiene instalada la aplicación", comment: ""), arguments: [nombre])
            
            let alert = UIAlertController(title: NSLocalizedString("TextoComun_Información", comment:""),
                                          message: mensaje,
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("TextoComun_Sí", comment:""), style: UIAlertActionStyle.default, handler: { action in
                if let URLSeleccionada = URL(string: urlStore) {
                    UIApplication.shared.openURL(URLSeleccionada)
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("TextoComun_No", comment:""), style: UIAlertActionStyle.cancel, handler: nil))
            sender.present(alert, animated: true, completion: nil)
        }
    }
    
    static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func endPoint() -> String {
        return "192.168.1.98"
    }
    
}
