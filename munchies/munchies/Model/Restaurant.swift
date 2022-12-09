//
//  Restaurant.swift
//  munchies
//
//  Created by junior taeza on 12/3/22.
//

import Foundation

struct Restaurant : Decodable {
    let name : String?
    let phone_number : Int?
    let address : RestaurantAddress?
    let food_photos : [String]?
    let logo_photos : [String]?
    let is_open : Bool?
    let miles : Double?
}
