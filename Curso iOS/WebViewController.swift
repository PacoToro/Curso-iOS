//
//  WebViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 12/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var urlString:String = ""
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func cerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        if urlString.characters.count > 0 {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
        } else {
            cerrar(self)
        }
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.isHidden = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        spinner.isHidden = true
        let titulo = NSLocalizedString("TextoComun_Error", comment: "")
        let mensaje = NSLocalizedString("WebViewController_Se ha producido un error al cargar la página.", comment: "")
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("TextoComun_Aceptar", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
