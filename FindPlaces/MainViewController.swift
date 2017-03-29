//
//  MainViewController.swift
//  FindPlaces
//
//  Created by Alex on 3/28/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import Kingfisher

private let reuseIdentifier = "cellReuseID"
private let segueIdentifier = "mainToDetailSegue"

class MainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var placesArray: Array<AnyObject> = []
    var keyWord = ""
    let locationManager = CLLocationManager()
    var searchController: UISearchController?
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Find Places"
        
        /* Remove extra separators */
        self.tableView.tableFooterView = UIView()
        
        /* Setting up SearchController */
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width + 8, height: 44.0)
        self.searchController?.searchBar.delegate = self;
        self.tableView.tableHeaderView = self.searchController?.searchBar;
        self.definesPresentationContext = true
        self.searchController?.searchBar.placeholder = "Search (e.g. sushi, breakfast, italian)"

        self.reloadResults()
        
        /* Pull to refresh */
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MainViewController.reloadResults), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    func reloadResults() {
        self.refreshControl?.endRefreshing()
        self.placesArray.removeAll()
        self.tableView?.reloadData()
        self.getUserLocation()
    }

    func getUserLocation() {
        //        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            SVProgressHUD.show(withStatus: "Loading Places")
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func findPlaces(lat: Double, lon: Double, keyWord: String) {
        let networkManager = NetworkManager()
        networkManager.getGooglePlaces(keyWord: keyWord, lat: lat, lon: lon) { (placesArray, statusCode) in
            if statusCode == 200 {
                SVProgressHUD.showSuccess(withStatus: "Places Loaded")
                self.placesArray = placesArray!
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            } else {
                let errorHelper = ErrorHelper()
                SVProgressHUD.showError(withStatus: errorHelper.getErrorMessage(statusCode: statusCode!))
            }
        }
    }
    
    // MARK: - locationManager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let coordinate:CLLocationCoordinate2D = manager.location!.coordinate
        print(coordinate)
        self.findPlaces(lat: coordinate.latitude, lon: coordinate.longitude, keyWord: self.keyWord)
        //        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:

            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()

        case .restricted, .denied:
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "Please enable location services")
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PlaceTableViewCell
        
//        let number : Int = theNumbers[indexPath.row]
        let place = self.placesArray[indexPath.row] as! Place
        cell.nameLabel?.text = place.name
        cell.distanceLabel?.text = place.openNow
        let imageURL = URL(string: (place.icon)!)
        cell.iconImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell: PlaceTableViewCell = cell as! PlaceTableViewCell
        
        let place = self.placesArray[indexPath.row] as! Place
        cell.distanceLabel?.text = place.formatedDistanceFrom(cooridnate: self.locationManager.location!.coordinate)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let place = placesArray[indexPath.row]
        self.performSegue(withIdentifier: segueIdentifier, sender: place)

        
    }
    
    // MARK: - Search Controller delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.keyWord = searchText
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.scrollRectToVisible(CGRect.zero, animated: false)
        searchBar.text = self.keyWord
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.reloadResults()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.reloadResults()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let place = sender as? Place {
            let dv = segue.destination as? DetailViewController
            dv?.place = place
            let imageURL = URL(string: (place.icon)!)
            dv?.imageView.kf.setImage(with: imageURL)
        }
    }

}
