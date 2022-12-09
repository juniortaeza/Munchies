//
//  CardsViewController.swift
//  munchies
//
//  Created by junior taeza on 12/5/22.
//

import UIKit
import Kingfisher
import Contacts
import ContactsUI

class CardsViewController: UIViewController {
    
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    var currentIndex : Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orangeView.layer.borderWidth = 0.75
        orangeView.layer.borderColor = UIColor.black.cgColor
        orangeView.layer.cornerRadius = 5.0
        
        whiteView.layer.borderWidth = 0.75
        whiteView.layer.borderColor = UIColor.black.cgColor
        whiteView.layer.cornerRadius = 5.0
        
        imageView.contentMode = .scaleToFill
        
        directionsButton.layer.borderWidth = 0.75
        directionsButton.layer.borderColor = UIColor.black.cgColor
        directionsButton.layer.cornerRadius = 5.0
        
        callButton.layer.borderWidth = 0.75
        callButton.layer.borderColor = UIColor.black.cgColor
        callButton.layer.cornerRadius = 5.0
    
        RestaurantsModel.shared.RESTAURANT_ARRAY = []
        loadCards()
    }
    
    // this function calls Spoonacular API and loads the cards in this frame
    func loadCards() {
        RestaurantsModel.shared.getRestaurants { _ in
            DispatchQueue.main.async {
                if RestaurantsModel.shared.RESTAURANT_ARRAY.count == 0 {
                    let ac = Utility.utility.alert(message: "Could not find any suggestions.. Sorry!")
                    self.present(ac, animated: true)
                } else {
                    // present initial card
                    let rc = self.randomCard()
                    self.restaurantNameLabel.text = rc?.name
                    if (rc?.food_photos)!.count > 0 {
                        let foodPhotoUrl = rc?.food_photos![0]
                        self.imageView.kf.setImage(with: URL(string: foodPhotoUrl!)!)
                        
                        CurrentRestaurant.cr.name = (rc?.name)!
                        if rc?.phone_number != nil {
                            CurrentRestaurant.cr.phone_number = String((rc?.phone_number)!)
                        }
                        CurrentRestaurant.cr.lat = (rc?.address?.lat)!
                        CurrentRestaurant.cr.lon = (rc?.address?.lon)!
                    }
                    
                    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.viewDidSwipeLeft(_:)))
                    swipeLeft.direction = .left
                    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.viewDidSwipeRight(_:)))
                    swipeRight.direction = .right
                    
                    self.orangeView.addGestureRecognizer(swipeLeft)
                    self.orangeView.addGestureRecognizer(swipeRight)
                }
            }
        }
    }
    
    // this function allows the user to call the restaurant or save them as contact
    @IBAction func callSaveButtonDidTapped(_ sender: UIButton) {
        if CurrentRestaurant.cr.phone_number.count == 0 {
            let ac = Utility.utility.alert(message: "This restaurant has no phone number recorded.")
            self.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Call / Save", message: "Choose an option", preferredStyle: .actionSheet)
            
            let callNumberAction = UIAlertAction(title: "Call", style: .default) { _ in
                self.callNumber()
            }
            
            let saveContactAction = UIAlertAction(title: "Save Contact", style: .default) { _ in
                self.saveContact()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            ac.addAction(callNumberAction)
            ac.addAction(saveContactAction)
            ac.addAction(cancelAction)
            
            self.present(ac, animated: true)
        }
    }
    
    // this navigates the user to the map view controller, showing route to restaurant
    @IBAction func directionsButtonDidTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "DirectionsSegue", sender: nil)
    }
    
    // transform left, get next card, move back
    @objc func viewDidSwipeLeft(_ tap: UITapGestureRecognizer){
        let leftAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: transformLeft)
        leftAnimator.addCompletion { (position) in
            
            let rc = self.nextCard()
            self.restaurantNameLabel.text = rc?.name
            if let fp = rc?.food_photos {
                if fp.count > 0 {
                    let foodPhotoUrl = fp[0]
                    self.imageView.kf.setImage(with: URL(string: foodPhotoUrl)!)
                    
                    CurrentRestaurant.cr.name = (rc?.name)!
                    if rc?.phone_number != nil {
                        CurrentRestaurant.cr.phone_number = String((rc?.phone_number)!)
                    }
                    CurrentRestaurant.cr.lat = (rc?.address?.lat)!
                    CurrentRestaurant.cr.lon = (rc?.address?.lon)!
                }
            }
            
            self.orangeView.transform = CGAffineTransform(translationX: 500, y: 0)
            let rightAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {() in self.moveBack()})
            rightAnimator.startAnimation()
        }
        leftAnimator.startAnimation()
    }
    
    // transform right, get next card, move back
    @objc func viewDidSwipeRight(_ tap: UITapGestureRecognizer){
        let rightAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: transformRight)
        rightAnimator.addCompletion { (position) in
            
            let rc = self.prevCard()
            self.restaurantNameLabel.text = rc?.name
            if let fp = rc?.food_photos {
                if fp.count > 0 {
                    let foodPhotoUrl = fp[0]
                    self.imageView.kf.setImage(with: URL(string: foodPhotoUrl)!)
                    
                    CurrentRestaurant.cr.name = (rc?.name)!
                    if rc?.phone_number != nil {
                        CurrentRestaurant.cr.phone_number = String((rc?.phone_number)!)
                    }
                    CurrentRestaurant.cr.lat = (rc?.address?.lat)!
                    CurrentRestaurant.cr.lon = (rc?.address?.lon)!
                }
            }
            
            self.orangeView.transform = CGAffineTransform(translationX: -500, y: 0)
            let leftAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {() in self.moveBack()})
            leftAnimator.startAnimation()
        }
        rightAnimator.startAnimation()
    }
    
    // helper functions for card animation
    func transformUp(){
        self.view.transform = CGAffineTransform(translationX: 0, y: -1000)
    }
    
    func transformLeft(){
        self.orangeView.transform = CGAffineTransform(translationX: -500, y: 0)
    }
    
    func transformRight(){
        self.orangeView.transform = CGAffineTransform(translationX: 500, y: 0)
    }
    
    func moveBack(){
        self.orangeView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func numberOfCards() -> Int {
        return RestaurantsModel.shared.RESTAURANT_ARRAY.count
    }
    
    func randomCard() -> Restaurant? {
        if self.currentIndex != nil {
            if self.numberOfCards() == 1 {
                return RestaurantsModel.shared.RESTAURANT_ARRAY[0]
            }
            var rand = self.currentIndex
            while rand == self.currentIndex {
                rand = Int.random(in: 0..<self.numberOfCards())
                if(rand != self.currentIndex) {
                    break
                }
            }
            self.currentIndex = rand
            return RestaurantsModel.shared.RESTAURANT_ARRAY[self.currentIndex!]
        }
        return nil
    }
    
    func nextCard() -> Restaurant? {
        if self.currentIndex != nil {
            let newIndex = self.currentIndex! + 1
            if newIndex >= self.numberOfCards() {
                self.currentIndex = 0
                return RestaurantsModel.shared.RESTAURANT_ARRAY[self.currentIndex!]
            } else {
                self.currentIndex = newIndex
                return RestaurantsModel.shared.RESTAURANT_ARRAY[self.currentIndex!]
            }
        }
        return nil
    }
    
    func prevCard() -> Restaurant? {
        if self.currentIndex != nil {
            let newIndex = self.currentIndex! - 1
            if newIndex < 0 {
                self.currentIndex = self.numberOfCards() - 1
                return RestaurantsModel.shared.RESTAURANT_ARRAY[self.currentIndex!]
            } else {
                self.currentIndex = newIndex
                return RestaurantsModel.shared.RESTAURANT_ARRAY[self.currentIndex!]
            }
        }
        return nil
    }
    
    func callNumber() {
        guard let callURL = URL(string: "tel://\(CurrentRestaurant.cr.phone_number)") else {
            return
        }
        
        let application:UIApplication = UIApplication.shared
        if application.canOpenURL(callURL) {
            application.open(callURL, options: [:], completionHandler: nil)
        }
    }
    
    func saveContact() {
        let contact = CNMutableContact()
        
        let image = UIImage(systemName: "person.crop.circle")
        contact.imageData = image?.jpegData(compressionQuality: 1.0)
        contact.givenName = CurrentRestaurant.cr.name
        contact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberMobile,
            value: CNPhoneNumber(stringValue: CurrentRestaurant.cr.phone_number))]

        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)

        do {
            try store.execute(saveRequest)
            let ac = Utility.utility.alert(message: "Saved to contacts.")
            self.present(ac, animated: true)
        } catch {
            print("Error saving contact: \(error)")
        }
    }
}
