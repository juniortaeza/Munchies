//
//  CravingViewController.swift
//  munchies
//
//  Created by junior taeza on 12/4/22.
//

import UIKit
import CoreLocation

class CravingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var selected_cuisine : String = ""
    
    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve user's location in lat and lon
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
        
        let information = [
            "email" : User.user.email,
            "password" : User.user.password
        ]
        
        let res = Utility.utility.writeEmailPassword(uid: User.user.uid, info: information)
        if res.count != 0 {
            let ac = Utility.utility.alert(message: "An error has occurred.")
            self.present(ac, animated: true)
        }
        
        tableView.reloadData()
    }
    
    // obtain the user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else {
            return
        }
        
        User.user.latitude = location.latitude
        User.user.longitude = location.longitude
    }
    
    // implement delegate and datasource protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantsModel.shared.CUISINES.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CuisineCell", for: indexPath) as! TableViewCell
        let cuisine = RestaurantsModel.shared.CUISINES[indexPath.row]
        cell.textLabel?.text = cuisine
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cuisine = cell?.textLabel?.text
        selected_cuisine = cuisine!
    }
    
    // records user's selection and navigates to next prompt
    @IBAction func submitButton(_ sender: UIButton) {
        if selected_cuisine.count == 0 {
            let ac = Utility.utility.alert(message: "You must select one cuisine.")
            self.present(ac, animated: true)
        } else {
            User.user.selection = selected_cuisine
            
            self.performSegue(withIdentifier: "CravingToTBSegue", sender: nil)
        }
    }
}
