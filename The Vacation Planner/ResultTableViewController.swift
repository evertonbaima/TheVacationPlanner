//
//  ResultTableViewController.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 01/04/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    @IBOutlet var _tableView: UITableView!
    
    var results:[String] = []
    var header: String?
    var cityWeathers: [CityWeather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadResults()
        
        self._tableView.delegate = self
        self._tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = self.results[indexPath.row]
        
        return cell
    }
    
    func LoadResults() {
        let url = URL(string: "http://localhost:8882/cities/\(Database.city?.woeid ?? "")/year/\(Database.year ?? "")")
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let data = data {
                guard let cityWeathers = try? JSONDecoder().decode([CityWeather].self, from: data) else {
                    print("Error: Couldn't decode data into CityWeather")
                    return
                }
                
                self.cityWeathers = cityWeathers
                
                DispatchQueue.main.async {
                    self.calculateResults()
                }
            }
        }.resume()
    }
    
    //https://iswift.org/playground?TVwKoV&v=3
    func calculateResults() {
        var countWeatherMatch = 0;
        let vacationDays = Int(Database.vacationDays!)!;
        var chosenCityWeather: [CityWeather] = []
        
        for i in stride(from: 0, to: self.cityWeathers.count, by: 1) {
            let cityWeather = self.cityWeathers[i]
            
            if(isWeatherChosen(weather:cityWeather.weather)) {
                countWeatherMatch += 1
                
                if(i == (self.cityWeathers.count - 1)) {
                    if(countWeatherMatch >= vacationDays) {
                        let j = i + 1
                        let firstCW = self.cityWeathers[j - countWeatherMatch]
                        let lastCW = self.cityWeathers[j - 1]
                        
                        chosenCityWeather.append(firstCW)
                        chosenCityWeather.append(lastCW)
                        
                        break
                    }
                }
            } else {
                if(countWeatherMatch >= vacationDays) {
                    let firstCW = self.cityWeathers[i - countWeatherMatch]
                    let lastCW = self.cityWeathers[i - 1]
                    
                    chosenCityWeather.append(firstCW)
                    chosenCityWeather.append(lastCW)
                }
                
                countWeatherMatch = 0;
            }
        }
        
        if(chosenCityWeather.count > 0) {
            header = "Para a cidade \(Database.city!.district), existem \(chosenCityWeather.count / 2) combinações para o ano de \(Database.year!):"
        } else {
            header = "Não existem combinações."
        }
        
        for i in stride(from: 0, to: chosenCityWeather.count, by: 2) {
            self.results.append("De \(dateFormat(chosenCityWeather[i].date)) a \(dateFormat(chosenCityWeather[i+1].date))")
        }
        
        self._tableView.reloadData()
    }
    
    func isWeatherChosen(weather: String) -> Bool {
        for cw in Database.weather.map({ (weather) -> String in weather.name }) {
            if(cw == weather) { return true }
        }
        
        return false
    }
    
    func dateFormat(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "pt_BR")
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd 'de' MMMM"
        
        if let dObj = dateObj {
            return dateFormatter.string(from: dObj)
        } else {
            return "Error: the input must be similar to '2018-04-07'"
        }
    }
}
