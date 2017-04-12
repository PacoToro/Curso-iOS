//
//  MenuPrincipalViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 12/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit

class MenuPrincipalViewController: UITableViewController {
   var menuArray: [Dictionary<String, String>] = []
    
    override func viewDidLoad() {
        if let fileUrl = Bundle.main.url(forResource: "Menu", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: fileUrl)
                menuArray = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [[String: String]]
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
        
        cell.lblTitulo.text =  opcion["titulo" + sufijoIdima]
        cell.lblSubtitulo.text =  opcion["subtitulo" + sufijoIdima]
        cell.imgIcono.image = UIImage (named: opcion["imagen"]!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let opcion = menuArray[indexPath.row]
        
        if let tipo = opcion["tipo"] {
            switch tipo {
            case "web":
                let sufijoIdima = "_" + Utils.idioma()
                let urlIdioma = opcion["url" + sufijoIdima]
                performSegue(withIdentifier: "abrirNavegadorSegue", sender: urlIdioma)
            case "app":
                if  let nombreApp = opcion["nombreApp"],
                    let urlScheme = opcion["urlScheme"],
                    let urlStore = opcion["urlStore"] {
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
    

    
}
