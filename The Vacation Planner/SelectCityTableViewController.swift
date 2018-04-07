//
//  SelectCityTableViewController.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 24/03/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import UIKit;

class SelectCityTableViewController: UITableViewController {
    @IBOutlet var _tableView: UITableView!
    
    var cities:[City] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        LoadCities();
        
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
        return self.cities.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = self.cities[indexPath.row].district;
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Database.city = cities[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
    
    func LoadCities() {
        let url = URL(string: "http://localhost:8882/cities/")
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let data = data {
                guard let cities = try? JSONDecoder().decode([City].self, from: data) else {
                    print("Error: Couldn't decode data into City")
                    return
                }
                
                self.cities = cities
                
                DispatchQueue.main.async {
                    self._tableView.reloadData()
                }
            }
        }.resume()
    }
}
