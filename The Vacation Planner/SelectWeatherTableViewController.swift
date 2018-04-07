//
//  SelectWeatherTableViewController.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 24/03/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import UIKit;

class SelectWeatherTableViewController: UITableViewController {
    @IBOutlet var _tableView: UITableView!
    
    var weathers:[Weather] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        LoadWeathers();
        
        Database.weather.removeAll(keepingCapacity: true)
        
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
        return self.weathers.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = self.weathers[indexPath.row].name;
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Database.weather.append(weathers[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = Database.weather.index(where: {$0.id == weathers[indexPath.row].id}) {
            Database.weather.remove(at: index)
        }
    }
    
    func LoadWeathers() {
        let url = URL(string: "http://localhost:8882/weather/")
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let data = data {
                guard let weathers = try? JSONDecoder().decode([Weather].self, from: data) else {
                    print("Error: Couldn't decode data into Weather")
                    return
                }
                
                self.weathers = weathers
                
                DispatchQueue.main.async {
                    self._tableView.reloadData()
                }
            }
        }.resume()
    }
}
