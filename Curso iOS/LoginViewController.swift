//
//  LoginViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 11/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit
import LocalAuthentication

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
            realizaLogin(nif: txtIdentificador.text!, clave: txtContraseña.text!)
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
        DispatchQueue.main.async {
            let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("TextoComun_Aceptar", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
        
        solicitarReconocimientoDeHuella()
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
    
    func solicitarReconocimientoDeHuella() {
        let defaults = UserDefaults.standard
        if true // defaults(forKey: "TOUCHID") as! Bool == true
        {
            // 1. Create a authentication context
            let authenticationContext = LAContext()
            var error:NSError?
            
            // 2. Check if the device has a fingerprint sensor
            // If not, show the user an alert view and bail out!
            guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                
                showAlertViewIfNoBiometricSensorHasBeenDetected()
                return
                
            }
            
            // 3. Check the fingerprint
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Debe autentificarse para acceder a este servicio.",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if( success ) {
                        self.realizaLogin(nif: "11111111H", clave: nil)
                    }else {
                        
                        // Check if there is an error
                        if let error = error {
                            
                            let message = self.errorMessageForLAErrorCode(error._code)
                            if (!(LAError.Code.userCancel.rawValue == error._code) && !(LAError.Code.userFallback.rawValue == error._code) && !(LAError.Code.systemCancel.rawValue == error._code)){
                                self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                            }
                        }
                    }
            })
        }
    }
    
    func errorMessageForLAErrorCode( _ errorCode:Int ) -> String{
        
        var message = ""
        
        
        if #available(iOS 9.0, *) {
            switch errorCode {
                
            case LAError.Code.appCancel.rawValue:
                message = "Authentication was cancelled by application"
                
            case LAError.Code.authenticationFailed.rawValue:
                message = "El usuario no pudo proporcionar credenciales válidas."
                
            case LAError.Code.invalidContext.rawValue:
                message = "The context is invalid"
                
            case LAError.Code.passcodeNotSet.rawValue:
                message = "Passcode is not set on the device"
                
            case LAError.Code.systemCancel.rawValue:
                message = "Authentication was cancelled by the system"
                
            case LAError.Code.touchIDLockout.rawValue:
                message = "Demasiados intentos fallidos."
                
            case LAError.Code.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.Code.userCancel.rawValue:
                message = "The user did cancel"
                
            case LAError.Code.userFallback.rawValue:
                message = "The user chose to use the fallback"
                
            default:
                message = "Did not find error code on LAError object"
                
                
            }
        } else {
            message = "Error indeterminado"
        }
        
        return message
        
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( _ message:String ){
        
        showAlertWithTitle("Error", message: message)
        
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle("Error", message: "Este dispositivo no dispone de TouchID.")
        
    }
    
    func showAlertWithTitle( _ title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    func realizaLogin(nif:String, clave:String?) {
        guard Utils.isInternetAvailable() else {
            print("No se ha podido intentar el login porque no hay acceso a Internet")
            self.muestraAviso(titulo: NSLocalizedString("TextoComun_Aviso", comment: ""),
                              mensaje: NSLocalizedString("TextoComun_En estos momentos no hay acceso a Internet.", comment: ""))
            return
        }
        
        let url:URL?
        if clave != nil {
            url = URL(string: "http://\(Utils.endPoint())/login?nif=\(nif)&clave=\(clave!)")
        } else {
            url = URL(string: "http://\(Utils.endPoint())/login?nif=\(nif)&respuestaDesafio=DBpzB4FDhJS045Dfgs")
        }
        
        if let url = url  {
            
            print("URL de Login = \(url)")
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
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
                    
                    let defaults = UserDefaults.standard
                    let numIntentosConsumidos = defaults.integer(forKey:self.numIntentosKey)
                    if respuesta["resultado"] as! Bool {
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

