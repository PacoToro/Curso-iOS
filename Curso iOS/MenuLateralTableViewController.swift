//
//  MenuLateralTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.   
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MenuLateralTableViewController: UITableViewController {
    
    var selectedMenuItem : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("MenuLateralTableViewController_Datos personales", comment: "")

        default:
            return NSLocalizedString("MenuLateralTableViewController_Acerca de ...", comment: "")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CELL")
        }
        
        switch indexPath.section {
        case 0:
            let defaults = UserDefaults.standard
            if let nombre = defaults.string(forKey:"nombre") {
                cell!.textLabel?.text = "Nombre: \(nombre)"
            } else {
                cell!.textLabel?.text = "Nombre: Anónimo"
            }
        default:
            cell!.textLabel?.text = "Copyright Ingenia 2017"
        }
        
        return cell!
    }
    
}
