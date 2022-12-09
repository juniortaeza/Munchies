//
//  Utility.swift
//  munchies
//
//  Created by junior taeza on 12/4/22.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Utility {
    public static let utility = Utility()
    let database = Firestore.firestore()
    var selections : [String] = []
    var user_selections : [[String : Any]] = []
    
    func readSelections(uid: String, completion: @escaping ([[String : Any]]) -> Void) {
        let ref = database.collection("munchies").document(uid).collection("selections")
        
        ref.getDocuments { queries, err in
            if let err = err {
                print("Error reading from database: \(err.localizedDescription)")
            } else {
                print("Success reading from database.")
                let documents = queries!.documents
                
                for doc in documents {
                    let user_entries = doc.data()
                    self.user_selections.append(user_entries)
                }
                completion(self.user_selections)
            }
        }
    }
    
    func clearSelections(uid: String) {
        let ref = database.collection("munchies").document(uid).collection("selections")
        
        ref.getDocuments { queries, err in
            if let err = err {
                print("Error reading from database: \(err.localizedDescription)")
            } else {
                print("Success reading from database.")
                let documents = queries!.documents
                
                for doc in documents {
                    doc.reference.delete()
                }
                print("Successfully deleted documents.")
            }
        }
    }
    
    func writeEmailPassword(uid: String, info: [String : Any]) -> String {
        let res : String = ""
        database.collection("munchies").document(uid).setData(info) { err in
            if let err = err {
                print("Error writing to database: \(err.localizedDescription)")
            } else {
                print("Success writing to database.")
            }
        }
        return res
    }
    
    func writeSelections(uid: String, info: [String : Any]) -> String {
        let res : String = ""
        
        database.collection("munchies").document(uid).collection("selections").addDocument(data: info) { err in
            if let err = err {
                print("Error writing to database: \(err.localizedDescription)")
            } else {
                print("Success writing to database.")
            }
        }
        return res
    }
    
    func alert(message: String, title: String = "") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        return alertController
    }
}
