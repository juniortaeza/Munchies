//
//  TravelBudgetViewController.swift
//  munchies
//
//  Created by junior taeza on 12/4/22.
//

import UIKit

class TravelBudgetViewController: UIViewController {
    
    @IBOutlet weak var travelDistanceSlider: UISlider!
    @IBOutlet weak var travelDistanceLabel: UILabel!
    @IBOutlet weak var budgetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        budgetTextField.layer.borderColor = UIColor.orange.cgColor
        budgetTextField.layer.borderWidth = 0.75
        budgetTextField.layer.cornerRadius = 5.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // functions to dismiss keyboard on background tap and 'done' button pressed
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func budgetDismissKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func travelDistanceSliderAction(_ sender: UISlider) {
        let roundedDistance = Int((sender.value) + 0.5)
        travelDistanceLabel.text = "\(roundedDistance)"
    }
    
    // records user's entries and navigates to generated cards
    @IBAction func submitButton(_ sender: UIButton) {
        guard let distance = travelDistanceLabel.text,
              let budget = budgetTextField.text else {
            return
        }
        
        if distance.count == 0 || budget.count == 0 {
            let ac = Utility.utility.alert(message: "Cannot leave fields blank.")
            self.present(ac, animated: true)
        } else {
            User.user.distance = Int(distance)!
            User.user.budget = Int((Double(budget)! + 0.5))
            
            let information = [
                "selection" : User.user.selection,
                "distance" : User.user.distance,
                "budget" : User.user.budget
            ] as [String : Any]
            
            let res = Utility.utility.writeSelections(uid: User.user.uid, info: information)
            if res.count == 0 {
                self.performSegue(withIdentifier: "TBToCardsSegue", sender: nil)
            } else {
                let ac = Utility.utility.alert(message: "An error has occurred.")
                self.present(ac, animated: true)
            }
        }
    }
}
