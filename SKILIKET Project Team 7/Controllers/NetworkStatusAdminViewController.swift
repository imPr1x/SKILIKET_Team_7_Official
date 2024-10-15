//
//  networkStatusAdminViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 14/10/24.
//

import UIKit

class networkStatusAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Asignar delegado y fuente de datos
        tableView.delegate = self
        tableView.dataSource = self

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
