//
//  User.swift
//  munchies
//
//  Created by junior taeza on 12/4/22.
//

import Foundation

class User {
    public static let user = User()
    
    var uid : String = ""
    var email : String = ""
    var password : String = ""
    var selection : String = ""
    var distance : Int = 0
    var budget : Int = 0
    var latitude : Double = 0.0
    var longitude : Double = 0.0
}
