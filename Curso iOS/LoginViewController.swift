//
//  LoginViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 11/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let numIntentosKey = "numIntentosDisponibles"
    let maxNumIntentos = 3
    let datosAcceso = (nombre: "Fernando", usuario: "fernan2", contraseña: "invitado")
    
    @IBOutlet weak var txtIdentificador: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    
    @IBAction func pulsaEntrar(_ sender: Any) {        
        let defaults = UserDefaults.standard
        let numIntentosConsumidos = defaults.integer(forKey:numIntentosKey)
        
        if numIntentosConsumidos == maxNumIntentos {
            txtIdentificador.text = ""
            txtIdentificador.isEnabled = false
            txtContraseña.text = ""
            txtContraseña.isEnabled = false
            muestraAviso(titulo: NSLocalizedString("TextoComun_Aviso",
                                                   comment: ""),
                         mensaje: NSLocalizedString("LoginViewController_Ha alcanzdo el número máximo...",
                                                    comment: ""))
        } else if txtIdentificador.text == datosAcceso.usuario && txtContraseña.text == datosAcceso.contraseña {
            
            defaults.set(0, forKey: numIntentosKey)
            muestraAviso(titulo: NSLocalizedString("LoginViewController_Acceso autorizado",
                                                   comment: ""),
                         mensaje: String(format: NSLocalizedString("LoginViewController_Bienvenido",
                                                                   comment: ""),
                                         datosAcceso.nombre))
        } else {
            muestraAviso(titulo: NSLocalizedString("TextoComun_Aviso", comment: ""),
                         mensaje: String(format: NSLocalizedString("LoginViewController_Las credenciales introducidas no son válidas.",
                                                                   comment: ""),
                                         maxNumIntentos - numIntentosConsumidos ))
            
            // maxNumIntentos - numIntentosConsumidos
            defaults.set(numIntentosConsumidos + 1, forKey: numIntentosKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func muestraAviso(titulo:String, mensaje:String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("TextoComun_Aceptar", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

