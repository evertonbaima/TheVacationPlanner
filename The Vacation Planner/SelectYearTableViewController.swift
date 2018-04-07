//
//  SelectYearTableViewController.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 24/03/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import UIKit;

class SelectYearTableViewController: UITableViewController {
    @IBOutlet var _tableView: UITableView!
    
    var years:[String] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        LoadYears();
        
        self._tableView.delegate = self;
        self._tableView.dataSource = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.years.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = self.years[indexPath.row];
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Database.year = years[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
    
    func LoadYears() {
        years = ["2018", "2017", "2016", "2015", "2014"]
    }
}


