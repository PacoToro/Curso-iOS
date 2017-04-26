//
//  ContactoViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 18/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit
import MessageUI

class ContactoViewController: UICollectionViewController, ContactoDelegate, MFMailComposeViewControllerDelegate  {
    
    public struct contacto {
        var titulo: String
        var telefono: String
        var correo: String
    }
    
    var datosContacto:[contacto] = [contacto(titulo: NSLocalizedString("ContactoViewController_Atención al cliente", comment: ""),
                                             telefono: " 945-654-284", correo: " acliente@ingenia.es"),
                                    contacto(titulo: NSLocalizedString("ContactoViewController_Servicion técnico", comment: ""),
                                             telefono: " 945-7456-351", correo: " stecnico@ingenia.es"),
                                    contacto(titulo: NSLocalizedString("ContactoViewController_Reclamaciones", comment: ""),
                                             telefono: " 945-345-824", correo: " reclamaciones@ingenia.es"),
                                    contacto(titulo: NSLocalizedString("ContactoViewController_Devoluciones", comment: ""),
                                             telefono: " 945-672-765", correo: " devoluciones@ingenia.es"),
                                    contacto(titulo: NSLocalizedString("ContactoViewController_Nuevos clientes", comment: ""),
                                             telefono: " 945-833-755", correo: " newclientes@ingenia.es"),
                                    contacto(titulo: NSLocalizedString("ContactoViewController_Recursos Humanos", comment: ""),
                                             telefono: " 945-098-443", correo: " rrhh@ingenia.es"),
                                    contacto(titulo: NSLocalizedString("ContactoViewController_Ofertas de empleo", comment: ""),
                                             telefono: " 945-462-732", correo: " empleo@ingenia.es"),
                                    contacto(titulo: NSLocalizedString("ContactoViewController_Denuncias", comment: ""),
                                             telefono: " 945-845-847", correo: " denuncias@ingenia.es"),
                                    ]
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datosContacto.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactoCell", for: indexPath) as! ContactoCell
        let contacto = datosContacto[indexPath.row]
        
        cell.lblTitulo.text = contacto.titulo
        cell.btnTelefono.setTitle(contacto.telefono, for: UIControlState.normal)
        cell.btnCorreo.setTitle(contacto.correo, for: UIControlState.normal)
        cell.delegate = self
                
        return cell
    }
    
    func enviarCorreo(mail: String) {
        let mailComposeViewController = configuredMailComposeViewController(mail: mail)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            muestraAviso(titulo: NSLocalizedString("TextoComun_Error", comment: ""), mensaje: NSLocalizedString("ContactoViewController_No es posible enviar correos en este momento. Configure una cuenta y vuelva a intentarlo.", comment: ""))
        }
    }
    
    func configuredMailComposeViewController(mail: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([mail])
        mailComposerVC.setSubject(NSLocalizedString("ContactoViewController_Consulta desde la App", comment: ""))
        mailComposerVC.setMessageBody(NSLocalizedString("ContactoViewController_Hola, tengo la siguiente consulta: ...", comment: ""), isHTML: false)
        
        return mailComposerVC
    }
    
    func muestraAviso(titulo:String, mensaje:String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("TextoComun_Aceptar", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

