//
//  OficinasCarjerosTabViewController.swift
//  Curso iOS
//
//  Created by Paco Toro on 20/4/17.
//  Copyright © 2017 Unicaja. All rights reserved.
//

import Foundation
import UIKit

class OficinasCajerosTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewController: OficinasCajerosViewController

        viewController = viewControllers?[0] as! OficinasCajerosViewController
        viewController.tipoPOI = tiposPOI.Oficina
        
        viewController = viewControllers?[1] as! OficinasCajerosViewController
        viewController.tipoPOI = tiposPOI.Cajero
    }
    
}
