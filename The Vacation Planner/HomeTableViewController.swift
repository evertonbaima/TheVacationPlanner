//
//  HomeTableViewController.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 24/03/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    @IBOutlet var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTable()
    }
    
    @IBAction func clearDatabase(_ sender: Any) {
        Database.vacationDays = nil
        Database.city = nil
        Database.weather.removeAll()
        Database.year = nil
        
        loadTable()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "results") {
            if (Database.vacationDays == nil || (Database.vacationDays?.isEmpty)! || Int(Database.vacationDays!)! <= 0  || Database.city == nil || Database.weather.isEmpty || Database.year == nil) {
                showAlert()
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            showInputDialog()
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        loadTable()
    }
    
    func loadTable() {
        if let vacationDays = Database.vacationDays {
            let intDays = Int(vacationDays)!
            
            if (intDays == 0) {
                _tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = ""
            } else if (intDays == 1) {
                _tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = "\(vacationDays) day"
            } else {
                _tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = "\(vacationDays) days"
            }
        } else {
            _tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = ""
        }
        
        _tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = Database.city?.district
        _tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.text = Database.weather.map{$0.name}.joined(separator: ", ")
        _tableView.cellForRow(at: IndexPath(row: 3, section: 0))?.detailTextLabel?.text = Database.year
        
        self._tableView.reloadData()
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "All data must be filled.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            return
        }
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showInputDialog() {
        let alertController = UIAlertController(title: "Vacation days", message: "How many vacation days do you have?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            Database.vacationDays = alertController.textFields?[0].text
            self.loadTable()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = ""
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
