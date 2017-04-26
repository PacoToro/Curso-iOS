//
//  ContactoCell.swift
//  Curso iOS
//
//  Created by Paco Toro on 18/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit

protocol ContactoDelegate: class {
    func enviarCorreo(mail:String)
}

class ContactoCell: UICollectionViewCell {
    
    var delegate:ContactoDelegate?
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var btnTelefono: UIButton!
    @IBOutlet weak var btnCorreo: UIButton!
    
    @IBAction func telefonear(_ sender: Any) {
        var telefono = btnTelefono.titleLabel!.text!.replacingOccurrences(of: "-", with: "")
        telefono = telefono.replacingOccurrences(of: " ", with: "")
        
        if let url = URL(string: "telprompt://" + telefono) {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func enviarCorreo(_ sender: Any) {
        var correo = btnCorreo.titleLabel!.text!.replacingOccurrences(of: "-", with: "")
        correo = correo.replacingOccurrences(of: " ", with: "")
        delegate?.enviarCorreo(mail: correo)        
    }
}
