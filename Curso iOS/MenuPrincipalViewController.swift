//
//  MenuPrincipalViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 12/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit

class MenuPrincipalViewController: UITableViewController, LoginDelegate {
   var menuArray: [Dictionary<String, Any>] = []
    
    override func viewDidLoad() {
        if let fileUrl = Bundle.main.url(forResource: "Menu", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: fileUrl)
                menuArray = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [[String: Any]]
            } catch {
                print("ERROR: No se ha podido leer adecuadamente el fichero Menu.plist")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let opcion = menuArray[indexPath.row]
        let sufijoIdima = "_" + Utils.idioma()
        
        cell.lblTitulo.text =  opcion["titulo" + sufijoIdima] as? String
        cell.lblSubtitulo.text =  opcion["subtitulo" + sufijoIdima] as? String
        cell.imgIcono.image = UIImage (named: opcion["imagen"] as! String)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let opcion = menuArray[indexPath.row]
        
        if let requiereAutenticacion = opcion["autenticado"] as? Bool {
            if requiereAutenticacion && !estaUsuarioAutenticado(){
                solicitarLogin()
                return
            }
        }
        
        if let tipo = opcion["tipo"] as? String {
            switch tipo {
            case "web":
                let sufijoIdima = "_" + Utils.idioma()
                let urlIdioma = opcion["url" + sufijoIdima]
                performSegue(withIdentifier: "abrirNavegadorSegue", sender: urlIdioma)
            case "app":
                if  let nombreApp = opcion["nombreApp"] as? String,
                    let urlScheme = opcion["urlScheme"] as? String,
                    let urlStore = opcion["urlStore"] as? String {
                    Utils.abrirApp(nombre: nombreApp, urlScheme: urlScheme, urlStore: urlStore, sender: self)
                }
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "abrirNavegadorSegue":
            let webVC = segue.destination as! WebViewController
            webVC.urlString = sender as! String
        default:
            break
        }
    }
    
    func estaUsuarioAutenticado() -> Bool{
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token")
        return token != nil
    }
    
    func solicitarLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: - LoginDelegate
    func usuarioAutenticado(estaAutenticado:Bool) {
        self.dismiss(animated: true, completion: nil)
        if estaAutenticado {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView(tableView, didSelectRowAt: indexPath)
            }
        }
    }
    
}
