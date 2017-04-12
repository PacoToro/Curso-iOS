//
//  Utils.swift
//  Curso iOS
//
//  Created by Paco Toro on 12/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit

class Utils {
    
    static func idioma() -> String {
        let pre = Locale.current.languageCode ?? "es"
        
        if pre == "en" {
            return pre
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
    
}
