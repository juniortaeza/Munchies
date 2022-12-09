//
//  AccountViewController.swift
//  munchies
//
//  Created by junior taeza on 12/3/22.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // these outlets are necessary in order to set up UI design
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var topBoxView: UIView!
        
    var cell_selected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = User.user.email
        
        topBoxView.layer.borderWidth = 0.75
        topBoxView.layer.borderColor = UIColor.orange.cgColor
        topBoxView.layer.cornerRadius = 5.0
        
        tableView.layer.borderWidth = 0.75
        tableView.layer.borderColor = UIColor.orange.cgColor
        tableView.layer.cornerRadius = 5.0
        
        Utility.utility.user_selections.removeAll()
        Utility.utility.readSelections(uid: User.user.uid) { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // delegate + datasource protocol functions implemented
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utility.utility.user_selections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let selections = Utility.utility.user_selections[indexPath.row]
        cell.textLabel?.text = "\(selections["selection"] ?? "") cui, $\(selections["budget"] ?? "") bdgt, within \(selections["distance"] ?? "") mi"
        return cell
    }
    
    // record selection of which cell is pressed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cell_selected = true
        let selections = Utility.utility.user_selections[indexPath.row]
        
        User.user.selection = selections["selection"] as! String
        User.user.budget = selections["budget"] as! Int
        User.user.distance = selections["distance"] as! Int
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        cell_selected = false
    }
    
    // clear the user's selections and clear from database
    @IBAction func clearButtonDidTapped(_ sender: UIButton) {
        if Utility.utility.user_selections.count == 0 {
            let ac = Utility.utility.alert(message: "Selections is already empty!")
            self.present(ac, animated: true)
        } else {
            Utility.utility.clearSelections(uid: User.user.uid)
            Utility.utility.user_selections.removeAll()
            tableView.reloadData()
        }
    }
    
    // load cards depending on user's selection
    @IBAction func loadCardsButtonDidTapped(_ sender: UIButton) {
        if !cell_selected {
            let ac = Utility.utility.alert(message: "You must choose a selection to load cards with.")
            self.present(ac, animated: true)
        } else {
            if Utility.utility.user_selections.count == 0 {
                let ac = Utility.utility.alert(message: "You have no previous selections to load cards with.")
                self.present(ac, animated: true)
            } else {
                self.performSegue(withIdentifier: "AccountToCardsSegue", sender: nil)
            }
        }
    }
    
    // sign user out of app and redirect back to root view controller
    @IBAction func signOutButtonDidTapped(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
