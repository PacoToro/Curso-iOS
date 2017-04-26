//
//  LoginViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 11/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit

protocol LoginDelegate: class {
    func usuarioAutenticado(estaAutenticado:Bool)
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    var delegate:LoginDelegate?
    let numIntentosKey = "numIntentosDisponibles"
    let maxNumIntentos = 3
    let datosAcceso = (nombre: "Fernando", usuario: "fernan2", contraseña: "invitado")
    
    @IBOutlet weak var txtIdentificador: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        } else {
            guard Utils.isInternetAvailable() else {
                print("No se ha podido intentar el login porque no hay acceso a Internet")
                return
            }
            
            if let url = URL(string: "http://\(Utils.endPoint())/Login.json?usuario=\(txtIdentificador.text!)&clave=\(txtContraseña.text!)") {
            
                print("URL de Login = \(url)")
                
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "GET"  // Cambiar a POST cuando el servicio sea de real
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    guard let data = data else {
                        print("Data is empty")
                        return
                    }
                    
                    do {
                    
                        let respuesta = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                        
                        print(respuesta)
                        
                        if respuesta["responseCode"] as! Int == 0 {
                            defaults.set(0, forKey: self.numIntentosKey)
                            defaults.set(respuesta["token"], forKey: "token")
                            defaults.set(respuesta["userName"], forKey: "nombre")
                            self.delegate?.usuarioAutenticado(estaAutenticado: true)
                        } else {
                            self.muestraAviso(titulo: NSLocalizedString("TextoComun_Aviso", comment: ""),
                                              mensaje: String(format: NSLocalizedString("LoginViewController_Las credenciales introducidas no son válidas.",
                                                                                        comment: ""),
                                                              self.maxNumIntentos - numIntentosConsumidos ))
                            defaults.set(numIntentosConsumidos + 1, forKey: self.numIntentosKey)
                        }
                        
                    } catch {
                        print("Error al procesar el JSON")
                    }
                    
                }
                
                task.resume()
            }
        }
    }
    
    @IBAction func pulsaCancelar(_ sender: Any) {
        delegate?.usuarioAutenticado(estaAutenticado: false)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

