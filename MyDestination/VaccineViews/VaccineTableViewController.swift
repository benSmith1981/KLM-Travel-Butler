//
//  VaccineTableViewController.swift
//  
//
//  Created by Michiel Everts on 05-12-17.
//

import UIKit
import SVProgressHUD

class VaccineTableViewController: UITableViewController {
    
    var dataObjects: [VaccineData] = []
    var selected: VaccineData?
    var isThereSomethingInVisa = true
    var isThereSomethingInVaccine = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageInNav()
        SVProgressHUD.dismiss()
        let vaccineNib = UINib(nibName: "VaccineTableViewCell", bundle: nil)
        self.tableView.register(vaccineNib, forCellReuseIdentifier: "VaccineCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataObjects.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "VaccineCell", for: indexPath) as! VaccineTableViewCell
        let currentVaccineinfo = dataObjects[indexPath.row]
        
        cell.setup(currentVaccineInfo: currentVaccineinfo)
        
        return cell
    }
}








