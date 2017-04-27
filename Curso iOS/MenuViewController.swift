//
//  MenuViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 12/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController, LoginDelegate {
   
    typealias tipoMenu = [Dictionary<String, Any>]
    
    var menuArray: tipoMenu = []
    let sufijoIdima = "_" + Utils.idioma()
    
    @IBOutlet weak var btnDesconectar: UIBarButtonItem!
    
    override func viewDidLoad() {
        if menuArray.count == 0, let fileUrl = Bundle.main.url(forResource: "Menu", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: fileUrl)
                menuArray = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [[String: Any]]
            } catch {
                print("ERROR: No se ha podido leer adecuadamente el fichero Menu.plist")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        btnDesconectar.isEnabled = defaults.string(forKey: "token") != nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let opcion = menuArray[indexPath.row]
        
        cell.lblTitulo.text =  opcion["titulo" + sufijoIdima] as? String
        cell.lblSubtitulo.text =  opcion["subtitulo" + sufijoIdima] as? String
        if let imageName = opcion["imagen"] {
            cell.imgIcono.image = UIImage (named: imageName as! String)
        }
        
        if let tipo = opcion["tipo"] as? String, tipo == "menu" {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
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
            case "menu":
                let submenu = opcion["menu"] as! tipoMenu
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                controller.menuArray = submenu
                controller.title = opcion["titulo" + sufijoIdima] as? String
                navigationController?.pushViewController(controller, animated: true)
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
            case "operación":
                if  let segue = opcion["segue"] as? String {
                    performSegue(withIdentifier: segue, sender: self)
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
        controller.modalPresentationStyle = UIModalPresentationStyle.formSheet
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
        
        btnDesconectar.isEnabled = estaAutenticado
    }
    
    @IBAction func desconectar(_ sender: Any) {
        btnDesconectar.isEnabled = false
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "token")
        navigationController?.popToRootViewController(animated: true)
    }
}
