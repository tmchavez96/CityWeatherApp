//
//  MapViewController.swift
//  City2City-J22
//
//  Created by mac on 1/30/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    
    @IBOutlet weak var weatherFeelsLike: UILabel!
    
    @IBOutlet weak var weatherWindSpeeds: UILabel!
    
    //dependency injection - giving an object its dependencies from the outside
    var city: City!
    var cityWeather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        getWeather()
        setUpNav()
    }
    
    private func setupMap() {
        //focus area of map
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude), latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.region = region
        
        //place pin on map
        let annote = MKPointAnnotation()
        annote.coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        annote.title = "\(city.name), \(city.state)"
        annote.subtitle = "You Are Here"
        mapView.addAnnotation(annote)
    }
 
    private func setUpNav(){
        let seeWeather = UIBarButtonItem(title: "See \(city.name) Weather", style: .plain, target: self, action: #selector(seeWeath))
        navigationItem.rightBarButtonItems = [seeWeather]
    }
    
    //i guess bar buttons have to call objective c
    @objc func seeWeath(){
        //go back to swift asap
        setUIWeatherVals()
    }
    func setUIWeatherVals(){
        weatherDescription.text = cityWeather?.description
        weatherDescription.layer.zPosition = 2;
        weatherTemp.text = "Temp: \(cityWeather?.temp ?? 0)"
        weatherTemp.layer.zPosition = 3;
        weatherFeelsLike.text = "Feels Like:  \(cityWeather?.feelsLike ?? 0)"
        weatherFeelsLike.layer.zPosition = 4;
        weatherWindSpeeds.text = "Wind Speeds: \(cityWeather?.windSpeed ?? 0)"
        weatherWindSpeeds.layer.zPosition  = 5;
    }
    
    private func getWeather() {
        WeatherManager.shared.getWeather(for: city) { wthr in
            if let weather = wthr {
                self.cityWeather = weather
                print("Weather For \(self.city.name), \(self.city.state): \(weather.description)")
            }
        }
    }

}
