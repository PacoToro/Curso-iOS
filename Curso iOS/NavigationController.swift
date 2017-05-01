//
//  NavigationController.swift
//  SwiftSideMenu
//
//  Created by Paco Toro
//  Copyright (c) 2014 Paco Toro. All rights reserved.
//

import UIKit
import ENSwiftSideMenu

class NavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {

    var tableView:MenuLateralTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = MenuLateralTableViewController(style: UITableViewStyle.grouped)
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: tableView!, menuPosition:.left)
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 250.0 // optional, default is 160
        //sideMenu?.bouncingEnabled = false
        //sideMenu?.allowPanGesture = false
        // make navigation bar showing over side menu
        view.bringSubview(toFront: navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
        self.tableView?.tableView.reloadData()
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
